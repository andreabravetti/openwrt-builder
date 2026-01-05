#!/bin/bash

set -e

cd /openwrt || {
    echo "OpenWrt mount point not found: Use -v openwrt:/openwrt"
    exit 1
}

# Personalize for your device:
wget https://downloads.openwrt.org/releases/24.10.5/targets/mediatek/filogic/config.buildinfo -O .config

./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

make defconfig download clean world

echo "OpenWrt built!"
