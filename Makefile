SECUREBOOT_SECRET = $(if $(wildcard $(SECUREBOOT_KEY)),--secret=id=secureboot$(comma)src="$(SECUREBOOT_KEY)")
BUILDER := ghcr.io/osbuild/image-builder:sha-218217cd10eaa88c91e082ce506f2412d288b22c

IMAGE := localhost/chickenos
IMAGE_BASE := $(IMAGE):base
IMAGE_LIVE := $(IMAGE):live

OUTPUT := out
CACHE := $(OUTPUT)/cache
comma := ,

VM_DISK := $(OUTPUT)/ChickenOS.raw
VM_DISK_SIZE := 32G

.PHONY: \
	image-live \
	image-vm \
	image \
	shell \
	iso \
	vm \
	vm-build

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

image:
	sudo podman build $(SECUREBOOT_SECRET) -f Containerfile -t $(IMAGE_BASE) .

image-live: image
	sudo podman build -f Containerfile.live -t $(IMAGE_LIVE) .

image-vm: image
	sudo podman build -f Containerfile.live -t $(IMAGE_LIVE) --build-arg VM=1 .

shell: image
	sudo podman run --rm -it $(IMAGE_BASE) bash

iso: image-live
	mkdir -p $(CACHE)
	@$(run_builder) --bootc-ref $(IMAGE_LIVE) --bootc-default-fs ext4 bootc-generic-iso
	sudo mv $(CACHE)/bootc-*/bootc-*.iso $(OUTPUT)/ChickenOS.iso
	sudo chown "$$USER" $(OUTPUT)/ChickenOS.iso

vm:
	@$(run_vm) -drive file=$(VM_DISK),format=raw,if=virtio

vm-build: image-vm
	mkdir -p $(OUTPUT)
	truncate -s $(VM_DISK_SIZE) $(VM_DISK)

	sudo podman run --rm --privileged \
		-e PATH="/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
		-v /var/lib/containers:/var/lib/containers \
		-v "$(CURDIR)/$(OUTPUT):/out" \
		-v /dev:/dev --pid=host \
		$(IMAGE_LIVE) \
		bootc install to-disk \
			--filesystem=ext4 \
			--generic-image \
			--via-loopback \
			--wipe \
			/out/ChickenOS.raw

	$(MAKE) vm
