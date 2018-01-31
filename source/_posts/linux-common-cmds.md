---
title: linux常用命令使用场景总结
date: 2018-01-31 09:58:33
tags:
- linux
- shell
---

# 根据端口号查监听的进程号
[参考](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/lsof.html)

使用模型：`lsof -i :port`

已知某服务占用8088端口，请查出使用该端口的进程号

```
lsof -i :8088
```

> lsof（list open files）是一个查看当前系统文件的工具。在linux环境下，任何事物都以文件的形式存在，通过文件不仅仅可以访问常规数据，还可以访问网络连接和硬件。如传输控制协议 (TCP) 和用户数据报协议 (UDP) 套接字等，系统在后台都为该应用程序分配了一个文件描述符，该文件描述符提供了大量关于这个应用程序本身的信息。[lsof命令详情](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/lsof.html)

# 参考文献
- [Linux工具快速教程](http://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html)
