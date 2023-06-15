#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-openwrt
# File name: diy-part2.sh
# Description: openwrt DIY script part 2 (After Update feeds)
#

#更换默认IP
sed -i 's/192.168.1.1/192.168.2.1/g' openwrt/package/base-files/files/bin/config_generate

#ip6assign
sed -i 's/60/64/g' openwrt/package/base-files/files/bin/config_generate

#密码
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$.rT.cU4J$wyLRZI4h2AaJMCQBZVYX90:19448:0:99999:7:::/g' openwrt/package/lean/default-settings/files/zzz-default-settings

#更换默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' openwrt/feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' openwrt/feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' openwrt/feeds/luci/collections/luci-ssl-nginx/Makefile

sed -i '/mediaurlbase/d' openwrt/feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i '/mediaurlbase/d' openwrt/feeds/luci/themes/luci-theme-material/root/etc/uci-defaults/30_luci-theme-material
sed -i '/mediaurlbase/d' openwrt/feeds/luci/themes/luci-theme-netgear/root/etc/uci-defaults/30_luci-theme-netgear

sed -i '/mediaurlbase/d' openwrt/feeds/small8/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design
sed -i '/mediaurlbase/d' openwrt/feeds/small8/luci-theme-edge/root/etc/uci-defaults/30_luci-theme-edge
sed -i '/mediaurlbase/d' openwrt/feeds/small8/luci-theme-ifit/files/10_luci-theme-ifit
sed -i '/mediaurlbase/d' openwrt/feeds/small8/luci-theme-opentopd/root/etc/uci-defaults/30_luci-theme-opentopd
sed -i '/mediaurlbase/d' openwrt/feeds/small8/luci-theme-tomato/root/etc/uci-defaults/30_luci-theme-tomato

rm -rf openwrt/feeds/luci/themes/luci-theme-argon
rm -rf openwrt/feeds/luci/themes/luci-theme-argon-mod
rm -rf openwrt/feeds/luci/themes/luci-theme-design
rm -rf openwrt/feeds/small8/luci-theme-argone 
rm -rf openwrt/feeds/small8/luci-app-argone-config

mv openwrt/feeds/small8/luci-theme-argon openwrt/feeds/luci/themes
mv openwrt/feeds/small8/luci-theme-design openwrt/feeds/luci/themes

#添加sms-tool中文支持
cp -rf Replace/luci-sms-tool/zh-cn openwrt/feeds/small8/luci-app-sms-tool/po

#TTYD自动登录
sed -i 's/login/login -f root/g' openwrt/feeds/packages/utils/ttyd/files/ttyd.config
sed -i '/${interface:+-i $interface}/d' openwrt/feeds/packages/utils/ttyd/files/ttyd.init

#修复wifidog
sed -i '/init.d/d' openwrt/feeds/packages/net/wifidog/Makefile

#删除zzz-default-settings的exit 0
sed -i '/exit 0/d' openwrt/package/lean/default-settings/files/zzz-default-settings

#ntp服务器
echo "uci delete system.ntp.server" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='ntp.ntsc.ac.cn'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='cn.ntp.org.cn'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time1.aliyun.com'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time1.cloud.tencent.com'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='pool.ntp.org'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time.apple.com'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time.cloudflare.com'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci commit system" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "" >> openwrt/package/lean/default-settings/files/zzz-default-settings

#wifi
echo "uci set wireless.radio0.channel=auto" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.band=5g" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.htmode=HE80" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.disabled=0" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.country=US" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.legacy_rates=1" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.mu_beamformer=0" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0=wifi-iface" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.device=radio0" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.network=lan" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.mode=ap" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.ssid=OpenWrt" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.encryption=sae-mixed" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.key=ueubmbzr" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci commit wireless" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "" >> openwrt/package/lean/default-settings/files/zzz-default-settings

#网口
echo "uci set network.wan.ifname='eth0'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.lan.ifname='eth1 eth2 eth3'" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "uci commit network" >> openwrt/package/lean/default-settings/files/zzz-default-settings
echo "" >> openwrt/package/lean/default-settings/files/zzz-default-settings

#加回zzz-default-settings的exit 0
echo "exit 0" >> openwrt/package/lean/default-settings/files/zzz-default-settings
