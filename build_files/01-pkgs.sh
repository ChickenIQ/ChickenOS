#!/bin/bash
set -ouex pipefail


dnf5 -y install @kde-desktop


# Minimize System
# rm -r /etc/skel/.mozilla
# dnf5 -y remove \
#   plasma-browser-integration \
#   fedora-chromium-config-kde \
#   fedora-chromium-config \
#   fedora-flathub-remote \
#   fedora-bookmarks \
#   firewall-config \
#   plasma-welcome \
#   kdebugsettings \
#   kinfocenter \
#   khelpcenter \
#   kcharselect \
#   kde-connect \
#   kjournald \
#   toolbox \
#   firefox \
#   kwrite \
#   kfind \
#   krfb 


# Install Packages
dnf5 -y install \
  plasma-firewall \
  ananicy-cpp \
  scx-scheds \
  distrobox \
  fastfetch \
  starship \
  nvtop \
  kate \
  btop \
  fish \
  vim 

# Enable Services
systemctl enable \
  podman.service \
  scx.service


# Sysusers
cat >/usr/lib/sysusers.d/nm-openvpn.conf <<'EOF'
u nm-openvpn 971:971 "Default user for running openvpn spawned by NetworkManager" / /sbin/nologin
g nm-openvpn 971
EOF

cat >/usr/lib/sysusers.d/nm-openconnect.conf <<'EOF'
u nm-openconnect 970:970 "NetworkManager user for OpenConnect" / /sbin/nologin
g nm-openconnect 970
EOF

cat >/usr/lib/sysusers.d/abrt.conf <<'EOF'
u abrt 173:173 - /etc/abrt /etc/abrt /sbin/nologin
g abrt 173
EOF

cat >/usr/lib/sysusers.d/nm.conf <<'EOF'
g utempter 35
EOF
