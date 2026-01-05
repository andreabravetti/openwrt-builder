#!/bin/bash

set -e

cd /openwrt || {
    echo "OpenWrt mount point not found: Use -v openwrt:/openwrt"
    exit 1
}

make distclean

BECOME_UID=$(stat -c '%u' /openwrt)
BECOME_GID=$(stat -c '%g' /openwrt)

# Setup the user
sed -i "/^openwrt:x:.*$/d" /etc/group
echo "openwrt:x:$BECOME_GID:" | tee -a /etc/group
sed -i "/^openwrt:x:.*$/d" /etc/passwd
echo "openwrt:x:$BECOME_UID:$BECOME_GID:openwrt:/home/openwrt:/bin/bash" | tee -a /etc/passwd
mkdir -p /home/openwrt
chown -R openwrt:openwrt /home/openwrt

# shellcheck disable=SC2086
sudo -u \#$BECOME_UID -g \#$BECOME_GID bash /build.sh
