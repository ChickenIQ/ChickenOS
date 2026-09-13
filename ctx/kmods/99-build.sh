#!/usr/bin/env bash

# Build initramfs and kmods
rm -rf /var/cache/akmods
mkdir -p /var/cache/akmods

for kver in $(basename -a /usr/lib/modules/*/); do
  akmods --force --kernels "$kver"
  failed=$(find /var/cache/akmods -name "*for-$kver.failed.log" -print -quit)
  if [ -n "$failed" ]; then
    cat "$failed"
    exit 1
  fi
done

find /var/cache/akmods -type f -name '*.rpm' -exec cp -t /rpms {} +
