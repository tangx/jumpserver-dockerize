# jumpserver dockerize

## TODO

- [ ] 镜像瘦身

## 使用说明

+ 安装 dockerd
```bash
cd docker-install
bash docker-install.sh [centos|ubuntu]
```

+ 启动程序
```bash

# 准备安装目录
mkdir -p /data/docker-compose/
cp -a docker-compose/jumpserver /data/docker-compose/

# 下载启动命令 docker-compose
curl -sfL https://ops-software-binary-1255440668.cos.ap-chengdu.myqcloud.com/docker-compose/1.24.0/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose 

# 初始化
cd docker-compose/jumpserver

# 执行初始化命令
# 例如: /bin/bash init.sh 192.168.1.203
/bin/bash init.sh SERVER_IPADDR

# 后台启动命令
docker-compose up -d

# 通过浏览器访问页面
## 例如 http://192.168.1.203

```

## 注意

+ 使用前，认真阅读官方文档: https://jumpserver.readthedocs.io/zh/docs/admin_guide.html

+ windows 文件上传下载: https://jumpserver.readthedocs.io/zh/docs/user_asset.html#web-win

+ 启动顺序: `redis` ->` mysql/postgresql` -> `jms + nginx` -> `coco / guacomale`
    + `coco / guacomale` 需要访问 `jms:8080` 才能注册, 需要自动做健康检查

## 版本

基于 `jumpserver 1.4.8`, 所有镜像通过 `github.com 上 release` 版本再次编译。

有优化的 `Dockerfile` 可以根据 `dockerfiles` 自行修改


## 感谢

+ jumpserver: https://github.com/jumpserver/jumpserver
+ 启动等待`dockerize` : https://github.com/jwilder/dockerize
+ 环境变量替换 envsubst: https://github.com/docker-library/docs/issues/496


## 勘误

### 内核错误

内核版本过低 `uname -sr` 。 升级内核，或安装低版本 `docker`

+ `yum -y install docker-ce-18.03.1.ce-1.el7.centos`

```
docker: Error response from daemon: OCI runtime create failed: container_linux.go:344: starting container process caused "process_linux.go:293: copying bootstrap data to pipe caused \"write init-p: broken pipe\"": unknown.
```
