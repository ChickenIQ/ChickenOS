#!/bin/bash
set -ouex pipefail

# Install Kernel
dnf5 -y install kernel-cachyos kernel-cachyos-devel-matched 
dnf5 -y remove --no-autoremove kernel-{core,modules,modules-core,modules-extra}
setsebool -P domain_kernel_load_modules on

# Sign Kernel
export KERNEL="/usr/lib/modules/$(basename -a /usr/src/kernels/*/)/vmlinuz"
export PRIV_KEY="/etc/pki/akmods/private/private_key.priv"
export PUB_KEY="/etc/pki/akmods/certs/public_key.der"
dnf5 -y install sbsigntools

sbsign --key "$PRIV_KEY" --cert <(openssl x509 -in "$PUB_KEY" -inform der -outform pem) --output "$KERNEL.signed" "$KERNEL"
mv "$KERNEL.signed" "$KERNEL"
