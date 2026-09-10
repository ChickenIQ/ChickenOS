#!/usr/bin/env -S bash -euo pipefail

# Cleanup
rm -rf /usr/etc
rm -rf /tmp/* || true
rm -rf /boot && mkdir /boot

# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -rf {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;

# Fix /var/tmp 
mkdir -p /var/tmp
chmod -R 1777 /var/tmp
