#!/usr/bin/env bash

# Set mod_key to ALT for VM builds
[ "$VM" != "1" ] || sed -i 's/^mod_key = .*/mod_key = "ALT"/' /usr/share/chickenos/umbriel/config.toml

# Add live user
cat > /usr/lib/sysusers.d/chickenos-live.conf <<'EOF'
u user 1000 "ChickenOS Live User" /home/user /bin/bash
m user wheel
EOF

install -Dm440 /dev/stdin /etc/sudoers.d/chickenos <<'EOF'
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF

useradd -m -G wheel user
echo 'user:user' | chpasswd

# Disable bootloader updates for live images
systemctl mask bootloader-update.service
