#!/usr/bin/env -S bash -euo pipefail

dnf install -y umbriel-nightly noctalia
ln -s /usr/bin/start-umbriel /usr/bin/chickenos-session

# Ensure defaults are included
DIR="/usr/share/user-tmpfiles.d"
mkdir -p "$DIR"

cat > $DIR/chickenos.conf <<'EOF'
d %h/.config/umbriel 0755 - - -
C %h/.config/umbriel/config.toml - - - - /etc/skel/.config/umbriel/config.toml

d %h/.config/noctalia 0755 - - -
C %h/.config/noctalia/config.toml - - - - /etc/skel/.config/noctalia/config.toml
EOF

# Validate configs
umbriel validate -c /usr/share/chickenos/umbriel/config.toml
noctalia config validate /usr/share/chickenos/noctalia/config.toml
