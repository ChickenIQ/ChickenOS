#!/bin/bash
set -ouex pipefail

if [ "$VARIANT" != "nvidia" ]; then
  dnf5 -y copr enable bieszczaders/kernel-cachyos-lto
  KERNEL_PKGS="kernel-cachyos-lto kernel-cachyos-lto-devel-matched"
else
  dnf5 -y copr enable bieszczaders/kernel-cachyos
  KERNEL_PKGS="kernel-cachyos kernel-cachyos-devel-matched"
fi


# Setup Packages
dnf5 -y install --allowerasing cachyos-settings scx-scheds sbsigntools 
echo "SCX_SCHEDULER=scx_lavd" > /etc/default/scx && systemctl enable scx.service


# Replace Kernel
dnf5 -y install $KERNEL_PKGS 
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on
