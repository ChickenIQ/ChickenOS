#!/bin/bash
set -ouex pipefail


# Setup Packages
dnf5 -y install --allowerasing scx-scheds sbsigntools openssl
echo "SCX_SCHEDULER=scx_lavd" > /etc/default/scx && systemctl enable scx.service


# Replace Kernel
dnf5 -y install kernel-xanmod-edge kernel-xanmod-edge-devel-matched
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on
