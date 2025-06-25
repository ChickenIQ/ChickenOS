#!/bin/bash
set -ouex pipefail

dnf5 clean all
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -rf {} \;

mkdir -p /tmp /var/tmp
chmod 1777 /tmp /var/tmp
rm -rf /tmp/* /var/tmp/* /boot/*

ostree container commit