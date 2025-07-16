#!/bin/bash
set -ouex pipefail

# Enable Overclocking
dnf5 -y install lact
systemctl enable lactd.service
echo 'kargs = ["amdgpu.ppfeaturemask=0xffffffff"]' > /usr/lib/bootc/kargs.d/00-amd.toml


dnf5 -y install akmod-nvidia xorg-x11-drv-nvidia-cuda
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf
akmods --force --kernels $(basename -a /usr/src/kernels/*/)


# Setup Kernel Arguments
cat > /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1", "nvidia.NVreg_EnableGpuFirmware=0"]
EOF


# Setup Sysusers
cat > /usr/lib/sysusers.d/akmods.conf <<'EOF'
u akmods 967:966 "User is used by akmods to build akmod packages" /var/cache/akmods/ /sbin/nologin
g akmods 966
EOF