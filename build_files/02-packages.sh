#!/bin/bash
set -ouex pipefail

pkgs_install=(
  qemu-system-aarch64
  wireguard-tools
  docker-compose
  spotify-client
  virt-manager
  sbsigntools
  distrobox
  fastfetch
  gamescope
  mangohud
  openh264
  starship
  discord
  openssl
  steam
  nvtop
  lact
  code
  keyd
  tldr
  btop
  fish
  vim
)


# Setup Packages
dnf5 -y install $(echo "${pkgs_install[*]}")
systemctl enable docker.service keyd.service lactd.service libvirtd.service


# Setup Sysusers
echo "u qat 995" > /usr/lib/sysusers.d/qat.conf
echo "g libvirt 962" > /usr/lib/sysusers.d/libvirt.conf


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


# Patch Spotify
sh -c "$(curl -sSL https://spotx-official.github.io/run.sh)" -- -e > /dev/null


# Install RNNoise
mkdir -p /tmp/rnnoise
curl -L http://github.com/werman/noise-suppression-for-voice/releases/latest/download/linux-rnnoise.zip -o /tmp/rnnoise/rnnoise.zip 
unzip -o /tmp/rnnoise/rnnoise.zip -d /tmp/rnnoise
mv /tmp/rnnoise/linux-rnnoise/ladspa/librnnoise_ladspa.so /usr/lib64
rm -rf /tmp/rnnoise


# Install UMU Launcher
URL=$(curl -s https://api.github.com/repos/Open-Wine-Components/umu-launcher/releases/latest | grep browser_download_url | cut -d\" -f4 | grep 'zipapp.tar$')
TMP_DIR=/tmp/umu

mkdir -p $TMP_DIR
curl -Lo $TMP_DIR/umu.tar $URL
tar -xf $TMP_DIR/umu.tar -C $TMP_DIR
mv $TMP_DIR/umu/umu-run /usr/bin
chmod +x /usr/bin/umu-run
rm -rf $TMP_DIR


# Install Proton-GE
URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep '.tar.gz$')
INSTALL_DIR=/usr/share/steam/compatibilitytools.d/Proton-System
TMP_DIR=/tmp/proton

mkdir -p $INSTALL_DIR $TMP_DIR
curl -Lo $TMP_DIR/proton.tar.gz $URL
tar -xzf $TMP_DIR/proton.tar.gz -C $TMP_DIR
mv $TMP_DIR/*/* $INSTALL_DIR && rm -rf $TMP_DIR

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
