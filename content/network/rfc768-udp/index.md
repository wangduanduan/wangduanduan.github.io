---
title: "RFC768 UDP包学习笔记"
date: "2025-01-01 20:23:41"
draft: false
type: posts
tags:
- udp
categories:
- all
---



# 包格式

UDP包头工占用8个字节,  其中源端口和目标端口各占2个字节，长度占2个字节，校验和占2个字节。

```
    0      7 8     15 16    23 24    31
   +--------+--------+--------+--------+
   |     Source      |   Destination   |
   |      Port       |      Port       |
   +--------+--------+--------+--------+
   |                 |                 |
   |     Length      |    Checksum     |
   +--------+--------+--------+--------+
   |
   |          data octets ...
   +---------------- ...

        User Datagram Header Format
```



# 字段

- **源端口**，可选字段，默认为0，如果是有意义的其他端口，表示后续响应可以送回到该端口
- **目标端口**，必须字段，用来关联目标主机上进程监听的端口
- **长度**，长度是整个UDP包的长度，也就是包头 + 包的数据，包头固定8字节，那么length的最小长度就是8
- **校验和**，用来验证传输过程中是否发生了错误。校验和的计算结果与源IP、目标IP、UDP的包长有关。 如果校验和失败，那么消息会被丢弃。 有些校验和计算的工作会被放置在网卡上，从而减少CPU的负载。当然如果在网卡上因为校验和的问题被网卡丢弃，上层应用是收不到不到UDP包的。但是用tcpdump可以抓到这种校验和有问题的包。



> 思考1： 为什么源端口可以设置为0？ 
>
> 答：有些UDP包，是不需要响应的，只需要发送出消息。



# 参考

- https://datatracker.ietf.org/doc/html/rfc768
- https://wdd.js.org/opensips/ch7/big-udp-msg/
- https://wdd.js.org/network/udp-checksum-offload/
