#!/bin/bash
set -ouex pipefail

# Install KDE
dnf5 --exclude \
  plasma-welcome \
  kdebugsettings \
  kinfocenter \
  khelpcenter \
  kcharselect \
  kde-connect \
  kjournald \
  toolbox \
  firefox \
  kwrite \
  kfind \
  krfb \
  -y install \
  plasma-firewall \
  @kde-desktop 

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

