#!/usr/bin/env -S bash -euo pipefail

dnf install -y umbriel-nightly noctalia qt6ct plasma-breeze-qt6 plasma-breeze-qt5 

# Session wrapper 
cat > /usr/bin/chickenos-session <<'EOF'
#!/bin/bash
export QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-qt6ct}"
exec "${CHICKENOS_SESSION_COMMAND:-/usr/bin/start-umbriel}" "$@"
EOF

chmod +x /usr/bin/chickenos-session


# Ensure defaults are included
DIR="/usr/share/user-tmpfiles.d"
mkdir -p "$DIR"

cat > $DIR/chickenos.conf <<'EOF'
d %h/.config/qt6ct 0755 - - -
C %h/.config/qt6ct/qt6ct.conf - - - - /etc/skel/.config/qt6ct/qt6ct.conf

d %h/.config/umbriel 0755 - - -
C %h/.config/umbriel/config.toml - - - - /etc/skel/.config/umbriel/config.toml

d %h/.config/noctalia 0755 - - -
C %h/.config/noctalia/config.toml - - - - /etc/skel/.config/noctalia/config.toml
EOF

