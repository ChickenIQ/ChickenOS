#!/usr/bin/env bash

export GSETTINGS_BACKEND=memory
for root in "/usr/share/chickenos" "/etc/skel/.config"; do 
  umbriel validate -c "$root/umbriel/config.toml" 
  noctalia config validate "$root/noctalia/config.toml"
done