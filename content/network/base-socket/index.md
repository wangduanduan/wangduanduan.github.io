---
title: "基本套接字API回顾"
date: "2019-11-25 20:06:16"
draft: false
---


# 套接字API
```c
SOCKET socket(int domain, int type, int protocol)
```

Socket API和协议无关，即可以用来创建Socket，无论是TCP还是UDP，还是进程间的通信，都可以用这个接口创建。

- domain 表示通信域，最长见的有以下两个域
   - AF_INET 因特网通信
   - AF_LOCAL 进程间通信
- type 表示套接字的类型
   - SOCK_STREAM 可靠的、全双工、面向连接的，实际上就是我们熟悉的TCP
   - SOCK_DGRAM 不可靠、尽力而为的，无连接的。实际上指的就是UDP
   - SOCK_RAW 允许对IP层的数据进行访问。用于特殊目的，例如ICMP
- protocol 表示具体通信协议

**TCP/IP 本自同根生！**

