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

无论从哪些方面，OpenSIPS和Kamailio似乎都可以相互替代。

但是，有几个特殊的地方，你可能要提前考虑，而不要走到死路再回头。

# 1. 拓扑隐藏


---

##  1.1. 最简单的场景：不做拓扑隐藏

假设一个典型架构：

```
UAC  →  SIP Proxy  →  Media Server
```

例如：

```
Alice (10.1.1.10)
        |
     Proxy
        |
FreeSWITCH (10.1.2.20)
```

Alice 呼叫 Bob，发送 `INVITE`。

原始 SIP 请求：

```
INVITE sip:bob@example.com SIP/2.0
Via: SIP/2.0/UDP 10.1.1.10:5060
From: <sip:alice@example.com>
To: <sip:bob@example.com>
Call-ID: 123456@10.1.1.10
Contact: <sip:alice@10.1.1.10>
```

经过 Proxy 转发后：

```
INVITE sip:bob@10.1.2.20 SIP/2.0
Via: SIP/2.0/UDP proxy.example.com
Via: SIP/2.0/UDP 10.1.1.10
From: <sip:alice@example.com>
To: <sip:bob@example.com>
Call-ID: 123456@10.1.1.10
Contact: <sip:alice@10.1.1.10>
```

FreeSWITCH 现在可以看到：

* UAC IP：`10.1.1.10`
* 内部网络结构
* Proxy 地址

**整个网络拓扑完全暴露。**

---

## 1.2. 使用拓扑隐藏

加入拓扑隐藏后：

```
UAC → OpenSIPS → FreeSWITCH
```

代理会 **重写关键 SIP 头部**。

Alice 发出：

```
INVITE sip:bob@example.com SIP/2.0
Via: SIP/2.0/UDP 10.1.1.10
Call-ID: 123456@10.1.1.10
Contact: <sip:alice@10.1.1.10>
```

经过拓扑隐藏：

```
INVITE sip:bob@10.1.2.20 SIP/2.0
Via: SIP/2.0/UDP proxy.example.com
Call-ID: th-98asdj21
Contact: <sip:hidden@proxy.example.com>
```

FreeSWITCH 看到的只有：

```
proxy.example.com
```

看不到：

* Alice IP
* 内部地址
* 原始 Call-ID

这就是 **Topology Hiding**。

- **只保留一个Via头**
- **删除所有的Record-Route头**
- **删除所有的Route头**
- **改写Call-ID**
- **改写Contact**

---

## 1.3. 运营商之间的拓扑隐藏

在 VoIP 运营网络里更常见：

```
Carrier A
    |
OpenSIPS (Topology Hiding)
    |
Carrier B
```

如果没有隐藏：

Carrier B 会看到：

```
Via: SIP/2.0/UDP carrierA-gw1
Via: SIP/2.0/UDP carrierA-switch
Via: SIP/2.0/UDP opensips
```

可以推断：

* Carrier A 的网关
* SBC
* 内部路由

这是非常敏感的信息。

---

做了拓扑隐藏后：

Carrier B 只会看到：

```
Via: SIP/2.0/UDP edge-proxy.example.com
Call-ID: TH-k2j3k23
Contact: <sip:proxy@example.com>
```

Carrier B 完全不知道：

```
Carrier A 的网络结构
```

---

## 1.4. 呼叫结束时的拓扑恢复

例如：

```
BYE sip:hidden@proxy.example.com
```

代理内部保存了映射：

```
hidden@proxy → alice@10.1.1.10
```

于是恢复并发送：

```
BYE sip:alice@10.1.1.10
```

对外：

```
Proxy
```

对内：

```
真实地址
```

---

## 1.5. 一个更复杂的真实运营场景

实际上，在真实 VoIP 网络中，如果没有 SIP 拓扑隐藏，一个 `INVITE` 报文往往可以**暴露整个运营网络的结构**。很多做安全审计的人只需要抓一个包，就能推断出你的架构。

下面我们用一个真实风格的 SIP 报文来说明。

---

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

---

**从一个 SIP 包能推断什么?**

### 1.5.1. 网络拓扑结构

`Via` 头会暴露**所有经过的节点**

```sh
gw3.carrierA.net
core-switch1.internal.local
edge1.carrierA.net
```

攻击者可以推断：

