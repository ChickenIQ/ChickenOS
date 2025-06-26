#!/bin/bash
set -ouex pipefail


# Install Keys
findmnt -n -t tmpfs /etc/pki/akmods > /dev/null || { echo "/etc/pki/akmods is NOT mounted as tmpfs"; exit 1; }
install -Dm644 /run/secrets/secureboot /etc/pki/akmods/private/private_key.priv
install -Dm644 /etc/pki/ChickenOS.der /etc/pki/akmods/certs/public_key.der


# Setup Repos
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y copr enable atim/starship


# Setup Flatpak
curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service


# Rename Release
sed -i -E -e '/^VERSION=/ s/\([^)]*\)/(ChickenOS)/' -e '/^PRETTY_NAME=/ s/\([^)]*\)/(ChickenOS)/' /usr/lib/os-release