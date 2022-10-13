#!/usr/bin/sh
set -e

# Expect Python3 and Git to be installed
if ! command -v git >/dev/null; then
    echo "Failed to find 'git' installed" >&2
    exit 1
fi
if ! command -v python3 >/dev/null; then
    echo "Failed to find 'python3' installed" >&2
    exit 1
fi

mkdir -p /tmp/bscher-dev-utils

# Download repo to /tmp/
mkdir -p /tmp/bscher-dev-utils
cd /tmp/bscher-dev-utils
rm -rf ./dev-utils || /usr/bin/true
git clone https://github.com/bscher/dev-utils.git

# Run install script
cd /tmp/bscher-dev-utils/dev-utils/
python3 ./install.py
