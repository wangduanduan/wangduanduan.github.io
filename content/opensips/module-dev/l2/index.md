---
title: "ch2 初始化环境"
date: "2021-04-20 13:29:47"
draft: false
---

# 环境说明
- ubuntu 20.04
- opensips 2.4


# 克隆仓库
由于github官方的仓库clone太慢，最好选择从国内的gitee上克隆。

下面的gfo, gco, gl, gcb都是oh-my-zsh中git插件的快捷键。建议你要么安装oh-my-zsh, 或者也可以看看这些快捷方式对应的底层命令是什么 [https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)
```bash
git clone https://gitee.com/wangduanduan/opensips.git
gfo 2.4:2.4
gco 2.4
gl
gcb home_location #基于2.4分支创建home_location分支
```


# 安装依赖

```bash
apt update
apt install -y build-essential bison flex m4 pkg-config libncurses5-dev \
rsyslog libmysqlclient-dev \
libssl-dev mysql-client libmicrohttpd-dev libcurl4-openssl-dev uuid-dev \
libpcre3-dev libconfuse-dev libxml2-dev libhiredis-dev
```


# 编译安装
```bash
make all -j4 include_modules="db_mysql"
make install include_modules="db_mysql"
```

# 测试

```bash
➜  opensips git:(home_location) opensips -V
version: opensips 2.4.9 (x86_64/linux)
flags: STATS: On, DISABLE_NAGLE, USE_MCAST, SHM_MMAP, PKG_MALLOC, F_MALLOC, FAST_LOCK-ADAPTIVE_WAIT
ADAPTIVE_WAIT_LOOPS=1024, MAX_RECV_BUFFER_SIZE 262144, MAX_LISTEN 16, MAX_URI_SIZE 1024, BUF_SIZE 65535
poll method support: poll, epoll, sigio_rt, select.
git revision: 9c2c8638e
main.c compiled on 13:49:33 Apr 20 2021 with gcc 9
```

