#!/usr/bin/env bash

# Run all scripts in the layer
for sc in $(printf '%s\n' "/ctx/$1"/*.sh | sort -V); do
  bash -euo pipefail "$sc"
done

bash -euo pipefail /ctx/post.sh "$1"
