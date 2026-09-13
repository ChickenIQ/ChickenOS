#!/usr/bin/env bash

# Install Greeter
dnf install -y greetd noctalia-greeter

cat > /usr/lib/sysusers.d/chickenos-greeter.conf <<'EOF'
u greeter - - /var/lib/noctalia-greeter /usr/bin/nologin
EOF

cat > /usr/lib/tmpfiles.d/chickenos-greeter.conf <<'EOF'
d /var/lib/noctalia-greeter 0750 greeter greeter -
d /var/lib/greetd/.config 0755 greetd greetd -
d /var/lib/greetd/.config/systemd 0755 greetd greetd -
d /var/lib/greetd/.config/systemd/user 0755 greetd greetd -
L /var/lib/greetd/.config/systemd/user/xdg-desktop-portal.service - - - - /dev/null
EOF


# Setup Desktop Session
DIR="/etc/greetd"
mkdir -p "$DIR"

cat > "$DIR/config.toml" <<'EOF'
[terminal]
vt = 1

[default_session]
command = "/usr/bin/noctalia-greeter-session"
user = "greeter"
EOF

systemctl enable greetd.service
systemctl set-default graphical.target
