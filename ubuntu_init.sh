#!/usr/bin/env bash


# all commands executed from 'root' => 'sudo su' before use
# wget -q https://raw.githubusercontent.com/Stikus/Scripts/master/ubuntu_init.sh AKA http://tiny.cc/stik_ubuntu

MAINUSER="bio"
BASHRC="/home/$MAINUSER/.bashrc"

# swapfile settings
swapoff /swapfile
rm /swapfile
touch /swapfile
chmod 600 /swapfile
dd if=/dev/zero of=/swapfile bs=1M count=8192 oflag=append conv=notrunc
mkswap /swapfile
swapon /swapfile

export DEBIAN_FRONTEND="noninteractive"

apt-get update && apt-get --yes upgrade && apt-get --yes --no-install-recommends install \
    build-essential \
    pkg-config \
    python3-dev \
    python3-testresources \
    software-properties-common \
    ncurses-dev \
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
    xz-utils \
    mc \
    parallel \
    htop \
    iotop \
    git-core \
    ssh \
    openssh-client \
    openssl \
    libssl-dev \
    libyaml-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libpq-dev \
    qemu-guest-agent \
    cifs-utils \
    xfsprogs \
    nfs-common \
    nfs-kernel-server \
    tree \
    ntp \
    tmux \
    ceph-common

systemctl start ntpd
systemctl enable ntpd

export TZ="Europe/Moscow"
rm /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && dpkg-reconfigure tzdata

# docker - https://docs.docker.com/engine/install/ubuntu/
apt-get --yes --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    gpg-agent \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get --yes --no-install-recommends install docker-ce

# Docker sertificate
wget -q "ftp://bioftp.cspmz.ru/certs/cspmz-hq-ca-vs-02-ca.crt" -O "/etc/ssl/certs/cspmz-hq-ca-vs-02-ca.crt" \
    && update-ca-certificates \
    && systemctl restart docker.service

# Add user 'MAINUSER' to 'docker' group
usermod -a -G docker "$MAINUSER"

# pip3
curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py --force-reinstall \
    && rm get-pip.py
pip3 install 'setuptools<58'
pip3 install --upgrade psutil


# gcc
apt-get -y --no-install-recommends install \
    g++-7 \
    gcc-7

# java8
apt-get --yes --no-install-recommends install openjdk-8-jdk
export _JAVA_OPTIONS="-Djava.io.tmpdir=$TMPDIR" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
echo 'export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> "$BASHRC"

# cwltool 3.1.20210816212154
pip3 install 'cwltool==3.1.20210816212154'

# shellcheck 0.7.2
wget -q "https://github.com/koalaman/shellcheck/releases/download/v0.7.2/shellcheck-v0.7.2.linux.x86_64.tar.xz" -O "shellcheck-v0.7.2.linux.x86_64.tar.xz" \
    && tar -xJf "shellcheck-v0.7.2.linux.x86_64.tar.xz" \
    && mv shellcheck-v0.7.2/shellcheck /usr/local/bin \
    && rm "shellcheck-v0.7.2.linux.x86_64.tar.xz" \
    && rm -r shellcheck-v0.7.2/

# memUsage #6c2474a [v0.2.0 02.09.2019]
# psutil >= 2.2.1 (Tested with 5.6.1 - ok; 1.2.1 - err) - additional python package required for memUsage.
wget -q "https://raw.githubusercontent.com/serge2016/memUsage/6c2474a6879eecc544dfd5a68e2ffc2d98ead014/memUsage.py" -O - | tr -d '\r' > "/usr/local/bin/memUsage.py" \
    && chmod +x "/usr/local/bin/memUsage.py"
export MEMUSAGE="/usr/local/bin/memUsage.py"
echo 'export MEMUSAGE="/usr/local/bin/memUsage.py"' >> "$BASHRC"

export SOFT="/home/$MAINUSER/soft"
echo 'export SOFT="/home/'$MAINUSER'/soft"' >> "$BASHRC"
mkdir -p "$SOFT"

# cmake 3.20.1
cd "$SOFT" \
    && wget -q "https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1-linux-x86_64.sh" -O "$SOFT/cmake-3.20.1-linux-x86_64.sh" \
    && sh "$SOFT/cmake-3.20.1-linux-x86_64.sh" --prefix="$SOFT" --include-subdir --skip-license \
    && rm "$SOFT/cmake-3.20.1-linux-x86_64.sh"
export PATH="$SOFT/cmake-3.20.1-linux-x86_64/bin:$PATH"
echo 'export PATH="$SOFT/cmake-3.20.1-linux-x86_64/bin:$PATH"' >> "$BASHRC"

# Add GKS Server pub RSA-key
sudo -Hu "$MAINUSER" bash -c 'mkdir -p "$HOME/.ssh" && wget -q "ftp://bioftp.cspmz.ru/certs/keys/GKS_Server_id_rsa.pub" -O ->> "$HOME/.ssh/authorized_keys"'
# Add tmux config with mouse enabled
sudo -Hu "$MAINUSER" bash -c 'wget -q "ftp://bioftp.cspmz.ru/certs/keys/.tmux.conf" -O "$HOME/.tmux.conf"'

# Final updates
# apt-get update && apt-get -y dist-upgrade
