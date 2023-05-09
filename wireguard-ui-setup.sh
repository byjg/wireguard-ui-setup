#!/bin/bash

set -e

CONFIG_FILE=./config.env

if [ -n "$1" ]; then
    CONFIG_FILE=$1
fi

ls -la $CONFIG_FILE

if [ ! -f "$CONFIG_FILE" ]; then
    echo "You need a 'config.env' file or provide a path to a valid config"
    exit 1
fi

export WGUI_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
source $CONFIG_FILE

echo "Configuration:"
echo "--------------"
echo WIREGUARD_UI_VERSION = $WIREGUARD_UI_VERSION
echo WIREGUARD_UI_PLATFORM = $WIREGUARD_UI_PLATFORM
echo WG_INTERFACE = $WG_INTERFACE
echo WG_DIRECTORY = $WG_DIRECTORY
echo WG_ARGS = $WG_ARGS
echo WGUI_PASSWORD = $WGUI_PASSWORD
echo "--------------"
echo
echo "Press <ENTER> to continue or <CTRL+C> to cancel"
read

apt -y -qq install wireguard-tools resolvconf

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
echo "net.ipv4.ip_forward = 1"           >  /etc/sysctl.d/99-wireguard.conf
echo "net.ipv6.conf.all.forwarding = 1"  >> /etc/sysctl.d/99-wireguard.conf 

mkdir -p $WG_DIRECTORY

WIREGUARD_UI_DOWNLOAD=https://github.com/ngoduykhanh/wireguard-ui/releases/download/v${WIREGUARD_UI_VERSION}/wireguard-ui-v${WIREGUARD_UI_VERSION}-${WIREGUARD_UI_PLATFORM}.tar.gz

wget -c ${WIREGUARD_UI_DOWNLOAD} -O - | tar -xz --directory $WG_DIRECTORY

envsubst < restart-interface.sh > $WG_DIRECTORY/restart-interface.sh
envsubst < systemd/wgui-monitor.path > /etc/systemd/system/wgui-monitor.path
envsubst < systemd/wgui-monitor.service > /etc/systemd/system/wgui-monitor.service
envsubst < systemd/wgui.service > /etc/systemd/system/wgui.service

chmod a+x $WG_DIRECTORY/restart-interface.sh

systemctl daemon-reload

systemctl enable wgui-monitor.{path,service}
systemctl start wgui-monitor.{path,service}

systemctl enable wgui.service
systemctl start wgui.service

echo "[Interface]"                >  /etc/wireguard/$WG_INTERFACE.conf
echo "Address = 10.252.1.1/24"    >> /etc/wireguard/$WG_INTERFACE.conf
echo "ListenPort = 51820"         >> /etc/wireguard/$WG_INTERFACE.conf
echo "Private Key = $(wg genkey)" >> /etc/wireguard/$WG_INTERFACE.conf

wg-quick up $WG_INTERFACE || echo 
systemctl enable wg-quick@$WG_INTERFACE


