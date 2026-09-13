#!/usr/bin/env bash

[ "$VM" = "1" ] && exit 0

# Build initramfs and kmods
mkdir -p "$(realpath /root)"

for kver in $(basename -a /usr/lib/modules/*/); do
  rm -f /var/cache/akmods/*/*-for-"$kver".failed.log
  akmods --force --kernels "$kver"

  failed=$(find /var/cache/akmods -name "*for-$kver.failed.log" -print -quit)
  if [ -n "$failed" ]; then
    cat "$failed"
    exit 1
  fi

  DRACUT_NO_XATTR=1 dracut --stdlog 1 \
    --force --zstd --reproducible --no-hostonly \
    "/usr/lib/modules/$kver/initramfs.img" "$kver"

  install -Dm644 \
    "/usr/lib/modules/$kver/initramfs.img" \
    "/out/usr/lib/modules/$kver/initramfs.img"
done

find /var/cache/akmods -type f -name '*.rpm' -exec cp -t /rpms {} +
