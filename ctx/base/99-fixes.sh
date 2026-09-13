#!/usr/bin/env bash

# Create directories
mkdir -p /usr/local/sbin
mkdir -p "$(realpath /root)"

# Disable Selinux
DIR="/out/usr/lib/bootc/kargs.d"
mkdir -p "$DIR"

cat > "$DIR"/00-selinux.toml <<'EOF'
kargs = [ "enforcing=0" ]
EOF