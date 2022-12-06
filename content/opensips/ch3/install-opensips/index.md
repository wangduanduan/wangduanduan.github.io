---
title: "debian jessie opensips 2.4.7 安装"
date: "2019-06-13 21:53:16"
draft: false
---

# 1. 安装依赖

```bash
apt-get update -qq && apt-get install -y build-essential net-tools \
    bison flex m4 pkg-config libncurses5-dev rsyslog libmysqlclient-dev \
    libssl-dev mysql-client libmicrohttpd-dev libcurl4-openssl-dev uuid-dev \
    libpcre3-dev libconfuse-dev libxml2-dev libhiredis-dev wget lsof
```


# 2. 编译

下载opensips-2.4.7的源码，然后解压。

include_moduls可以按需指定，你可以只写你需要的模块。
```bash
cd /usr/local/src/opensips-2.4.7
make all -j4 include_modules="db_mysql httpd db_http siprec regex rest_client carrierroute dialplan b2b_logic cachedb_redis proto_tls proto_wss tls_mgm"
make install include_modules="db_mysql httpd db_http siprec regex rest_client carrierroute dialplan b2b_logic cachedb_redis proto_tls proto_wss tls_mgm"
```


