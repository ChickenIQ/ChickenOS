#!/bin/bash
set -ouex pipefail

pkgs_remove=(
  plasma-browser-integration
  fedora-chromium-config-kde
  fedora-chromium-config
  fedora-flathub-remote
  mozilla-filesystem
  fedora-bookmarks
  firewall-config
  plasma-welcome
  kdebugsettings
  kinfocenter
  khelpcenter
  kcharselect
  kde-connect
  kjournald
  toolbox
  firefox
  kwrite
  kfind
  krfb
)


pkgs_install=(
  plasma-firewall
  wireguard-tools
  ananicy-cpp
  scx-scheds
  distrobox
  fastfetch
  starship
  thefuck
  steam
  nvtop
  tldr
  kate
  btop
  fish
  vim
)

svc_enable=(
  podman.service
  scx.service
)


# Setup Packages
dnf5 -y install $(echo "${pkgs_install[*]}")
systemctl enable $(echo "${svc_enable[*]}")
dnf5 -y remove $(echo "${pkgs_remove[*]}")


# Configure Packages
cat >/etc/default/scx <<'EOF'
SCX_SCHEDULER=scx_lavd
EOF


# Replace Kernel
dnf5 -y install sbsigntools kernel-cachyos kernel-cachyos-devel-matched 
rpm --nodeps --erase kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on
