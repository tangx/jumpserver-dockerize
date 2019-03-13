# jumpserver dockerize

## TODO

- [ ] 镜像瘦身

## 使用说明

使用前，认真阅读官方文档: https://jumpserver.readthedocs.io/zh/docs/admin_guide.html

+ windows 文件上传下载: https://jumpserver.readthedocs.io/zh/docs/user_asset.html#web-win

## 注意

+ 启动顺序: `redis` ->` mysql/postgresql` -> `jms + nginx` -> `coco / guacomale`
    + `coco / guacomale` 需要访问 `jms:8080` 才能注册, 需要自动做健康检查

## 版本

基于 `jumpserver 1.4.8`, 所有镜像通过 `github.com 上 release` 版本再次编译。

有优化的 `Dockerfile` 可以根据 `dockerfiles` 自行修改


## 感谢

感谢 **jumpserver** 团队

