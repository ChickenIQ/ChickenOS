#!/bin/bash
set -ouex pipefail
[ "$VARIANT" != "nvidia" ] && exit 0


# Install Driver
dnf5 config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo
dnf5 -y install nvidia-driver


# Ensure KMOD Is Built
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