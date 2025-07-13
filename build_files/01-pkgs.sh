#!/bin/bash
set -ouex pipefail

pkgs_remove=(
  plasma-browser-integration
  fedora-chromium-config-kde
  fedora-chromium-config
  fedora-flathub-remote
  mozilla-filesystem
  fedora-bookmarks
  firewall-config
  plasma-welcome
  kdebugsettings
  kinfocenter
  khelpcenter
  kcharselect
  kde-connect
  kjournald
  toolbox
  firefox
  kwrite
  kfind
  krfb
)


pkgs_install=(
  plasma-firewall
  wireguard-tools
  distrobox
  fastfetch
  starship
  thefuck
  steam
  nvtop
  keyd
  tldr
  kate
  btop
  fish
  vim
)


# Setup Packages
dnf5 -y install $(echo "${pkgs_install[*]}")
dnf5 -y remove $(echo "${pkgs_remove[*]}")
systemctl enable podman.service


# Install Nix
mkdir -p /nix /var/nix/
dnf5 -y install nix

cat > /etc/systemd/system/nix.mount <<'EOF'
[Unit]
Description=Mount `/var/nix` on `/nix`
PropagatesStopTo=nix-daemon.service
ConditionPathIsDirectory=/nix
DefaultDependencies=no

[Mount]
What=/var/nix
Where=/nix
Type=none
DirectoryMode=0755
Options=bind

[Install]
RequiredBy=nix-daemon.service
RequiredBy=nix-daemon.socket
EOF

systemctl enable nix-daemon nix.mount


# Install RNNoise
mkdir -p /tmp/rnnoise
curl -L http://github.com/werman/noise-suppression-for-voice/releases/latest/download/linux-rnnoise.zip -o /tmp/rnnoise/rnnoise.zip 
unzip -o /tmp/rnnoise/rnnoise.zip -d /tmp/rnnoise
mv /tmp/rnnoise/linux-rnnoise/ladspa/librnnoise_ladspa.so /usr/lib64/librnnoise_ladspa.so
rm -rf /tmp/rnnoise


# Install UMU Launcher with Proton-CachyOS
dnf5 -y --enablerepo=copr:copr.fedorainfracloud.org:gloriouseggroll:nobara-42 install umu-launcher
URL=$(curl -s https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest | grep browser_download_url | cut -d\" -f4 | grep 'x86_64_v3\.tar\.xz$')
INSTALL_DIR=/usr/share/steam/compatibilitytools.d/Proton-System
TMP_DIR=/tmp/proton

mkdir -p $INSTALL_DIR $TMP_DIR
curl -Lo $TMP_DIR/proton.tar.xz $URL
tar -xf $TMP_DIR/proton.tar.xz -C $TMP_DIR
mv $TMP_DIR/proton-cachyos*/* $INSTALL_DIR && rm -rf $TMP_DIR

cat > $INSTALL_DIR/compatibilitytool.vdf <<'EOF'
"compatibilitytools"
{
  "compat_tools"
  {
    "Proton-System"
    {
      "display_name" "Proton-System"
      "from_oslist"  "windows"
      "to_oslist"    "linux"
      "install_path" "."
    }
  }
}
EOF
