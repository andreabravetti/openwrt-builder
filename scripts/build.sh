#!/bin/bash

set -e

cd /openwrt || {
    echo "OpenWrt mount point not found: Use -v openwrt:/openwrt"
    exit 1
}

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Personalize for your device
wget https://downloads.openwrt.org/releases/24.10.5/targets/mediatek/filogic/config.buildinfo -O .config

# Patch buggy hardware
wget https://raw.githubusercontent.com/Gilly1970/BPI-R4_Openwrt_Snapshot_Build/refs/heads/main/openwrt-patches/9999-new-tx-power-eeprom-0s.patch -O package/kernel/mt76/patches/9999-new-tx-power-eeprom-0s.patch

# Prepare
make defconfig download

# Configure
make menuconfig

# Build
make -j8 clean world

ls -l bin/targets/mediatek/filogic

echo "OpenWrt built!"
