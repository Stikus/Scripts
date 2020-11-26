#!/usr/bin/env bash


# all commands executed from 'root'
# wget -q https://raw.githubusercontent.com/Stikus/Scripts/master/proxmox_init.sh AKA http://tiny.cc/stik_proxmox


# export DEBIAN_FRONTEND="noninteractive"

# Add GKS Server pub RSA-key
mkdir -p "$HOME/.ssh" && wget -q "ftp://bioftp.cspmz.ru/certs/keys/GKS_Server_id_rsa.pub" -O ->> "$HOME/.ssh/authorized_keys"
# Add tmux config with mouse enabled
wget -q "ftp://bioftp.cspmz.ru/certs/keys/.tmux.conf" -O "$HOME/.tmux.conf"

# Add additional search and nameserver
echo -e "search pak-cspmz.ru cspmz.ru\nnameserver 10.100.143.21\nnameserver 10.100.143.22" > /etc/resolv.conf

# Fix licence warning
sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service

# Fix updates
sed -i -E 's|^(.*)$|#\1|' /etc/apt/sources.list.d/pve-enterprise.list
sed -i '5i deb http://download.proxmox.com/debian/pve buster pve-no-subscription' /etc/apt/sources.list

apt-get update && apt-get --yes upgrade && apt-get --yes --no-install-recommends install \
    mc \
    htop \
    nfs-common \
    ntp \
    tmux

systemctl start ntpd
systemctl enable ntpd
