#!/bin/bash
#
#
cd $(dirname $0)


# [ -f  ./env.conf ] && source ./env.conf
[ -f  ./env.local.conf ] && source ./env.local.conf || {
    cp -a ./env.conf ./env.local.conf
    sed -i "s/xxxxxxxx/$(openssl rand -base64 32 | cut -c 1-16)/" ./env.local.conf
    sed -i "s/yyyyyyyy/$(openssl rand -base64 32 | cut -c 1-16)/" ./env.local.conf
    sed -i "s/zzzzzzzzzzzzz/$(openssl rand -base64 32 | cut -c 1-20)/" ./env.local.conf
    sed -i "s/bbbbbbbbbbb/$(openssl rand -base64 32 | cut -c 1-20)/" ./env.local.conf

    source ./env.local.conf
}


which envsubst || exit 1

which docker-compose || {
   echo "curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose"
}

envsubst '\$IPADDR' < default.conf.tpl > default.conf
envsubst < docker-compose.yml.tpl > docker-compose.yml


echo "
Usage: 
    docker-compose up -d

    openssl rand -base64 32 | cut -c 1-30
"