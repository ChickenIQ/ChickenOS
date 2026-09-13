#!/usr/bin/env bash

# Add repos
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf install -y dnf5-plugins


# Enable COPR Repos
dnf copr enable -y ublue-os/packages
dnf copr enable -y atim/starship
dnf copr enable -y imput/helium


# Configure Repos
dnf config-manager setopt 'copr:copr.fedorainfracloud.org:ublue-os:packages.includepkgs=bazaar'
dnf config-manager setopt fedora-cisco-openh264.enabled=1
