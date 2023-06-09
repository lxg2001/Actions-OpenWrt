#!/bin/bash

#设置环境变量
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

#拉取源码
git clone https://hub.fgit.ml/coolsnowwolf/lede

#切换到源码目录
cd lede

#修改软件源
sed -i '5i src-git small8 https://github.com/kenzok8/small-package' /home/lxg/lede/feeds.conf.default
sed -i 's/github.com/hub.fgit.ml/g' /home/lxg/lede/feeds.conf.default

#升级软件
./scripts/feeds update -a

#替换链接
sed -i 's/github.com/hub.fgit.ml/g' /home/lxg/lede/feeds/small8/redsocks2/Makefile
sed -i 's#PKG_GIT_URL:=github.com/docker/cli#PKG_GIT_URL:=hub.fgit.ml/docker/cli#g' /home/lxg/lede/feeds/packages/utils/docker/Makefile
sed -i 's#GO_PKG:=$(PKG_GIT_URL)#GO_PKG:=github.com/docker/cli#g' /home/lxg/lede/feeds/packages/utils/docker/Makefile
sed -i 's/PKG_GIT_URL:=github.com/PKG_GIT_URL:=hub.fgit.ml/g' /home/lxg/lede/feeds/packages/utils/dockerd/Makefile
sed -i 's/github.com/hub.fgit.ml/g' /home/lxg/lede/package/kernel/rtw88-usb/Makefile
sed -i 's#PKG_SOURCE_URL:=https://github.com#PKG_SOURCE_URL:=https://hub.fgit.ml#g' /home/lxg/lede/feeds/small8/adguardhome/Makefile

#密码
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$.rT.cU4J$wyLRZI4h2AaJMCQBZVYX90:19448:0:99999:7:::/g' /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#主题
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' /home/lxg/lede/feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' /home/lxg/lede/feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argone/g' /home/lxg/lede/feeds/luci/collections/luci-ssl-nginx/Makefile

sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/luci/themes/luci-theme-material/root/etc/uci-defaults/30_luci-theme-material
sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/luci/themes/luci-theme-netgear/root/etc/uci-defaults/30_luci-theme-netgear

sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/small8/luci-theme-design/root/etc/uci-defaults/30_luci-theme-design
sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/small8/luci-theme-edge/root/etc/uci-defaults/30_luci-theme-edge
sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/small8/luci-theme-ifit/files/10_luci-theme-ifit
sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/small8/luci-theme-opentopd/root/etc/uci-defaults/30_luci-theme-opentopd
sed -i '/mediaurlbase/d' /home/lxg/lede/feeds/small8/luci-theme-tomato/root/etc/uci-defaults/30_luci-theme-tomato

rm -rf /home/lxg/lede/feeds/luci/themes/luci-theme-argon
rm -rf /home/lxg/lede/feeds/luci/themes/luci-theme-argon-mod
rm -rf /home/lxg/lede/feeds/luci/themes/luci-theme-design
rm -rf /home/lxg/lede/feeds/small8/luci-theme-argon 
rm -rf /home/lxg/lede/feeds/small8/luci-app-argon-config

cp -f /home/lxg/op/x86/themes/argone/cascade.css /home/lxg/lede/feeds/small8/luci-theme-argone/htdocs/luci-static/argone/css
cp -f /home/lxg/op/x86/themes/design/style.css /home/lxg/lede/feeds/small8/luci-theme-design/htdocs/luci-static/design/css
cp -f /home/lxg/op/x86/themes/edge/cascade.css /home/lxg/lede/feeds/small8/luci-theme-edge/htdocs/luci-static/edge
cp -f /home/lxg/op/x86/themes/ifit/style.css /home/lxg/lede/feeds/small8/luci-theme-ifit/files/htdocs/css
cp -f /home/lxg/op/x86/themes/material/style.css /home/lxg/lede/feeds/luci/themes/luci-theme-material/htdocs/luci-static/material/css

mv /home/lxg/lede/feeds/small8/luci-theme-design /home/lxg/lede/feeds/luci/themes

