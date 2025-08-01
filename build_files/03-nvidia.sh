#!/bin/bash
set -ouex pipefail
[ "$VARIANT" != "nvidia" ] && exit 0


# Install Driver
dnf5 -y install kernel-cachyos-lto-nvidia-open xorg-x11-drv-nvidia-cuda


# Early Load NVIDIA Drivers
sed -i "s@omit_drivers@force_drivers@g" /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf
sed -i "s@ nvidia @ i915 amdgpu nvidia @g" /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf


# Setup Kargs
cat > /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]
EOF
