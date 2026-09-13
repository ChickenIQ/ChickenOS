#!/usr/bin/env bash

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

