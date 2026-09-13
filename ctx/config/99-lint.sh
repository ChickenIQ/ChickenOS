#!/usr/bin/env bash

export GSETTINGS_BACKEND=memory
for root in "/usr/share/chickenos" "/etc/skel/.config"; do 
  noctalia config validate "$root/noctalia/config.toml"
  umbriel validate -c "$root/umbriel/config.toml" 
done