#!/usr/bin/env bash

# Cleanup Dirs
if [ "${ISO:-0}" != "1" ]; then
  rm -rf /boot
  mkdir /boot
fi

# Cleanup tmp
rm -rf /tmp/* /var/tmp/* || true
mkdir -p /tmp /var/tmp
chmod 1777 /tmp /var/tmp

# Cleanup /run
find /run -xdev -mindepth 1 -delete 2>/dev/null || true

# Lint
LINT_ARGS=(--fatal-warnings --skip var-log)
[ "${1:-}" != "live" ] || LINT_ARGS+=(--skip var-tmpfiles)
[ "${ISO:-0}" != "1" ] || LINT_ARGS+=(--skip nonempty-boot)
bootc container lint "${LINT_ARGS[@]}"
