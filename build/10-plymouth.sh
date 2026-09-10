#!/usr/bin/env -S bash -euo pipefail

dnf remove -y console-login-helper-messages-issuegen
dnf install -y plymouth-system-theme audit

DIR="/usr/lib/bootc/kargs.d"
mkdir -p "$DIR"

cat > "$DIR"/10-plymouth.conf <<'EOF'
kargs = [ "rhgb", "quiet" ]
EOF