#!/bin/bash
#

# /etc/init.d/guacd start
# /config/tomcat8/bin/catalina.sh run

localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

guacd &
# dockerize -wait ${JUMPSERVER_SERVER} /config/tomcat8/bin/catalina.sh run 
/config/tomcat8/bin/catalina.sh run 
