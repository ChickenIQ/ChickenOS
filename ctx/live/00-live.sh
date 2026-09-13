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


# Autologin user
cat >> /etc/greetd/config.toml <<'EOF'
[initial_session]
command = "/usr/bin/chickenos-session"
user = "user"
EOF



# Init user keyring
cat > /etc/systemd/user/chickenos-live-keyring.service <<'EOF'
[Unit]
Wants=gnome-keyring-daemon.socket
After=gnome-keyring-daemon.socket

[Install]
WantedBy=default.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "printf '\0' | /usr/bin/gnome-keyring-daemon --unlock"
EOF

systemctl --global enable chickenos-live-keyring.service

# Disable bootloader updates for live images
systemctl mask bootloader-update.service
