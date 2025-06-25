#!/bin/bash
set -ouex pipefail

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
# dnf5 -y install \
#   plasma-firewall \
#   ananicy-cpp \
#   scx-scheds \
#   distrobox \
#   fastfetch \
#   starship \
#   nvtop \
#   kate \
#   btop \
#   fish \
#   vim 


# bootc-minimal-blus test
dnf5 -y install \
  attr \
  bash-completion \
  hostname \
  iproute \
  jq \
  less \
  vim-minimal \
  podman skopeo \
  crun criu criu-libs \
  cryptsetup \
  lvm2 \
  tar \
  zram-generator \
  iptables-nft \
  NetworkManager \
  openssh-clients \
  openssh-server \
  linux-firmware \
  polkit \
  sudo \
  tzdata \
  rpm-ostree nss-altfiles \
  fwupd \



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


# Enable Services
systemctl enable \
  podman.service \
  scx.service
