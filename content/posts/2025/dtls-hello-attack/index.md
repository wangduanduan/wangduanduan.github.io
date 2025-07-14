---
title: "SIP安全 - DTLS client Hello 攻击白皮书"
date: "2025-07-14 23:13:23"
draft: false
type: posts
tags:
- SIP
- SIP攻击
- SIP安全
categories:
- all
---

# TL;DR
- 攻击者伪造DTLS ClientHello消息，在SIP服务器和客户端之间建立一个非预期的连接。导致正常链接被阻断。

# 影响软件
- FreeSWITCH
- RTPengine
- asterisk
- FreePBX

# 漏洞白皮书

[webrtc-hello-race-conditions-paper](./webrtc-hello-race-conditions-paper.pdf)

# 表现
- 应答后呼叫无声

# 参考
- https://github.com/EnableSecurity/advisories/tree/master/ES2023-03-rtpengine-dtls-hello-race
- https://github.com/EnableSecurity/advisories/tree/master/ES2023-02-freeswitch-dtls-hello-race
- https://github.com/EnableSecurity/advisories/tree/master/ES2023-03-rtpengine-dtls-hello-race