```
Carrier A Network

edge1.carrierA.net   (edge SBC)
        |
core-switch1         (routing proxy)
        |
gw3.carrierA.net     (termination gateway)
```

只靠一个包就能画出你的 SIP 网络图。

---

### 1.5.2. 内网地址

```
Call-ID: a98sdasdh23@10.12.0.15
```

暴露：

```
10.12.0.0/16
```

攻击者可以判断：

* 内网网段
* 服务器结构

很多 SIP flood 攻击就是这么来的。

---

### 1.5.3. 你的软交换类型

```
User-Agent: FreeSWITCH-mod_sofia/1.10
```

这直接暴露：

软件版本：

```
FreeSWITCH 1.10
```

攻击者会马上去查：

* CVE
* exploit
* SIP fuzzing

---

### 1.5.4. 服务器命名规则

```
fs1.internal.local
core-switch1.internal.local
```

可以推断：

服务器命名规范：

```
fs1
fs2
fs3
```

攻击者甚至可以猜出：

```
fs2.internal.local
fs3.internal.local
```

---

### 1.5.5. 路由逻辑

通过 `Record-Route`：

```
Record-Route: edge1
Record-Route: core-switch1
```

可以知道：

SIP dialog 会经过哪些节点。

---

### 1.5.6. 运营规模

例如：

```
gw3.carrierA.net
```

意味着至少：

```
gw1
gw2
gw3
```

攻击者知道：

**至少三个网关。**

---

### 1.5.7. 真实攻击案例

很多 VoIP 平台被攻击其实是因为：

**SIP header 泄露架构。**

攻击流程通常是：

1️⃣ 抓 SIP 包

2️⃣ 提取：

```
Via
Contact
Call-ID
User-Agent
```

3️⃣ 建立网络图

```
Edge Proxy
Core Proxy
Media Server
Gateway
```

4️⃣ 针对弱点攻击：

* SIP flood
* REGISTER attack
* RTP injection
* SIP scanning

---

### 1.5.8. 启用拓扑隐藏后

如果使用
OpenSIPS
或
Kamailio

做 topology hiding，对方看到的包可能变成：

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

对方只能看到：

```
sip.carrierA.net
```

内部结构完全隐藏。

---

### 1.5.9. 一个有意思的事实

很多 Tier-1 VoIP 运营商有一个安全规则：

**任何外部 SIP 包不得包含 internal hostname。**

例如：

禁止：

```
*.internal.local
*.lan
10.x.x.x
192.168.x.x
```

否则就算：

**安全事故。**


---

## 1.6. 拓扑隐藏到底隐藏什么

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

---

## 1.7. 一个直观类比

拓扑隐藏就像：

**电话转接总机**

真实情况：

```
你 → 总机 → 某个部门
```

但你看到的始终只有：

```
公司总机号码
```

你永远不知道：

* 部门号码
* 内部线路

SIP 拓扑隐藏就是这个作用。

---


## 1.8. 拓扑隐藏的实现

上面所有论述，只是说明，在某些领域拓扑隐藏是必须的，虽然kamailio 和 opensips 都提供了拓扑隐藏功能。

但是两者实现差异很大。

- Kamailio
  - 拓扑隐藏必须依赖数据库，例如mysql或者redis
  - 拓扑隐藏只能把内网地址换成一个假的虚拟地址，无法做多余SIP头的删除
- OpenSIPS
  - 基本上能移除所有涉及到网络拓扑的SIP头
  - 无需数据库依赖，拓扑映射直接在内存中实现。当然也有缺点，挂了服务就很难恢复。
  
综上：**在拓扑隐藏这个场景下，优先选择OpenSIPS**


# 2. 注册信息集群同步

- kamailio的多节点注册信息同步，依赖DMQ模块，该模块的逻辑就是把注册信息当作SIP消息再分发出去。
- opensips使用cluster模块来同步注册信息

虽然两者似乎都能在多节点同步注册信息， 但是kamailio的节点必须在数据库配置好，无法动态加入节点。

但是OpenSIPS，是可以动态添加节点的，并且节点之间可以进行通信。


综上： **在注册信息同步领域，优先选择OpenSIPS**


# 3. 动态添加端口

kamailio无法在运行过程中新增SIP端口，只能重启。

OpenSIPS在3.x 版本中支持动态添加端口，无需重启。

综上：**对于需要动态添加端口的场景，优先选择OpenSIPS**
