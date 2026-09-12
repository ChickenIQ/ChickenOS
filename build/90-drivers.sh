#!/usr/bin/env -S bash -euo pipefail

# Install NVIDIA drivers
dnf install -y akmod-nvidia

cat > /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = [
  "rd.driver.blacklist=nouveau",
  "modprobe.blacklist=nouveau",
  "nvidia-drm.modeset=1",
]
EOF

# Build initramfs and kmods
mkdir -p "$(realpath /root)"

for kver in $(basename -a /usr/lib/modules/*/); do
  rm -f /var/cache/akmods/nvidia/*-for-"$kver".failed.log
  akmods --force --kernels "$kver"

  failed=$(find /var/cache/akmods/nvidia -name "*for-$kver.failed.log" -print -quit)
  if [ -n "$failed" ]; then
    cat "$failed"
    exit 1
  fi

  DRACUT_NO_XATTR=1 dracut \
    --stdlog 1 --force --zstd --reproducible --no-hostonly \
    "/usr/lib/modules/$kver/initramfs.img" "$kver"
done
