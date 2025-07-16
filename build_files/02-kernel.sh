#!/bin/bash
set -ouex pipefail

export KERNEL_PKGS="kernel-cachyos-lto kernel-cachyos-lto-devel-matched"
[ "$VARIANT" = "nvidia" ] && KERNEL_PKGS="kernel-cachyos kernel-cachyos-devel-matched"


# Setup Packages
dnf5 -y install --allowerasing cachyos-settings scx-scheds $KERNEL_PKGS
systemctl enable scx.service


# Replace Kernel
dnf5 -y install sbsigntools kernel-cachyos kernel-cachyos-devel-matched
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on
