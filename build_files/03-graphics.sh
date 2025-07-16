#!/bin/bash
set -ouex pipefail

# Enable Overclocking
dnf5 -y install lact
systemctl enable lactd.service
echo 'kargs = ["amdgpu.ppfeaturemask=0xffffffff"]' > /usr/lib/bootc/kargs.d/00-amd.toml


# Install Driver
[ "$VARIANT" != "nvidia" ] && exit 0
dnf5 -y install akmod-nvidia xorg-x11-drv-nvidia-cuda
echo "%_with_kmod_nvidia_open 1" > /etc/rpm/macros.nvidia-kmod
akmods --force --kernels $(basename -a /usr/src/kernels/*/)


# Disable Nouveau
cat > /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]
EOF


# Sysusers
cat > /usr/lib/sysusers.d/akmods.conf <<'EOF'
u akmods 967:966 "User is used by akmods to build akmod packages" /var/cache/akmods/ /sbin/nologin
g akmods 966
EOF