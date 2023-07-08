#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

#密码
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$.rT.cU4J$wyLRZI4h2AaJMCQBZVYX90:19448:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

#更换默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' feeds/luci/collections/luci-ssl-nginx/Makefile

sed -i '/mediaurlbase/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i '/mediaurlbase/d' feeds/luci/themes/luci-theme-material/root/etc/uci-defaults/30_luci-theme-material
sed -i '/mediaurlbase/d' feeds/luci/themes/luci-theme-netgear/root/etc/uci-defaults/30_luci-theme-netgear

sed -i '/mediaurlbase/d' feeds/small8/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design
sed -i '/mediaurlbase/d' feeds/small8/luci-theme-edge/root/etc/uci-defaults/30_luci-theme-edge
sed -i '/mediaurlbase/d' feeds/small8/luci-theme-ifit/files/10_luci-theme-ifit
sed -i '/mediaurlbase/d' feeds/small8/luci-theme-opentopd/root/etc/uci-defaults/30_luci-theme-opentopd
sed -i '/mediaurlbase/d' feeds/small8/luci-theme-tomato/root/etc/uci-defaults/30_luci-theme-tomato

rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon-mod
rm -rf feeds/luci/themes/luci-theme-design
rm -rf feeds/small8/luci-theme-argon 
rm -rf feeds/small8/luci-app-argon-config

mv feeds/small8/luci-theme-design feeds/luci/themes

#TTYD
sed -i 's/login/login -f root/g' feeds/packages/utils/ttyd/files/ttyd.config
sed -i '/${interface:+-i $interface}/d' feeds/packages/utils/ttyd/files/ttyd.init

#wifidog
sed -i '/init.d/d' feeds/packages/net/wifidog/Makefile

#AdguardHome
rm -rf feeds/packages/net/adguardhome
mv feeds/small8/adguardhome feeds/packages/net

#transmission
sed -i '/procd_add_jail_mount "$config_file"/d' feeds/packages/net/transmission/files/transmission.init
sed -i '137i procd_add_jail_mount "$config_file"\n        web_home="${web_home:-/usr/share/transmission/web}"\n        [ -d "$web_home" ] && procd_add_jail_mount "$web_home"' feeds/packages/net/transmission/files/transmission.init
sed -i 's/procd_add_jail_mount "$config_file"/        procd_add_jail_mount "$config_file"/g' feeds/packages/net/transmission/files/transmission.init

#fs
sed -i 's#fs/cifs#fs/smb/client#g' package/kernel/linux/modules/fs.mk
sed -i 's#fs/ksmbd#fs/smb/server#g' package/kernel/linux/modules/fs.mk
sed -i 's#fs/smbfs_common#fs/smb/common#g' package/kernel/linux/modules/fs.mk

#删除zzz-default-settings的exit 0
sed -i '/exit 0/d' package/lean/default-settings/files/zzz-default-settings

#软件源
echo "sed -i '/small8/d' /etc/opkg/distfeeds.conf" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings

#诊断
echo "uci set luci.diag.dns='www.baidu.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set luci.diag.ping='www.baidu.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set luci.diag.route='www.baidu.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci commit luci" >> package/lean/default-settings/files/zzz-default-settings 
echo "" >> package/lean/default-settings/files/zzz-default-settings

#ntp服务器
echo "uci delete system.ntp.server" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='ntp.ntsc.ac.cn'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='cn.ntp.org.cn'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time1.aliyun.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time1.cloud.tencent.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='pool.ntp.org'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time.apple.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time.cloudflare.com'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci commit system" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings

#wifi
sed -i 's/set wireless.radio${devidx}/set wireless.radio0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/set wireless.default_radio${devidx}/set wireless.default_radio0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/radio0.device=radio${devidx}/radio0.device=radio0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo "uci set wireless.radio0.channel=auto" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.band=2g" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.htmode=HE80" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.disabled=0" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.country=US" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.legacy_rates=1" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.mu_beamformer=0" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.txpower=30" >> package/lean/default-settings/files/zzz-default-settings

echo "uci set wireless.default_radio0=wifi-iface" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.device=radio0" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.network=lan" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.mode=ap" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.ssid=OpenWrt_2.4G" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.encryption=sae-mixed" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.key=ueubmbzr" >> package/lean/default-settings/files/zzz-default-settings

echo "uci commit wireless" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings

#网络
echo "uci set network.lan.ifname='eth1 eth2 eth3'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set network.lan.ipaddr=192.168.2.1" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.ifname='eth0'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.proto='pppoe'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.username='GY8688795'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.password='8688795'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan6.ifname='@wan'" >> package/lean/default-settings/files/zzz-default-settings
echo "uci commit network" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings

#firewall
echo "delete firewall.qbittorrent" >> package/lean/default-settings/files/zzz-default-settings
echo "add firewall rule" >> package/lean/default-settings/files/zzz-default-settings
echo "rename firewall.@rule[0]='qbittorrent'" >> package/lean/default-settings/files/zzz-default-settings
echo "set firewall.@rule[0].name='qbittorrent'" >> package/lean/default-settings/files/zzz-default-settings
echo "set firewall.@rule[0].target='ACCEPT'" >> package/lean/default-settings/files/zzz-default-settings
echo "set firewall.@rule[0].src='wan'" >> package/lean/default-settings/files/zzz-default-settings
echo "set firewall.@rule[0].proto='tcp udp'" >> package/lean/default-settings/files/zzz-default-settings
echo "set firewall.@rule[0].dest_port='55555'" >> package/lean/default-settings/files/zzz-default-settings
echo "commit firewall" >> package/lean/default-settings/files/zzz-default-settings
echo "" >> package/lean/default-settings/files/zzz-default-settings

#加回zzz-default-settings的exit 0
echo "exit 0" >> package/lean/default-settings/files/zzz-default-settings
