#!/usr/bin/env -S bash -euo pipefail

[ "$ISO" = "1" ] || exit 0

# Install dependencies
PACKAGES="dracut-live grub2-efi-x64-cdboot grub2-pc-modules xorriso squashfs-tools isomd5sum jq mokutil"
dnf install -y $PACKAGES && dnf clean all && rm -rf /var/lib/dnf/repos


# Create the initramfs with required modules
kver=$(kernel-install list --json pretty | jq -r '.[] | select(.has_kernel == true) | .version')
mkdir -p /boot/efi /usr/lib/image-builder/bootc "$(realpath /root)"
cp -a /usr/lib/efi/*/*/EFI /boot/efi/

DRACUT_NO_XATTR=1 dracut --stdlog 1 --force --zstd --reproducible --no-hostonly \
  --add "dmsquash-live dmsquash-live-autooverlay" \
  "/usr/lib/modules/${kver}/initramfs.img" "${kver}"

cat > /usr/lib/systemd/system/chickenos-secureboot.service <<'UNIT'
[Service]
Environment=KEY=/usr/share/chickenos/secureboot.der
Environment=PASS=chickenos
ExecStart=/bin/sh -c 'printf "$PASS\\n$PASS\\n" | mokutil --import "$KEY"'
ExecStartPost=systemctl reboot
UNIT


# Create grub config
PARAMS="/images/pxeboot/vmlinuz root=live:CDLABEL=ChickenOS rd.live.image selinux=0"
cat > /usr/lib/image-builder/bootc/iso.yaml <<YAML
label: "ChickenOS"

grub2:
  timeout: 30
  entries:
    - name: "Start ChickenOS"
      linux: "$PARAMS rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
      initrd: "/images/pxeboot/initrd.img"

    - name: "Setup Secureboot"
      linux: "$PARAMS systemd.unit=chickenos-secureboot.service rd.driver.blacklist=nvidia modprobe.blacklist=nvidia"
      initrd: "/images/pxeboot/initrd.img"
YAML
