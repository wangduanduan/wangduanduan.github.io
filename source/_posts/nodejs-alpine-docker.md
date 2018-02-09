---
title: Nodejs alpine 基础docker镜像构建
date: 2018-01-29 14:10:15
tags:
- nodejs
- docker
---

# 1. 系统环境
- centos7 内核：3.10.0-514.26.2.el7.x86_64
- 安装docker要求内核版本不低于3.10

# 2. 安装docker
```
yum install docker // 安装docker
systemctl start docker.service // 启动docker
systemctl enable docker.service // 设置开机启动
```

# 3. Nodejs 镜像选择

REPOSITORY | TAG | IMAGE ID | CREATED | SIZE
---|---|---|---|---
docker.io/node | 9.2.1-slim | 69c9f9292fa4 | 3 days ago | 230 MB
docker.io/node | 9.2.1-alpine | afdc3aaaf748 | 3 days ago | 67.46 MB
docker.io/node | latest | 727b047a1f4e | 3 days ago | 675.6 MB
docker.io/iron/node | latest | 9ca501065d18 | 20 months ago | 18.56 MB

`选择镜像的标准`

- 官方的
- 经常维护的
- 体积小的
- 要有yarn 和 npm 
- node版本要高

最终选择 `node:9.2.1-alpine`, 该镜像体积很小，已经内置npm(5.5.1), yarn(1.3.2)

# 4. 时区配置
`node:9.2.1-alpine`的时区默认不是国内的，需要在build时，配置时区。

```
FROM node:9.2.1-alpine

# Install base packages and set timezone ShangHai
RUN apk update && apk add bash tzdata \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

...
...
...

CMD [ "node" ]
```

验证：
```
➜  node-dockerfile git:(master) docker run -it  e595 sh 
/ # yarn -v
1.3.2
/ # npm  -v
5.5.1
/ # node -v
v9.2.1
/ # date
Tue Dec 12 17:33:26 CST 2017
```


