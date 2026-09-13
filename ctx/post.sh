#!/usr/bin/env bash


# Cleanup Dirs
rm -rf /usr/etc
rm -rf /tmp/* || true
if [ "${ISO:-0}" != "1" ]; then
  rm -rf /boot
  mkdir /boot
fi

# Cleanup /run
find /run -xdev -mindepth 1 -delete 2>/dev/null || true

# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache \! -name log \! -name home -exec rm -rf {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;

# Fix tmp
mkdir -p /tmp /var/tmp
chmod 1777 /tmp /var/tmp

# Lint
LINT_ARGS=(--fatal-warnings --skip var-log)
[ "${1:-}" != "live" ] || LINT_ARGS+=(--skip var-tmpfiles)
[ "${ISO:-0}" != "1" ] || LINT_ARGS+=(--skip nonempty-boot)
bootc container lint "${LINT_ARGS[@]}"
