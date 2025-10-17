---
title: "SipWise C5 架构分析 WIP"
date: "2025-10-16 17:39:50"
draft: false
type: posts
tags:
- all
- wip
categories:
- all
---

# SIPWISE C5 架构分析

Sipwise C5（又称NGCP——下一代通信平台）是一款基于SIP的开源Class 5 VoIP软交换平台

![](./arch.drawio.png)


整体架构上，sipwise C5 是一个三明治架构， 除了sipwise, 我也看到过类似的VoIP架构， 可见英雄所见略同。


## 接入层

接入层是整个平台的信令出入口，主要的职责是安全检测和负载均衡。 并不具有业务上的功能，另外也不会使用数据库。

**职责**

- 外部SIP信令的入口和内部信令的出口
- SIP信令完整性检查
- 拒绝环回SIP信令
- DOS攻击检测
- 暴力攻击检测
- TLS转UDP转换
- NAT穿透映射

**端口**
- 5060, SIP/TCP+UDP, 对外接收SIP消息
- 5061, SIP/TLS， 对外接收TLS消息
- 5060, XMLRPC/TCP, 对内处理RPC调用，来控制kamailio

> 这里有个风险，5060/TCP端口同时用来对外处理SIP消息和对接处理RPC调用，难道

**实现**



# 参考
- https://www.sipwise.com/doc/mr6.5.8/sppro/ar01s02.html
- https://www.sipwise.com/doc/mr10.3.1/spce/ce/mr10.3.1/architecture/architecture.html