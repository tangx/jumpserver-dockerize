#!/bin/bash
#
#
cd $(dirname $0)

[ -z "$1" ] && {
    echo "缺少服务器地址"
    echo "Usage: $0 ipaddr"
    echo "  ex: $0 192.168.33.33"
    exit 1
} || {
    export IPADDR=$1
}


# [ -f  ./env.conf ] && source ./env.conf
[ -f  ./env.local.conf ] && source ./env.local.conf || {
    cp -a ./env.conf ./env.local.conf
    sed -i "s/xxxxxxxx/$(strings /dev/urandom |tr -dc A-Za-z0-9 | head -c16)/" ./env.local.conf
    sed -i "s/yyyyyyyy/$(strings /dev/urandom |tr -dc A-Za-z0-9 | head -c16)/" ./env.local.conf
    sed -i "s/zzzzzzzzzzzzz/$(strings /dev/urandom |tr -dc A-Za-z0-9 | head -c24)/" ./env.local.conf
    sed -i "s/bbbbbbbbbbb/$(strings /dev/urandom |tr -dc A-Za-z0-9 | head -c24)/" ./env.local.conf

    sed -i "s/192.168.100.100/${IPADDR}/" ./env.local.conf
    source ./env.local.conf
}


which envsubst || exit 1

which docker-compose || {
   echo "curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose"
}

envsubst '\$IPADDR' < default.conf.tpl > default.conf
envsubst < docker-compose.yml.tpl > docker-compose.yml


# echo "
# Usage: 
#     docker-compose up -d

#     openssl rand -base64 32 | cut -c 1-30
#     strings /dev/urandom |tr -dc A-Za-z0-9 | head -c16
# "