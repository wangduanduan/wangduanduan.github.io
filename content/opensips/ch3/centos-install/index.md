---
title: "centos7 安装opensips"
date: "2019-09-05 12:09:35"
draft: false
---


# 安装依赖
```bash
yum update && yum install epel-release
yum install openssl-devel mariadb-devel libmicrohttpd-devel \
libcurl-devel libconfuse-devel ncurses-devel 
```



# 编译

下面的脚本，默认将opensips安装在/usr/local/etc/目录下

```bash
> cd opensips-2.4.6
# 编译
> make all -j4 include_modules="db_mysql httpd db_http regex rest_client carrierroute dialplan"
# 安装
> make install include_modules="db_mysql httpd db_http regex rest_client carrierroute dialplan"
```

如果想要指定安装位置，可以使用**prefix**参数指定，例如指定安装在/usr/aaa目录

```bash
> cd opensips-2.4.6
# 编译
> make all -j4 prefix=/usr/aaa include_modules="db_mysql httpd db_http regex rest_client carrierroute dialplan"
# 安装
> make install prefix=/usr/aaa include_modules="db_mysql httpd db_http regex rest_client carrierroute dialplan"
```


