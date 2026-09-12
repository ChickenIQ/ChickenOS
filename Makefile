BUILDER := ghcr.io/osbuild/image-builder:sha-218217cd10eaa88c91e082ce506f2412d288b22c

IMAGE := localhost/chickenos
IMAGE_NESTED := $(IMAGE):nested
IMAGE_BASE := $(IMAGE):base
IMAGE_DISK := $(IMAGE):disk
IMAGE_ISO := $(IMAGE):iso

OUTPUT := out
CACHE := $(OUTPUT)/cache

DISK := $(OUTPUT)/ChickenOS.raw
DISK_SIZE := 32G

.PHONY: \
	vm-disk-build \
	vm-iso-build \
	image-nested \
	image-disk \
	image-iso \
	vm-disk \
	vm-iso \
	nested \
	image \
	shell \
	disk \
	iso

define run_builder
trap 'sudo podman kill chickenos-builder >/dev/null 2>&1 || true' INT TERM; \
sudo podman run --rm --name chickenos-builder --privileged \
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
	sudo podman build -f Containerfile -t $(IMAGE_BASE) .

image-disk: image
	sudo podman build -f Containerfile.disk -t $(IMAGE_DISK) .

image-iso: image-disk
	sudo podman build -f Containerfile.iso -t $(IMAGE_ISO) .

image-nested: image-disk
	sudo podman build -f Containerfile.nested -t $(IMAGE_NESTED) .

shell: image-disk
	sudo podman run --rm -it $(IMAGE_DISK) bash

disk: image-disk
	mkdir -p $(OUTPUT)
	truncate -s $(DISK_SIZE) $(DISK)

	sudo podman run --rm --privileged \
		--pid=host \
		-e PATH="/run/current-system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
		-v /dev:/dev \
		-v /var/lib/containers:/var/lib/containers \
		-v "$(CURDIR)/$(OUTPUT):/out" \
		$(IMAGE_DISK) \
		bootc install to-disk \
			--filesystem=ext4 \
			--generic-image \
			--via-loopback \
			--wipe \
			/out/ChickenOS.raw

iso: image-iso
	mkdir -p $(CACHE)
	@$(run_builder) \
		--bootc-ref $(IMAGE_ISO) \
		--bootc-default-fs ext4 \
		bootc-generic-iso

	sudo mv $(CACHE)/bootc-*/bootc-*.iso $(OUTPUT)/ChickenOS.iso
	sudo chown "$$USER" $(OUTPUT)/ChickenOS.iso

vm-disk:
	@$(run_vm) \
		-drive file=$(DISK),format=raw,if=virtio

vm-iso:
	@$(run_vm) \
		-cdrom $(OUTPUT)/ChickenOS.iso -boot d

vm-disk-build: disk
	$(MAKE) vm-disk

vm-iso-build: iso
	$(MAKE) vm-iso

nested: image-nested
	sudo podman run --rm -it \
		-v "$$XDG_RUNTIME_DIR/$$WAYLAND_DISPLAY:/run-host/$$WAYLAND_DISPLAY" \
		-e WAYLAND_DISPLAY="$$WAYLAND_DISPLAY" \
		--systemd=always --device=/dev/dri \
		--cap-add=SYS_ADMIN --network=host \
		$(IMAGE_NESTED)