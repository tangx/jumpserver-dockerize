#!/bin/bash
#

cd $(dirname $0)

function _daemonconfig()
{
echo '{
    "live-restore": true,
    "max-concurrent-downloads": 3,
    "max-concurrent-uploads": 3,
    "registry-mirrors": [
        "https://wlzfs4t4.mirror.aliyuncs.com"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "labels": "io.rancher.project.name,log.ignore",
        "max-size": "1g",
        "max-file": "5"
    },
    "bip": "169.254.32.1/24"
}' > daemon.json

}
function centos()
{
    # step 1: 安装必要的一些系统工具
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    # Step 2: 添加软件源信息
    sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    # Step 3: 更新并安装 Docker-CE
    sudo yum makecache fast
    sudo yum -y install docker-ce

    # Step 3.1: 更新 daemon.json
    mkdir -p /etc/docker
    \cp -a daemon.json /etc/docker/daemon.json

    # Step 4: 开启Docker服务
    systemctl restart docker

    # Step 6: 时间同步
    yum install -y ntp
    systemctl restart ntp
    systemctl enable ntp
}

function ubuntu()
{
    # step 1: 安装必要的一些系统工具
    sudo apt-get update
    sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
    # step 2: 安装GPG证书
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
    # Step 3: 写入软件源信息
    sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
    
    # Step 3.1: 更新 daemon.json
    mkdir -p /etc/docker
    \cp -a daemon.json /etc/docker/daemon.json
    
    # Step 4: 更新并安装 Docker-CE
    sudo apt-get -y update
    sudo apt-get -y install docker-ce

    # Step 5: 启动docker
    systemctl restart docker
    
    # Step 6: 时间同步
    apt install -y ntp
    systemctl restart ntp
    systemctl enable ntp

}

source /etc/os-release

case $ID in 
centos|ubuntu) _daemonconfig; ${ID} ;;
esac