#lean
cp -rf /home/lxg/op/x86/lean/* /home/lxg/lede/package/lean

#ttyd
sed -i 's/login/login -f root/g' /home/lxg/lede/feeds/packages/utils/ttyd/files/ttyd.config
sed -i '/${interface:+-i $interface}/d' /home/lxg/lede/feeds/packages/utils/ttyd/files/ttyd.init

#wifidog
sed -i '/init.d/d' /home/lxg/lede/feeds/packages/net/wifidog/Makefile

#adguardHome
rm -rf /home/lxg/lede/feeds/packages/net/adguardhome
mv /home/lxg/lede/feeds/small8/adguardhome /home/lxg/lede/feeds/packages/net

#transmission
sed -i '/procd_add_jail_mount "$config_file"/d' /home/lxg/lede/feeds/packages/net/transmission/files/transmission.init
sed -i '137i \\tprocd_add_jail_mount "$config_file"\n\tweb_home="${web_home:-/usr/share/transmission/web}"\n\t[ -d "$web_home" ] && procd_add_jail_mount "$web_home"' /home/lxg/lede/feeds/packages/net/transmission/files/transmission.init

#luci-app-argone-config
cp -f /home/lxg/op/x86/luci-app-argone-config/argone /home/lxg/lede/feeds/small8/luci-app-argone-config/root/etc/config

#ddns-scripts
cp -f /home/lxg/op/x86/ddns-scripts/ddns.config /home/lxg/lede/feeds/packages/net/ddns-scripts/files

#socat
cp -f /home/lxg/op/x86/socat/socat.config /home/lxg/lede/feeds/packages/net/socat/files

#nginx
cp -f /home/lxg/op/x86/nginx/nginx.conf /home/lxg/lede/feeds/packages/net/nginx/files
sed -i 's#define Package/nginx/install#define Package/nginx/install\n\t$(INSTALL_DIR) $(1)/etc/nginx\n\t$(INSTALL_CONF) ./files/nginx.conf $(1)/etc/nginx#g' /home/lxg/lede/feeds/packages/net/nginx/Makefile				

#luci-app-poweroff
cp -f /home/lxg/op/x86/luci-app-poweroff/poweroff.po /home/lxg/lede/feeds/small8/luci-app-poweroff/po/zh-cn

#删除zzz-default-settings的exit 0
sed -i '/exit 0/d' /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#软件源
echo "sed -i '/small8/d' /etc/opkg/distfeeds.conf" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#诊断
echo "uci set luci.diag.dns='www.baidu.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set luci.diag.ping='www.baidu.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set luci.diag.route='www.baidu.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci commit luci" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings 
echo "" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#ntp服务器
echo "uci delete system.ntp.server" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='ntp.ntsc.ac.cn'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='cn.ntp.org.cn'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time1.aliyun.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time1.cloud.tencent.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='pool.ntp.org'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time.apple.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci add_list system.ntp.server='time.cloudflare.com'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci commit system" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#wifi
sed -i 's/set wireless.radio${devidx}/set wireless.radio0/g' /home/lxg/lede/package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/set wireless.default_radio${devidx}/set wireless.default_radio0/g' /home/lxg/lede/package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/radio0.device=radio${devidx}/radio0.device=radio0/g' /home/lxg/lede/package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo "uci set wireless.radio0.channel=auto" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.band=2g" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.htmode=HE80" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.disabled=0" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.country=US" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.legacy_rates=1" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.mu_beamformer=0" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.radio0.txpower=30" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

echo "uci set wireless.default_radio0=wifi-iface" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.device=radio0" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.network=lan" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.mode=ap" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.ssid=OpenWrt_2.4G" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.encryption=sae-mixed" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set wireless.default_radio0.key=ueubmbzr" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

echo "uci commit wireless" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#网络
echo "uci set network.lan.ifname='eth1 eth2 eth3'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.lan.ipaddr=192.168.2.1" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.ifname='eth0'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.proto='pppoe'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.username='GY8688795'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan.password='8688795'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set network.wan6.ifname='@wan'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci commit network" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#firewall
echo "uci add firewall rule" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci rename firewall.@rule[-1]='qbittorrent'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set firewall.@rule[-1].name='qbittorrent'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set firewall.@rule[-1].target='ACCEPT'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set firewall.@rule[-1].src='wan'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set firewall.@rule[-1].proto='tcp udp'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci set firewall.@rule[-1].dest_port='55555'" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "uci commit firewall" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings
echo "" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#加回zzz-default-settings的exit 0
echo "exit 0" >> /home/lxg/lede/package/lean/default-settings/files/zzz-default-settings

#安装软件
./scripts/feeds install -a

cp -f /home/lxg/op/x86/.config /home/lxg/lede
mv /home/lxg/op/dl /home/lxg/lede

make defconfig

make download -j8 V=s

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make V=s -j$(nproc) || PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make V=s -j$(nproc) || PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make V=s -j1
