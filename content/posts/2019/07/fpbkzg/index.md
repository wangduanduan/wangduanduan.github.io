---
title: "Docker相关问题及解决方案"
date: "2019-07-08 11:59:59"
draft: false
---

# 使用HTTP仓库
默认docker不允许使用HTTP的仓库，只允许HTTPS的仓库。如果你用http的仓库，可能会报如下的错误。

Get https://registry:5000/v1/_ping: http: server gave HTTP response to HTTPS client

解决方案是：配置insecure-registries使docker使用我们的http仓库。

在 **/etc/docker/daemon.json 文件中添加**

```bash
{
  "insecure-registries" : ["registry:5000", "harbor:5000"]
}
```

重启docker

```bash
service docker restart

# 执行命令 docker info | grep insecure 应该可以看到不安全仓库
```


# 存储问题

有些docker的存储策略并未指定，在运行容器时，可能会报如下错误

/usr/bin/docker-current: Error response from daemon: error creating overlay mount to

解决方案：

vim /etc/sysconfig/docker-storage 

```bash
DOCKER_STORAGE_OPTIONS="-s overlay"
```

```bash
systemctl daemon-reload
service docker restart
```


<br />

