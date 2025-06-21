#!/bin/bash

set -ouex pipefail

dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y config-manager setopt fedora-cisco-openh264.enabled=1
dnf5 -y update
dnf5 -y install rpmfusion-free-appstream-data rpmfusion-nonfree-appstream-data

dnf5 -y remove firefox kwrite kfind kdebugsettings khelpcenter plasma-welcome krfb kde-connect kcharselect kjournald
dnf5 -y autoremove 

dnf5 -y install vim

flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
