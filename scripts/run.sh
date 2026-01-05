#!/bin/bash

set -e

cd /openwrt || {
    echo "OpenWrt mount point not found: Use -v openwrt:/openwrt"
    exit 1
}

make distclean

BECOME_UID=$(stat -c '%u' /openwrt)
BECOME_GID=$(stat -c '%g' /openwrt)

# shellcheck disable=SC2086
sudo -u \#$BECOME_UID -g \#$BECOME_GID bash /build.sh
