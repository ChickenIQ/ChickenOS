#!/usr/bin/env bash

# Install Packages
dnf -y install flatpak nix-daemon


# Setup Nix Mount
cat > /usr/lib/systemd/system/nix.mount <<'EOF'
[Unit]
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

systemctl enable nix.mount nix-daemon.socket


# Fix /opt
rm -rf /opt
mkdir /opt