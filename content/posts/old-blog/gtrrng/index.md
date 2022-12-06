---
title: "树莓派安装fs 1.10"
date: "2020-11-18 13:04:21"
draft: false
---
```bash
1. 将源码包上传到服务器, 并解压
```


# 安装依赖
```bash
apt update
apt install autoconf \
libtool \
libtool-bin \
libjpeg-dev \
libsqlite3-dev \
libspeex-dev libspeexdsp-dev \
libldns-dev \
libedit-dev \
libtiff-dev \
libavformat-dev
libswscale-dev libsndfile-dev \
liblua5.1-0-dev
libcurl4-openssl-dev libpcre3-dev libopus-dev libpq-dev
```


# 配置

```bash
./bootstrap.sh
./configure
```



# make

```bash
make && make install
```

参考：[https://www.cnblogs.com/MikeZhang/p/RaspberryPiInstallFreeSwitch.html](https://www.cnblogs.com/MikeZhang/p/RaspberryPiInstallFreeSwitch.html)

