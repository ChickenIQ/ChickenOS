#!/bin/bash
set -ouex pipefail


# Install Keys
if [ -f /run/secrets/secureboot ]; then
  findmnt -n -t tmpfs /etc/pki/akmods > /dev/null || { echo "/etc/pki/akmods is NOT mounted as tmpfs"; exit 1; }
  install -Dm644 /run/secrets/secureboot /etc/pki/akmods/private/private_key.priv
  install -Dm644 /etc/pki/ChickenOS.der /etc/pki/akmods/certs/public_key.der
fi 


# Setup Flatpak
curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service


# Setup RPM Fusion
dnf5 -y install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
dnf5 -y config-manager setopt fedora-cisco-openh264.enabled=1


# Setup Other Repos
repo_copr=(
  alternateved/keyd
  atim/starship
  petersen/nix
  ilyaz/LACT
)

repo_file=(
  https://packages.microsoft.com/yumrepos/vscode/config.repo
  https://negativo17.org/repos/fedora-spotify.repo
)

for repo in "${repo_copr[@]}"; do dnf5 -y copr enable "$repo" > /dev/null; done
for repo in "${repo_file[@]}"; do dnf5 -y config-manager addrepo --from-repofile="$repo"; done
