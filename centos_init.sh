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

# export TZ="Europe/Moscow"
# rm /etc/localtime \
#     && echo "$TZ" > /etc/timezone \
#     && dpkg-reconfigure tzdata
#
# # docker
# apt-get --yes --no-install-recommends install \
#     apt-transport-https \
#     ca-certificates \
#     gpg-agent \
#     && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
#     && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
#     && apt-get update \
#     && apt-get --yes --no-install-recommends install docker-ce
#
# # Docker sertificate
# wget -q "ftp://bioftp.cspmz.ru/certs/cspmzCA.pem" -O "/etc/ssl/certs/cspmzCA.pem" \
#     && update-ca-certificates \
#     && systemctl restart docker.service
#
# # Add user 'MAINUSER' to 'docker' group
# usermod -a -G docker "$MAINUSER"
#
# # python3.6 & pip3
# apt-get --yes --no-install-recommends install python3.6 python3.6-dev python3-pip python3-testresources \
#     && rm /usr/bin/python3 \
#     && ln -s /usr/bin/python3.6 /usr/bin/python3 \
#     && ln -s /usr/bin/python3.6 /usr/bin/python
# pip3 install --upgrade pip
# hash -d pip3
# pip3 install --upgrade wheel setuptools
# pip3 install --upgrade psutil
#
# # java8
# apt-get --yes --no-install-recommends install openjdk-8-jdk
# export _JAVA_OPTIONS="-Djava.io.tmpdir=$TMPDIR"
#
# # cwltool 1.0.20190915164430
# pip3 install 'cwltool==1.0.20190915164430'
#
# # shellcheck 0.7.0
# wget -q "https://shellcheck.storage.googleapis.com/shellcheck-v0.7.0.linux.x86_64.tar.xz" -O "shellcheck-v0.7.0.linux.x86_64.tar.xz" \
#     && tar -xJf "shellcheck-v0.7.0.linux.x86_64.tar.xz" \
#     && mv shellcheck-v0.7.0/shellcheck /usr/local/bin \
#     && rm "shellcheck-v0.7.0.linux.x86_64.tar.xz" \
#     && rm -r shellcheck-v0.7.0/
#
# # memUsage #6c2474a [v0.2.0 02.09.2019]
# # psutil >= 2.2.1 (Tested with 5.6.1 - ok; 1.2.1 - err) - additional python package required for memUsage.
# wget -q "https://raw.githubusercontent.com/serge2016/memUsage/6c2474a6879eecc544dfd5a68e2ffc2d98ead014/memUsage.py" -O - | tr -d '\r' > "/usr/local/bin/memUsage.py" \
#     && chmod +x "/usr/local/bin/memUsage.py"
# export MEMUSAGE="/usr/local/bin/memUsage.py"
#
#
# export SOFT="/soft"
# mkdir -p "$SOFT"
#
# # Add GKS vm01 pub RSA-key
# sudo -Hu "$MAINUSER" bash -c 'mkdir -p "$HOME/.ssh" && wget -q "ftp://bioftp.cspmz.ru/certs/keys/GKS_id_rsa.pub" -O ->> "$HOME/.ssh/authorized_keys"'
#
# # Final updates
# apt-get update && apt-get -y dist-upgrade
