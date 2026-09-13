#!/usr/bin/env bash

# Desktop 
dnf install -y umbriel-nightly noctalia qt6ct adw-gtk3-theme plasma-breeze-qt6 plasma-breeze-qt5


# Session wrapper 
cat > /usr/bin/chickenos-session <<'EOF'
#!/bin/bash
export QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-qt6ct}"
exec "${CHICKENOS_SESSION_COMMAND:-/usr/bin/start-umbriel}" "$@"
EOF

chmod +x /usr/bin/chickenos-session


# Create portal config for Umbriel
cat > /usr/share/xdg-desktop-portal/umbriel-portals.conf <<'EOF'
[preferred]
default=gtk
org.freedesktop.impl.portal.ScreenCast=umbriel
org.freedesktop.impl.portal.Screenshot=umbriel
EOF