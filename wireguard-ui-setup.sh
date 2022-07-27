#!/bin/bash

set -e
set -x

export WIREGUARD_UI_VERSION=0.3.7
export WIREGUARD_UI_PLATFORM=linux-arm64
export WG_INTERFACE=wg0
export WG_DIRECTORY=/opt/wireguard-ui
export WG_ARGS=''

apt -y -qq install wireguard-tools resolvconf

mkdir -p $WG_DIRECTORY

WIREGUARD_UI_DOWNLOAD=https://github.com/ngoduykhanh/wireguard-ui/releases/download/v${WIREGUARD_UI_VERSION}/wireguard-ui-v${WIREGUARD_UI_VERSION}-${WIREGUARD_UI_PLATFORM}.tar.gz

wget -c ${WIREGUARD_UI_DOWNLOAD} -O - | tar -xz --directory $WG_DIRECTORY

envsubst < restart-interface.sh > $WG_DIRECTORY/restart-interface.sh
envsubst < systemd/wgui-monitor.path > /etc/systemd/system/wgui-monitor.path
envsubst < systemd/wgui-monitor.service > /etc/systemd/system/wgui-monitor.service
envsubst < systemd/wgui.service > /etc/systemd/system/wgui.service

chmod a+x $WG_DIRECTORY/restart-interface.sh

wg-quick up $WG_INTERFACE || echo 

systemctl daemon-reload
systemctl enable wgui-monitor.{path,service}
systemctl start wgui-monitor.{path,service}

systemctl enable wgui.service
systemctl start wgui.service

