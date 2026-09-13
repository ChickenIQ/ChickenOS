#!/usr/bin/env bash

# Install Plymouth
dnf install -y plymouth-system-theme

cat > /usr/lib/bootc/kargs.d/10-plymouth.conf <<'EOF'
kargs = [ "rhgb", "quiet" ]
EOF

rm -rf /var/lib/plymouth /var/spool/plymouth


# Allow AMD Overdrive
cat > /usr/lib/bootc/kargs.d/20-amd-overdrive.conf <<'EOF'
kargs = [ "amdgpu.ppfeaturemask=0xfffd7fff" ]
EOF