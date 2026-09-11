#!/usr/bin/env -S bash -euo pipefail

DIR="/usr/share/user-tmpfiles.d"
mkdir -p "$DIR"

cat > "$DIR/chickenos.conf" <<'EOF'
d %h/.config/fish 0755 - - -
C %h/.config/fish/config.fish - - - - /etc/skel/.config/fish/config.fish

d %h/.config/kitty 0755 - - -
C %h/.config/kitty/kitty.conf - - - - /etc/skel/.config/kitty/kitty.conf

d %h/.config/qt6ct 0755 - - -
C %h/.config/qt6ct/qt6ct.conf - - - - /etc/skel/.config/qt6ct/qt6ct.conf

d %h/.config/umbriel 0755 - - -
C %h/.config/umbriel/config.toml - - - - /etc/skel/.config/umbriel/config.toml

d %h/.config/noctalia 0755 - - -
C %h/.config/noctalia/config.toml - - - - /etc/skel/.config/noctalia/config.toml

d %h/.config/noctalia/palettes 0755 - - -
C %h/.config/noctalia/palettes/chickenos.json - - - - /etc/skel/.config/noctalia/palettes/chickenos.json
EOF
