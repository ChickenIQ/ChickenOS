comma := ,
OUTPUT := out
VM_DISK_SIZE := 32G
CACHE := $(OUTPUT)/cache
VM_DISK := $(OUTPUT)/ChickenOS.raw
SECUREBOOT_SECRET = $(if $(wildcard $(SECUREBOOT_KEY)),--secret=id=secureboot$(comma)src="$(SECUREBOOT_KEY)")
BUILDER := ghcr.io/osbuild/image-builder:sha-218217cd10eaa88c91e082ce506f2412d288b22c
IMAGE := localhost/chickenos
ISO ?= 0
VM ?= 0


define build_image
sudo podman build \
	--build-arg ISO=$(ISO) \
	--build-arg VM=$(VM) \
	-f Containerfile \
	-t $(IMAGE):$(2) \
	--target $(1) \
	$(3) .
endef

define run_builder
sudo podman run --rm --privileged \
	-v /var/lib/containers/storage:/var/lib/containers/storage \
	-v "$(CURDIR)/$(CACHE):/var/cache/image-builder/store" \
	-v "$(CURDIR)/$(CACHE):/output" \
	$(BUILDER) build
endef

define run_vm
qemu-system-x86_64 \
	-device virtio-vga,xres=1920,yres=1080 \
	-audio driver=pipewire,model=hda \
	-display sdl \
	-enable-kvm \
	-cpu host \
	-smp 8 \
	-m 8G
endef

.PHONY: image image-live shell vm vm-build iso

image:
	$(call build_image,config,main,$(SECUREBOOT_SECRET))

image-live: image
	$(call build_image,live,live)

shell: VM=1
shell: image
	sudo podman run --rm -it $(IMAGE):main bash

vm:
	@$(run_vm) -drive file=$(VM_DISK),format=raw,if=virtio

vm-build: VM=1
vm-build: image-live
	mkdir -p $(OUTPUT)
	truncate -s $(VM_DISK_SIZE) $(VM_DISK)

	sudo podman run --rm --privileged \
		-e PATH="/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
		-v /var/lib/containers:/var/lib/containers \
		-v "$(CURDIR)/$(OUTPUT):/out" \
		-v /dev:/dev \
		--pid=host \
		$(IMAGE):live \
		bootc install to-disk \
			--filesystem=ext4 \
			--generic-image \
			--via-loopback \
			--wipe \
			/out/ChickenOS.raw

	$(MAKE) vm

iso: ISO=1
iso: image-live
	mkdir -p $(CACHE)

	@$(run_builder) \
		--bootc-ref $(IMAGE):live \
		--bootc-default-fs ext4 \
		bootc-generic-iso

	sudo mv $(CACHE)/bootc-*/bootc-*.iso $(OUTPUT)/ChickenOS.iso
	sudo chown "$$USER" $(OUTPUT)/ChickenOS.iso
