#!/bin/bash
set -ouex pipefail

# Setup Repos
curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service
dnf5 -y copr enable atim/starship

# Minimize System
dnf5 -y remove \
  fedora-chromium-config-kde \
  fedora-chromium-config \
  fedora-flathub-remote \
  fedora-bookmarks \
  firewall-config \
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
  krfb 

# Install Packages
dnf5 -y install \
  plasma-firewall \
  distrobox \
  fastfetch \
  starship \
  nvtop \
  kate \
  btop \
  fish \
  vim 

# Services
systemctl enable podman.service