#!/usr/bin/env -S bash -euo pipefail

# Add repos
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf install -y dnf5-plugins

dnf config-manager setopt fedora-cisco-openh264.enabled=1
dnf copr enable -y atim/starship
dnf copr enable -y imput/helium
