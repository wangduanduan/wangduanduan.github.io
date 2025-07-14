---
title: "OpenSIPS Summit 2025 速看"
date: "2025-07-14 21:52:23"
draft: false
type: posts
tags:
  - opensips
categories:
  - all
---

2025 年 5 月 27 - 5 月 30 日, OpenSIPS Summit 2025 在荷兰阿姆斯特丹举行。

最近我才有时间，看完所有的会议资料，包括 PDF 和 PPT。

下面是我整理的，认为比较有价值的一些内容。以飨读者。

# 1. 加强 SDP 处理

对 SDP 的处理，如果用 OpenSIPS 脚本来做，将会非常蹩脚。 生产环境一般都是使用 rtpengine 或者 rtpproxy 来处理。

但是，最近的 OpenSIPS 版本，已经可以支持 SDP 处理了。 可以直接在 OpenSIPS 脚本里处理 SDP。

说实话，我看了新的方案，我觉得，还不如用 rtpengine 或者 rtpproxy。

但是聊胜于无吧，感兴趣的可以看看原文。

[OpenSIPS Summit 2025 - Liviu Chircu - Enhanced Media Operations with Structured SDP](./OpenSIPS%20Summit%202025%20-%20Liviu%20Chircu%20-%20Enhanced%20Media%20Operations%20with%20Structured%20SDP.pdf)

除此以外，PDF 也提到一些有趣的事情，比如 SDP 随着时间推移，增强和很多功能，包也变得越来越大

| 时期 | 内容                          | 包大小         |
| ---- | ----------------------------- | -------------- |
| 1998 | 基本媒体行                    | 200-400 bytes  |
| 2002 | 编码协商，rtpmap              | 500-1000 bytes |
| 2010 | ICE/DTLS                      | 1-2 kb         |
| 2015 | WebRTC, Simulcast, Bound, MID | 2-3kb          |
|      | 在线会议，SFU                 | 3-5 kb         |

可以想象，随着媒体能力的增强，UDP包的SIP信令中的分片几乎成为必然，所以，是否可以考虑有限使用TCP/TLS来传输信令呢？

# 2. 使用 Envoy 代理 TLS 流量

Envoy 是一个非常强大的应用层代理，可以用来作为 OpenSIPS SIPS TLS 代理。 我还记得在使用 OpenSIPS 2.x 的时候，用 OpenSIPS 处理 TLS 流量的时候，遇到过很多的 bug, 都是 opensips 和 openssl 的兼容性问题。

使用 Envoy 作为 OpenSIPS 的 TLS 代理，可以解决很多兼容性问题， 也能让 OpenSIPS 专注于 SIP 协议的处理，而不是 TLS 流量。

除此以外，TLS证书放到Envoy，可以集中管理证书。

[OpenSIPS_Summit_2025_Adam_Overbeeke_Solution_for_TLS_Networking](./OpenSIPS_Summit_2025_Adam_Overbeeke_Solution_for_TLS_Networking.pdf)

# 3. 使用OpenSIPS做WebRTC业务 

如果你主要用jssip, 值得看看别人的架构，还有opensips脚本。

[OpenSIPS_Summit_2025_Conrad_de_Wet_WebRTC_and_the_last_mile](./OpenSIPS_Summit_2025_Conrad_de_Wet_WebRTC_and_the_last_mile.pdf)

# 4. 使用 OpenSIPS 作为 ingress Controller 

架构图值得学习

[OpenSIPS_Summit_2025_Sagar_Malam_OpenSIPs_as_SIP_Ingress_Controller](./OpenSIPS_Summit_2025_Sagar_Malam_OpenSIPs_as_SIP_Ingress_Controller.pdf)


# 5. OpenSIPS 性能优化

主要分为三个部份

1. 数据缓存
2. 异步IO交互
3. 使用新的内存分配器

[OpenSIPS_Summit_2025_Vlad_Paiu_Optimizing_OpenSIPS_performace](./OpenSIPS_Summit_2025_Vlad_Paiu_Optimizing_OpenSIPS_performace.pdf)