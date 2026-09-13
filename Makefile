BUILDER := ghcr.io/osbuild/image-builder:sha-218217cd10eaa88c91e082ce506f2412d288b22c
IMAGE := localhost/chickenos

BUILD := $(CURDIR)/build
CACHE := $(BUILD)/cache
comma := ,

SECUREBOOT_SECRET = $(if $(wildcard $(SECUREBOOT_KEY)),--secret=id=secureboot$(comma)src="$(SECUREBOOT_KEY)")
VM_DISK := $(BUILD)/ChickenOS.raw
VM_DISK_SIZE := 32G
ISO ?= 0
VM ?= 0

define build_image
sudo podman build \
	--build-arg ISO=$(ISO) \
	--build-arg VM=$(VM) \
	-f Containerfile \
	-t $(IMAGE):$(2) \
	--target $(1) $(3) .
endef

define run_builder
sudo podman run --rm --privileged \
	-v /var/lib/containers/storage:/var/lib/containers/storage \
	-v "$(CACHE):/var/cache/image-builder/store" \
	-v "$(CACHE):/output" \
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

.PHONY: image image-live shell shell-live vm vm-build iso clean

image:
	$(call build_image,config,main,$(SECUREBOOT_SECRET))

image-live: image
	$(call build_image,live,live)

shell: VM=1
shell: image
	sudo podman run --rm -it $(IMAGE):main bash

shell-live: VM=1
shell-live: image-live
	sudo podman run --rm -it $(IMAGE):live bash

vm:
	@$(run_vm) -drive file=$(VM_DISK),format=raw,if=virtio

vm-build: VM=1
vm-build: image-live
	mkdir -p $(BUILD)
	truncate -s $(VM_DISK_SIZE) $(VM_DISK)

	sudo podman run --rm --privileged \
		-e PATH="/run/current-system/sw/bin:/bin" \
		-v /var/lib/containers:/var/lib/containers \
		-v /dev:/dev --pid=host \
		-v "$(BUILD):/build" \
		$(IMAGE):live \
		bootc install to-disk \
			--filesystem=ext4 \
			--generic-image \
			--via-loopback \
			--wipe \
			/build/ChickenOS.raw

	$(MAKE) vm

iso: ISO=1
iso: image-live
	mkdir -p $(CACHE)

	@$(run_builder) \
		--bootc-ref $(IMAGE):live \
		--bootc-default-fs ext4 \
		bootc-generic-iso

	sudo mv $(CACHE)/bootc-*/bootc-*.iso $(BUILD)/ChickenOS.iso
	sudo chown "$$USER" $(BUILD)/ChickenOS.iso

clean:
	@case "$(abspath $(BUILD))" in "$(CURDIR)"/*) ;; *) echo "Refusing to clean: $(BUILD)"; exit 1 ;; esac
	sudo podman image prune --all --force --build-cache
	sudo rm -rf -- "$(abspath $(BUILD))"
