---
title: "OpenSIPS vs Kamailio， 你应该选择哪个？"
date: "2026-03-11 21:05:30"
draft: false
type: posts
tags:
- all
categories:
- all
---


| 维度     | opensips | kamalio | 说明                                                          |
| -------- | -------- | ------- | ------------------------------------------------------------- |
| 性能     | 4.5      | 5       | 性能接近                                                      |
| 脚本能力 | 4        | 5       | kmailio脚本更友好，支持预处理，宏                             |
| 稳定性   | 4        | 5       | opensips开发更激进，所以稳定性没有kamailio高                  |
| 特殊能力 | 5        | 3       | opensips在拓扑隐藏，注册信息同步，动态新增SIP端口方面能力更强 |

无论从哪些方面，OpenSIPS和Kamailio似乎都可以相互替代。

但是，有几个特别的能力，你可能要提前考虑。

# 1. 拓扑隐藏能力


## 1.1. 什么是拓扑隐藏

假设某 VoIP 运营商没有启用拓扑隐藏，对方运营商收到的 `INVITE` 可能是这样的：

```
INVITE sip:441234567890@carrierB.net SIP/2.0
Via: SIP/2.0/UDP gw3.carrierA.net:5060;branch=z9hG4bK-342343
Via: SIP/2.0/UDP core-switch1.internal.local:5060;branch=z9hG4bK-983423
Via: SIP/2.0/UDP edge1.carrierA.net:5060;branch=z9hG4bK-238472
From: <sip:+12065550123@carrierA.net>;tag=98324
To: <sip:+441234567890@carrierB.net>
Call-ID: a98sdasdh23@10.12.0.15
Contact: <sip:fs1.internal.local:5060>
Record-Route: <sip:edge1.carrierA.net;lr>
Record-Route: <sip:core-switch1.internal.local;lr>
User-Agent: FreeSWITCH-mod_sofia/1.10
```

看起来只是普通 SIP 报文，但实际上信息量**非常巨大**。

- Via头会暴露**所有经过的节点**， 只靠一个包就能画出你的 SIP 网络图
- Call-ID暴露内网地址：Call-ID: a98sdasdh23@10.12.0.15
- User-Agent暴露了服务器类型和版本，黑客会直接去查询对应版本的CVE和漏洞
- Record-Route暴露dialog经过哪些节点

黑客利用上面的信息，针对弱点攻击：

* SIP flood
* REGISTER attack
* RTP injection
* SIP scanning


启用拓扑隐藏后，对方只能看到一个对外的SIP Server， 内部网络信息被完全隐藏。

```
INVITE sip:441234567890@carrierB.net SIP/2.0
Via: SIP/2.0/UDP sip.carrierA.net;branch=z9hG4bK-239423
From: <sip:+12065550123@carrierA.net>;tag=98324
To: <sip:+441234567890@carrierB.net>
Call-ID: TH-23hjk23kjh23
Contact: <sip:hidden@sip.carrierA.net>
Record-Route: <sip:sip.carrierA.net;lr>
User-Agent: SIP Proxy
```

## 1.2. 拓扑隐藏到底隐藏什么

通常会处理这些头：

```
Via
Route
Record-Route
Contact
Call-ID
From tag
To tag
```

目的只有一个：

**不让对方看到你的网络结构。**

> 拓扑隐藏还有一个额外的优点：显著减小SIP报文大小，从而提高性能。

## 1.3. 拓扑隐藏的实现差异

| 项目     | 依赖模块               | DB依赖                                                               | 性能 |
| -------- | ---------------------- | -------------------------------------------------------------------- | ---- |
| opensips | topos, topoh           | 依赖数据库存储映射关系(似乎最新版可以不依赖数据库，改为htable实现了) | 高   |
| kamailio | tm(必须), dialog(可选) | 无                                                                   | 中等 |

  
虽然两者都可以实现拓扑隐藏，但是我只在OpenSIPS上成功实现过，在Kamailio尝试过，但没有成功。


# 2. 注册信息集群同步


| 项目     | 依赖模块       | DB依赖 | 协议          | 说明                                                     |
| -------- | -------------- | ------ | ------------- | -------------------------------------------------------- |
| opensips | cluster        | 无     | 二进制        | 可以在运行过程中动态添加节点                             |
| kamailio | DMQ,DMQ_USRLOC | 无     | DMQ是文本协议 | 无法动态新增节点，必须在启动前就在数据库里配置好节点信息。对于Cloud Native并不友好。 |


# 3. 动态添加端口

| 项目     | 动态新增监听端口 | 说明                       |
| -------- | ---------------- | -------------------------- |
| kamailio | 不支持           | 必须重新启动               |
| opensips | 支持             | 可以通过MI动态新增监听端口 |


# 4. 结论

在大部分场景中，选择OpenSIPS和kamailio都是没有区别的。

在侧重拓扑隐藏、注册信息同步、动态新增端口的场景中，OpenSIPS是更好的选择。

# 5. 参考资料

- [Daniel-Constantin.Mierla-Kamailio-Topology-Hiding](./Daniel-Constantin.Mierla-Kamailio-Topology-Hiding.pdf)