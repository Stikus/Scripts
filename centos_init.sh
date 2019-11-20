#!/usr/bin/env bash


# all commands executed from 'root' => 'sudo su' before use
# link to this file: https://raw.githubusercontent.com/Stikus/Scripts/master/centos_init.sh OR http://tiny.cc/stik_centos
# curl -sSL tiny.cc/stik_centos -o centos.sh

MAINUSER="bio"

yum -y install epel-release && yum -y update && yum -y install \
    pkgconfig \
    cmake \
    curl \
    wget \
    time \
    tzdata \
    gawk \
    bzip2 \
    pigz \
    zip \
    unzip \
    pigz \
    mc \
    nano \
    parallel \
    htop \
    iotop \
    git \
    openssh-server \
    openssh-clients \
    qemu-guest-agent \
    tree \
    kernel-devel \
    kernel-headers \
    && yum -y groupinstall 'Development Tools'

# Add GKS vm01 pub RSA-key for root
mkdir -p "$HOME/.ssh" && wget -q "ftp://bioftp.cspmz.ru/certs/keys/GKS_id_rsa.pub" -O ->> "$HOME/.ssh/authorized_keys"

# Add GKS vm01 pub RSA-key for MAINUSER
sudo -Hu "$MAINUSER" bash -c 'mkdir -p "$HOME/.ssh" && wget -q "ftp://bioftp.cspmz.ru/certs/keys/GKS_id_rsa.pub" -O ->> "$HOME/.ssh/authorized_keys"'
