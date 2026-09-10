#!/usr/bin/env -S bash -euo pipefail

DIR="/usr/lib/bootc/kargs.d"
mkdir -p "$DIR"

cat > "$DIR/10-selinux.conf" <<'EOF'
kargs = ["selinux=0"]
EOF