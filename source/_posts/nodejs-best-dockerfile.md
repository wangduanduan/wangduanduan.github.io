---
title: Nodejs Express dockerfile最佳实践
date: 2018-02-08 09:28:04
tags:
- nodejs
- docker
- dockerfile
---

# 1. 少啰嗦，先看代码
## 1.1. package.json
```
{
  "name": "xxx",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "start": "node ./bin/www",
    "forever": "node_modules/forever/bin/forever bin/www"
  },
  "dependencies": {
    "async": "0.9.0",
    "body-parser": "1.13.2",
    "compression": "1.6.2",
    "config": "1.12.0",
    "connect-multiparty": "2.0.0",
    "cookie-parser": "1.3.5",
    "debug": "2.2.0",
    "ejs": "2.3.3",
    "express": "4.13.1",
    "forever": "0.15.3",
    "http-proxy-middleware": "0.17.3",
    "log4js": "0.6.24",
    "serve-favicon": "2.3.0"
  }
}
```

## 1.2. dockerfile
```
FROM node:9.2.1-alpine

RUN apk update && apk add bash tzdata \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

WORKDIR /app

COPY package.json yarn.lock /app/

RUN yarn install --production && yarn cache clean

COPY . /app

EXPOSE 8088

CMD yarn run server
```

# 2. 分析原理
- 使用alpine的nodejs镜像，显著缩小nodejs镜像大小
- node:9.2.1-alpine自带yarn 和 npm
- copy package到run npm i到copy . /app, 这样的顺序可以充分使用镜像缓存

`修改过后，对比之前通过jenkins打包时间从10分钟缩短到7.4秒`


# 3. 参考资料
- [How to write excellent Dockerfiles](https://rock-it.pl/how-to-write-excellent-dockerfiles/)

