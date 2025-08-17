#!/bin/bash
set -ouex pipefail
[ "$VARIANT" != "nvidia" ] && exit 0


# Install Driver
dnf5 -y install nvidia-driver nvidia-driver-cuda cuda-devel


# Early Load NVIDIA Drivers
sed -i "s@omit_drivers@force_drivers@g" /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf
sed -i "s@ nvidia @ i915 amdgpu nvidia @g" /usr/lib/dracut/dracut.conf.d/99-nvidia-dracut.conf


# Setup Kargs
cat > /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1", "nvidia.NVreg_EnableGpuFirmware=0"]
EOF
