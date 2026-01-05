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

# Ensure required packages are installed
# Copy from https://firmware-selector.openwrt.org/?version=24.10.5&target=mediatek%2Ffilogic&id=bananapi_bpi-r4
for pkg in base-files ca-bundle dnsmasq dropbear firewall4 fitblk fstools kmod-crypto-hw-safexcel kmod-gpio-button-hotplug kmod-leds-gpio kmod-nft-offload kmod-phy-aquantia libc libgcc libustream-mbedtls logd mtd netifd nftables odhcp6c odhcpd-ipv6only opkg ppp ppp-mod-pppoe procd-ujail uboot-envtools uci uclient-fetch urandom-seed urngd wpad-basic-mbedtls kmod-hwmon-pwmfan kmod-i2c-mux-pca954x kmod-eeprom-at24 kmod-mt7996-firmware kmod-mt7996-233-firmware kmod-rtc-pcf8563 kmod-sfp kmod-usb3 e2fsprogs f2fsck mkf2fs mt7988-wo-firmware luci
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
