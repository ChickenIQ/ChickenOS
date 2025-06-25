#!/bin/bash
set -ouex pipefail
[ "$VARIANT" != "nvidia" ] && exit 0

dnf5 -y --repofrompath=https://negativo17.org/repos/fedora-nvidia.repo install nvidia-driver

echo 'kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]' > /usr/lib/bootc/kargs.d/00-nvidia.toml
export KERNEL=$(basename -a /usr/src/kernels/*/)

akmods --force --kernels $KERNEL
modinfo /usr/lib/modules/$KERNEL/extra/nvidia/nvidia-drm.ko.xz

