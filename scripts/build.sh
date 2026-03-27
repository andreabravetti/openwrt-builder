#!/bin/bash

set -e

cd /source || {
    echo "OpenWrt mount point not found: Use -v ./source:/source"
    exit 1
}

# Config
git config --global user.email "andreabravetti@gmail.com"
git config --global user.name "Andrea Bravetti"

# Clone OpenWRT
git clone https://github.com/openwrt/openwrt.git
cd openwrt

# Checkout v25.12.2
git checkout -b v25.12.2 v25.12.2

# Patch buggy hardware
# Apply https://github.com/openwrt/openwrt/pull/22447
git fetch origin pull/22447/head:temp-pr
git cherry-pick 4235ed7d6d0d66da384bd487e3ed899c3b315efc

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Personalize for your device
wget https://downloads.openwrt.org/releases/25.12.2/targets/mediatek/filogic/config.buildinfo -O .config

# Ensure required packages are installed
# Copy from https://firmware-selector.openwrt.org/?version=25.12.2&target=mediatek%2Ffilogic&id=bananapi_bpi-r4
for pkg in apk-mbedtls base-files ca-bundle dnsmasq dropbear firewall4 fitblk fstools kmod-crypto-hw-safexcel kmod-gpio-button-hotplug kmod-leds-gpio kmod-nft-offload libc libgcc libustream-mbedtls logd mtd netifd nftables odhcp6c odhcpd-ipv6only ppp ppp-mod-pppoe procd-ujail uboot-envtools uci uclient-fetch urandom-seed urngd wpad-basic-mbedtls kmod-hwmon-pwmfan kmod-i2c-mux-pca954x kmod-eeprom-at24 kmod-mt7996-firmware kmod-mt7996-233-firmware kmod-rtc-pcf8563 kmod-sfp kmod-phy-aquantia kmod-usb3 e2fsprogs f2fsck mkf2fs mt7988-wo-firmware luci
do
    sed -i "/^CONFIG_PACKAGE_$pkg=.*$/d" .config
    echo "CONFIG_PACKAGE_$pkg=y" | tee -a .config
done

# Prepare
make defconfig

# Download
make download

# Configure
make menuconfig

# Build
make -j8 clean world

ls -l bin/targets/mediatek/filogic

echo "OpenWrt built!"
