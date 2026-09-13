#!/usr/bin/env bash

# Install Keys
KEY=/run/secrets/secureboot CRT=/build/secureboot.der
if [ "$VM" != "1" ] && { [ -f "$CRT" ] || [ -f "$KEY" ]; }; then
  [ -f "$CRT" ] && [ -f "$KEY" ] || {
    echo "Secure Boot certificate and private key must both be provided"
    exit 1
  }

  findmnt -n -t tmpfs /etc/pki/akmods >/dev/null || {
    echo "/etc/pki/akmods is not mounted as tmpfs"
    exit 1
  }

  install -Dm644 "$KEY" /etc/pki/akmods/private/private_key.priv
  install -Dm644 "$CRT" /out/usr/share/chickenos/secureboot.der
  install -Dm644 "$CRT" /etc/pki/akmods/certs/public_key.der

  echo "Secure Boot certificate and private key installed"
fi


# Setup out diretories
mkdir -p /out/usr/lib/bootc/kargs.d
mkdir -p /out/usr/lib/modules

