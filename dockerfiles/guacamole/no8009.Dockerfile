FROM tangx/jumpserver:guacamole-1.4.8

RUN sed -i '/8009/d' /config/tomcat8/conf/server.xml

