#!/usr/bin/env bash

# Install Packages
dnf -y install flatpak nix-daemon

# Clean State
rm -rf /var/lib/{AccountsService,PackageKit,flatpak,authselect,geoclue}

# Setup Nix Mount
cat > /usr/lib/systemd/system/nix.mount <<'EOF'
[Unit]
Before=nix-daemon.service nix-daemon.socket
Description=Mount `/var/lib/nix` on `/nix`
PropagatesStopTo=nix-daemon.service
ConditionPathIsDirectory=/nix
DefaultDependencies=no

[Mount]
DirectoryMode=0755
What=/var/lib/nix
Options=bind
Where=/nix
Type=none

[Install]
RequiredBy=nix-daemon.service
RequiredBy=nix-daemon.socket
EOF

cat > /usr/lib/tmpfiles.d/chickenos-nix.conf <<'EOF'
d /var/lib/nix 0755 root root - -
EOF

install -d -m 0755 /var/lib/nix

systemctl enable nix.mount nix-daemon.socket