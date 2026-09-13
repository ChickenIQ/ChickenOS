#!/usr/bin/env bash

THEME="Oxocarbon"
URL="https://raw.githubusercontent.com/noctalia-dev/community-palettes/main/$THEME/$THEME.json"
curl -fsSL "$URL" --retry 5 --retry-delay 2 --retry-all-errors -o /usr/share/chickenos/noctalia/theme.json