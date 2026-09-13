#!/usr/bin/env bash

# Nvidia
dnf download --destdir=/rpms nvidia-driver
dnf install -y akmod-nvidia

cat > /out/usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = [ "rd.driver.blacklist=nouveau,nova-core" ]
EOF

# OpenRazer
dnf install -y akmod-openrazer

# V4L2 Loopback
dnf install -y akmod-v4l2loopback