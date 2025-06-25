#!/bin/bash
set -ouex pipefail

# Install Keys
install -Dm644 /run/secrets/secureboot /etc/pki/akmods/private/private_key.priv
install -Dm644 /etc/pki/ChickenOS.der /etc/pki/akmods/certs/public_key.der

# Setup Package Managers
dnf5 --exclude fedora-flathub-remote -y install dnf5-plugins flatpak

# Setup Repos
curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y copr enable atim/starship

# Rename Release
sed -i -E -e '/^VERSION=/ s/\([^)]*\)/(ChickenOS)/' -e '/^PRETTY_NAME=/ s/\([^)]*\)/(ChickenOS)/' /usr/lib/os-release