# jumpserver docker-compose

version: '3.4'

services:
  # redis
  redis:
    image: redis:5.0.3
    network_mode: host
    restart: always

  # mysql
  mysql:
    image: mysql:5.7.25
    network_mode: host
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    command: 
      - --character-set-server=utf8mb4 
      - --collation-server=utf8mb4_unicode_ci
    volumes:
      - "./initdb.d:/docker-entrypoint-initdb.d:ro"
      - "./data/mysql:/var/lib/mysql:rw"
    ports:
      - 3306:3306
    restart: always
    healthcheck:
      test: "/etc/init.d/mysql status"
      interval: 30s
      timeout: 5s
      retries: 10

  # jumpserver 核心程序
  jumpserver:
    image: tangx/jumpserver:core-1.4.8_2
    network_mode: host
    environment: 
      LANG: zh_CN.UTF-8
      LC_ALL: zh_CN.UTF-8
      SECRET_KEY: ${SECRET_KEY}
      BOOTSTRAP_TOKEN: ${BOOTSTRAP_TOKEN}
      DEBUG: "false"
      ## OTP/MFA 配置
      OTP_ISSUER_NAME: ${OTP_ISSUER_NAME}
      
      # 使用Mysql作为数据库配置
      DB_ENGINE: ${DB_ENGINE}
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}

      # 运行时绑定端口
      HTTP_BIND_HOST: 0.0.0.0
      HTTP_LISTEN_PORT: 8080

      # Use Redis as broker for celery and web socket
      # Redis配置
      REDIS_HOST: ${REDIS_HOST}
      REDIS_PORT: ${REDIS_PORT}
    volumes:
      # nginx
      - "./default.conf:/etc/nginx/conf.d/default.conf:ro"
      # media
      - "./data/jumpserver:/opt/jumpserver/data:rw"
      # logs
      - "./logs/jumpserver:/opt/jumpserver/logs:rw"
    ports:
      - 8080:8080
      - 80:80 
    depends_on:
      - mysql
      - redis
    restart: always
    healthcheck:
      test: "curl -f http://localhost:8080/users/login/"
      interval: 30s
      timeout: 5s
      retries: 10
      start_period: 30s

  # coco: ssh/telnet client
  coco:
    image: tangx/jumpserver:coco-1.4.8
    network_mode: host
    environment: 
      CORE_HOST: ${CORE_HOST}
      BOOTSTRAP_TOKEN: ${BOOTSTRAP_TOKEN}
      LOG_LEVEL: ERROR
    volumes:
      - "./logs/coco:/opt/coco/data/logs:rw"
      - "./data/coco/keys:/opt/coco/data/keys:rw"
      - "/tmp:/tmp"
    ports:
      - 2222:2222
      - 5000:5000
    restart: always
    depends_on: 
      - jumpserver

  # guacamole: rdp/vnc client
  guacamole: 
    image: tangx/jumpserver:guacamole-1.4.8-no8009
    network_mode: host
    environment: 
      JUMPSERVER_SERVER: ${JUMPSERVER_SERVER}
      BOOTSTRAP_TOKEN: ${BOOTSTRAP_TOKEN}
      JUMPSERVER_KEY_DIR: /config/guacamole/keys
      GUACAMOLE_HOME: /config/guacamole
    volumes:
      - "./logs/guacamole:/config/tomcat8/logs:rw"
      - "./data/guacamole/keys:/config/guacamole/keys:rw"
      - "./data/guacamole/drive:/config/guacamole/drive"
    ports:
      - 8081:8081
    entrypoint: "dockerize -wait ${JUMPSERVER_SERVER} entrypoint.sh"
    restart: always
    depends_on: 
      - jumpserver


