#!/bin/bash
set -ouex pipefail


# Install Keys
if [ -f /run/secrets/secureboot ]; then
  findmnt -n -t tmpfs /etc/pki/akmods > /dev/null || { echo "/etc/pki/akmods is NOT mounted as tmpfs"; exit 1; }
  install -Dm644 /run/secrets/secureboot /etc/pki/akmods/private/private_key.priv
  install -Dm644 /etc/pki/ChickenOS.der /etc/pki/akmods/certs/public_key.der
fi 


# Setup Repos
dnf5 -y install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
dnf5 -y config-manager setopt fedora-cisco-openh264.enabled=1
dnf5 -y config-manager addrepo --from-repofile=https://packages.microsoft.com/yumrepos/vscode/config.repo
dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-spotify.repo
dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y copr enable bieszczaders/kernel-cachyos-lto
dnf5 -y copr enable alternateved/keyd
dnf5 -y copr enable atim/starship
dnf5 -y copr enable petersen/nix
dnf5 -y copr enable ilyaz/LACT


# Setup Flatpak
curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service


# Rename Release
sed -i -E -e '/^VERSION=/ s/\([^)]*\)/(ChickenOS)/' -e '/^PRETTY_NAME=/ s/\([^)]*\)/(ChickenOS)/' /usr/lib/os-release


# Disable Service
systemctl disable NetworkManager-wait-online.service
