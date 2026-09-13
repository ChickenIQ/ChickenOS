#!/usr/bin/env bash

# Replace fedora pkgs
dnf distro-sync -y --allowerasing

# Install Linux Firmware
dnf install -y linux-firmware