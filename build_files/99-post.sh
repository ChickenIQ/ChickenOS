#!/bin/bash
set -ouex pipefail


# Regenerate Initramfs
export DRACUT_NO_XATTR=1 KERNEL=$(basename -a /usr/lib/modules/*/) 
dracut --no-hostonly --kver $KERNEL --reproducible -v --add ostree -f /usr/lib/modules/$KERNEL/initramfs.img


# Cleanup
dnf5 clean all
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -rf {} \;


# Fix Tmp
mkdir -p /tmp /var/tmp
chmod 1777 /tmp /var/tmp
rm -rf /tmp/* /var/tmp/* /boot/*


# Rename Release
sed -i -E -e '/^VERSION=/ s/\([^)]*\)/(ChickenOS)/' -e '/^PRETTY_NAME=/ s/\([^)]*\)/(ChickenOS)/' /usr/lib/os-release


# Finalize
ostree container commit