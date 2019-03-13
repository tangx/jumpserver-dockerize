#!/bin/bash
#
#
cd $(dirname $0)

source ~/env.conf
source ~/env.local.conf

sed -i "s/192.168.100.100/${IPADDR}/g" default.conf


function up()
{
    docker-compose -f docker-compose.yml up -d
}

function down()
{
    docker-compose down
}


case $1 in 
up|down) $1 ;;
esac

