#!/bin/bash
#

cd $(dirname $0)

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
}

case $1 in 
centos|ubuntu) $1 ;;
esac
