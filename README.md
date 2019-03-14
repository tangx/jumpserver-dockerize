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
cd docker-compose/jumpserver
cp -a env.conf env.local.conf
# vi env.local.conf
bash init.sh
docker-compose up -d
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
