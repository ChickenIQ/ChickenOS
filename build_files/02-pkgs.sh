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
  distrobox
  fastfetch
  starship
  thefuck
  steam
  nvtop
  keyd
  tldr
  kate
  btop
  fish
  vim
)


# Setup Packages
dnf5 -y install $(echo "${pkgs_install[*]}")
dnf5 -y remove $(echo "${pkgs_remove[*]}")
systemctl enable podman.service

