#!/bin/bash
set -ouex pipefail

# Setup Repos
dnf5 -y install dnf5-plugins
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y copr enable atim/starship

# # Setup Flatpak
# curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
# systemctl disable flatpak-add-fedora-repos.service
