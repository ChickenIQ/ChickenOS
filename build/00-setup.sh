#!/usr/bin/env -S bash -euo pipefail

# Add repos
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf install -y dnf5-plugins akmods

dnf copr enable -y ublue-os/packages
dnf copr enable -y atim/starship
dnf copr enable -y imput/helium

dnf config-manager setopt 'copr:copr.fedorainfracloud.org:ublue-os:packages.includepkgs=bazaar'
dnf config-manager setopt fedora-cisco-openh264.enabled=1

# Install Keys
KEY=/run/secrets/secureboot
CERT=/build/secureboot.der

if [ -f "$CERT" ] || [ -f "$KEY" ]; then
  [ -f "$CERT" ] && [ -f "$KEY" ] || {
    echo "Secure Boot certificate and private key must both be provided"
    exit 1
  }

  findmnt -n -t tmpfs /etc/pki/akmods >/dev/null || {
    echo "/etc/pki/akmods is not mounted as tmpfs"
    exit 1
  }

  install -Dm640 -o root -g akmods "$KEY" /etc/pki/akmods/private/private_key.priv
  install -Dm644 "$CERT" /etc/pki/akmods/certs/public_key.der
  install -Dm644 "$CERT" /usr/share/chickenos/secureboot.der

  echo "Secure Boot certificate and private key installed"
fi
