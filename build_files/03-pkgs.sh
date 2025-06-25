#!/bin/bash
set -ouex pipefail

# Install Packages
dnf5 -y install \
  ananicy-cpp \
  scx-scheds \
  distrobox \
  fastfetch \
  starship \
  nvtop \
  btop \
  fish \
  vim 

# Configure Packages
cat >/etc/default/scx <<'EOF'
SCX_SCHEDULER=scx_lavd
EOF

# Enable Services
systemctl enable \
  podman.service \
  scx.service


