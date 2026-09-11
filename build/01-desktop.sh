#!/usr/bin/env -S bash -euo pipefail

dnf install -y umbriel-nightly noctalia qt6ct plasma-breeze-qt6 plasma-breeze-qt5 

# Session wrapper 
cat > /usr/bin/chickenos-session <<'EOF'
#!/bin/bash
export QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-qt6ct}"
exec "${CHICKENOS_SESSION_COMMAND:-/usr/bin/start-umbriel}" "$@"
EOF

chmod +x /usr/bin/chickenos-session


