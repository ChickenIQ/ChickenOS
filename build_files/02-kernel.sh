#!/bin/bash
set -ouex pipefail


# Setup Packages
dnf5 -y install --allowerasing cachyos-settings scx-scheds
systemctl enable scx.service

# Replace Kernel
dnf5 -y install sbsigntools kernel-cachyos-lto kernel-cachyos-lto-devel-matched
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on


# Regenerate Initramfs
export KERNEL=$(basename -a /usr/src/kernels/*/) 
export DRACUT_NO_XATTR=1


dracut --no-hostonly --kver $KERNEL --reproducible -v --add ostree -f /lib/modules/$KERNEL/initramfs.img
chmod 0600 /lib/modules/$KERNEL/initramfs.img

