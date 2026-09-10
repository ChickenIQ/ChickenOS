#!/usr/bin/env -S bash -euo pipefail

# Add repos
dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf update -y
