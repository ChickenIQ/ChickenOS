#!/usr/bin/env bash

dnf install -y plymouth-system-theme

cat > /out/usr/lib/bootc/kargs.d/10-plymouth.conf <<'EOF'
kargs = [ "rhgb", "quiet" ]
EOF
