#!/usr/bin/env bash

# Setup dnf
dnf install -y dnf5-plugins
dnf config-manager setopt max_parallel_downloads=10


# Add Terra Repos
dnf config-manager addrepo --from-repofile=https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/terra.repo
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo
dnf install -y terra-release terra-release-extras terra-release-mesa


# Enable COPR Repos
dnf copr enable -y ublue-os/packages
dnf copr enable -y atim/starship
dnf copr enable -y imput/helium


# Configure Repos
dnf config-manager setopt 'copr:copr.fedorainfracloud.org:ublue-os:packages.includepkgs=bazaar'
dnf config-manager setopt fedora-cisco-openh264.enabled=1
