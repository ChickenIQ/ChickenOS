#!/bin/bash
set -ouex pipefail
[ "$VARIANT" != "nvidia" ] && exit 0

echo 'kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]' > /usr/lib/bootc/kargs.d/00-nvidia.toml
dnf5 config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo

export KERNEL=$(basename -a /usr/src/kernels/*/)
dnf5 -y install nvidia-driver

akmods --force --kernels $KERNEL
modinfo /usr/lib/modules/$KERNEL/extra/nvidia/nvidia-drm.ko.xz

