#!/usr/bin/env -S bash -euo pipefail

# Run all scripts in the layer
for sc in $(printf '%s\n' "/ctx/$1"/*.sh | sort -V); do
  bash -euo pipefail "$sc"
done


# Cleanup Garbage
rm -rf /var/log 
rm -rf /var/lib/dnf/repos
rm -rf /tmp/* /var/tmp/* || true


# Fix dirs
mkdir -p /tmp /var/tmp
chmod 1777 /tmp /var/tmp


# More recurring garbage cleanup
rm -rf /var/lib/{AccountsService,PackageKit,flatpak,authselect,geoclue}