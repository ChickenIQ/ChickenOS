#!/bin/bash
set -ouex pipefail


# Regenerate Initramfs
export DRACUT_NO_XATTR=1
KERNEL=$(basename -a /usr/src/kernels/*/) 
dracut --no-hostonly --kver $KERNEL --reproducible -v --add ostree -f /lib/modules/$KERNEL/initramfs.img


# Cleanup
dnf5 clean all
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -rf {} \;


# Fix Tmp
mkdir -p /tmp /var/tmp
chmod 1777 /tmp /var/tmp
rm -rf /tmp/* /var/tmp/* /boot/*


ostree container commit