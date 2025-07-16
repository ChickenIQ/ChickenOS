#!/bin/bash
set -ouex pipefail


# Setup Packages
dnf5 -y install --allowerasing cachyos-settings scx-scheds
systemctl enable scx.service

# Replace Kernel
dnf5 -y install sbsigntools kernel-cachyos-lto kernel-cachyos-lto-devel-matched
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on
