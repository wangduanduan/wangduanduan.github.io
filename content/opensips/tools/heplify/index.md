---
title: "heplify SIP信令抓包客户端"
date: "2021-09-12 20:49:51"
draft: false
---
hepfily是个独立的抓包程序，类似于tcpdump之类的，网络抓包程序，可以把抓到的sip包，编码为hep格式。然后送到hep server上，由hepserver负责包的整理和存储。

heplify安装非常简单，在仓库的release页面，可以下载二进程程序。二进程程序赋予可执行权限后，可以直接在x86架构的机器上运行。

因为heplify是go语言写的，你也可以基于源码，编译其他架构的二进制程序。

[https://github.com/sipcapture/heplify](https://github.com/sipcapture/heplify)

- -i 设定抓包的网卡
- -m 设置抓包模式为SIP
- -hs 设置hep server的地址
- -p 设置日志文件的日志
- -dim 设置过滤一些不关心的sip包
- -pr 设置抓包的端口范围
```bash
nohup ./heplify \
  -i eno1 \
  -m SIP \
  -hs 192.168.1.2:9060 \
  -p "/var/log/" \
  -dim OPTIONS,REGISTER \
  -pr "18627-18628" &
```

opensips模块本身就有proto_hep模块支持hep抓包，为什么我还要用heplify来抓包呢？

1. 低于2.2版本的opensips不支持hep抓包
2. opensips的hep抓包还是不太稳定。我曾遇到过因为hep抓包导致opensips崩溃的事故。如果用外部的抓包程序，即使抓包有问题，还是不会影响到opensips。

