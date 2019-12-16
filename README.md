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
# 准备环境
cd /tmp/
wget -c wget -c https://github.com/tangx/jumpserver-dockerize/archive/v2.0.2.zip
unzip -q v2.0.2.zip

# 安装容器环境
/bin/bash /tmp/jumpserver-dockerize-2.0.1/docker-install/docker-install.sh


# 下载启动命令 docker-compose
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 安装jumpserver
mkdir -p /data/docker-compose/
cp -a /tmp/jumpserver-dockerize-2.0.1/docker-compose/jumpserver /data/docker-compose/

# 初始化
cd /data/docker-compose/jumpserver

# 执行初始化命令
# 例如: /bin/bash init.sh 192.168.1.203
/bin/bash init.sh SERVER_IPADDR

# 后台启动命令
docker-compose up -d

# 首次运行需要初始化数据，需要等待一段时间。
# 大约 10 分钟后，可以通过浏览器访问页面，验证安装结果
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
