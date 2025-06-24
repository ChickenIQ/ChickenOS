#!/bin/bash
set -ouex pipefail

# Minimize System
rm -r /etc/skel/.mozilla
dnf5 -y remove \
  plasma-browser-integration \
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
