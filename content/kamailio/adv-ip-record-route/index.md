---
title: "对外地址和record-route的问题"
date: "2024-12-23 19:23:43"
draft: true
type: posts
tags:
- all
categories:
- all
---

网络结构图如下：

- client就是客户端
- PUBLIC_IP就是VPC1的公网IP
- VPC1和VPC2使用内网IP交互
- VPC2没有公网IP

```c
client --- 1.2.3.4/udp ---> VPC1 --- 192.168.0.10/udp ---> VPC2
```


节点   | 内网IP | 公网IP
---   | ---   | ---
VPC1  | 192.168.0.10 | 1.2.3.4
VPC2  | 192.168.0.11 | 无


1. client通过1.2.3.4访问VPC1
2. VPC1因为要在后续请求中也保持在路径中，所以要做record-route
3. 
