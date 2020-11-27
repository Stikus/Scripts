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
# sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
sed -i.bak -z "s/res === null || res === undefined || \!res || res\n\t\t\t.data.status.toLowerCase() \!== 'active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service

# Fix updates
sed -i -E 's|^(.*)$|#\1|' /etc/apt/sources.list.d/pve-enterprise.list
sed -i '5i deb http://download.proxmox.com/debian/pve buster pve-no-subscription' /etc/apt/sources.list

# Locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
echo 'LANG="en_US.UTF-8"'> /etc/default/locale && \
dpkg-reconfigure --frontend=noninteractive locales && \
update-locale LANG=en_US.UTF-8

apt-get update && apt-get --yes dist-upgrade && apt-get --yes upgrade && apt-get --yes install \
    mc \
    htop \
    nfs-common \
    ntp \
    tmux

lvremove -y /dev/pve/data
lvextend --resizefs -l +100%FREE pve/root

# # Mdadm part
# apt-get install -y mdadm
# mdadm --zero-superblock --force /dev/nvme{0..3}n1
# wipefs --all --force /dev/nvme{0..3}n1
# mdadm --create --verbose /dev/md0 -l 10 -n 4 /dev/nvme{0..3}n1
# mkdir -p /etc/mdadm
# echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
# mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
# mkfs.ext4 /dev/md0
# mkdir /mnt/data
# echo "/dev/md0        /mnt/data    ext4    defaults    0 0" >> /etc/fstab
# mount -a
