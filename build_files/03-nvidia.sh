#!/bin/bash
set -ouex pipefail
[ "$VARIANT" != "nvidia" ] && exit 0


# Install Driver
dnf5 -y install kernel-cachyos-lto-nvidia-open xorg-x11-drv-nvidia-cuda
# akmods --force --kernels $(basename -a /usr/src/kernels/*/)


# Early Load NVIDIA Drivers
sed -i "s@omit_drivers@force_drivers@g" /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf
sed -i "s@ nvidia @ i915 amdgpu nvidia @g" /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf


# # Setup Sysusers
# cat > /usr/lib/sysusers.d/akmods.conf <<'EOF'
# u akmods 967:966 "User is used by akmods to build akmod packages" /var/cache/akmods/ /sbin/nologin
# g akmods 966
# EOF


# Setup Kargs
cat > /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]
EOF
