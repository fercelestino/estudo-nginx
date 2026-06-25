#!/bin/bash
set -euo pipefail #Propaga o erro em qualquer parte do script para falhar o docker build executante

ARCH=$(dpkg --print-architecture)  # amd64 or arm64

apt-get update
apt-get install -y wget curl gnupg net-tools iputils-ping iproute2

mkdir -p /etc/apt/keyrings
wget -O - http://repos.apiseven.com/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/apisix.gpg > /dev/null

if [ "$ARCH" = "arm64" ]; then
    echo "deb [signed-by=/etc/apt/keyrings/apisix.gpg] http://repos.apiseven.com/packages/arm64/debian bullseye main" | tee /etc/apt/sources.list.d/apisix.list
else
    echo "deb [signed-by=/etc/apt/keyrings/apisix.gpg] http://repos.apiseven.com/packages/debian bullseye main" | tee /etc/apt/sources.list.d/apisix.list
fi

apt-get update
package_version=$(apt-cache policy apisix | grep Candidate | awk '{print $2}')
apt-get install -y apisix=$package_version net-tools

# etcd not needed in standalone mode (config_provider: yaml)
# ETCD_VERSION='3.5.4'
# wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-${ARCH}.tar.gz
# tar -xvf etcd-v${ETCD_VERSION}-linux-${ARCH}.tar.gz
# cd etcd-v${ETCD_VERSION}-linux-${ARCH}
# cp -a etcd etcdctl /usr/bin/
# cd /
# rm -rf etcd-v${ETCD_VERSION}-linux-${ARCH}*

mkdir -p /etc/systemd/system/multi-user.target.wants
# ln -sf /lib/systemd/system/etcd.service    /etc/systemd/system/multi-user.target.wants/etcd.service
ln -sf /lib/systemd/system/apisix.service  /etc/systemd/system/multi-user.target.wants/apisix.service
