#!/usr/bin/env bash

# Build initramfs
for kver in $(basename -a /usr/lib/modules/*/); do
  DRACUT_NO_XATTR=1 dracut --stdlog 1 \
    --force --zstd --reproducible --no-hostonly \
    "/usr/lib/modules/$kver/initramfs.img" "$kver"
done
