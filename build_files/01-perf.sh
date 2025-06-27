#!/bin/bash
set -ouex pipefail

# Enable Overclocking on AMD
echo 'kargs = ["amdgpu.ppfeaturemask=0xffffffff"]' > /usr/lib/bootc/kargs.d/00-amd.toml

# Setup Packages
dnf5 -y install --allowerasing cachyos-settings scx-scheds lact
systemctl enable scx.service lactd.service


# Replace Kernel
dnf5 -y install sbsigntools kernel-cachyos-lto kernel-cachyos-lto-devel-matched
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on


# Regenerate Initramfs
export KERNEL=$(basename -a /usr/src/kernels/*/) 
export DRACUT_NO_XATTR=1

dracut --no-hostonly --kver $KERNEL --reproducible -v --add ostree -f /lib/modules/$KERNEL/initramfs.img
chmod 0600 /lib/modules/$KERNEL/initramfs.img


# Install UMU
dnf5 -y --enablerepo=copr:copr.fedorainfracloud.org:gloriouseggroll:nobara-42 install umu-launcher


# Install Proton-CachyOS
URL=$(curl -s https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest | grep browser_download_url | cut -d\" -f4 | grep 'x86_64_v3\.tar\.xz$')
INSTALL_DIR=/usr/share/steam/compatibilitytools.d/Proton-System
TMP_DIR=/tmp/proton

mkdir -p $INSTALL_DIR $TMP_DIR
curl -Lo $TMP_DIR/proton.tar.xz $URL
tar -xf $TMP_DIR/proton.tar.xz -C $TMP_DIR
mv $TMP_DIR/proton-cachyos*/* $INSTALL_DIR && rm -rf $TMP_DIR

cat > $INSTALL_DIR/compatibilitytool.vdf <<'EOF'
"compatibilitytools"
{
  "compat_tools"
  {
    "Proton-System"
    {
      "display_name" "Proton-System"
      "from_oslist"  "windows"
      "to_oslist"    "linux"
      "install_path" "."
    }
  }
}
EOF

