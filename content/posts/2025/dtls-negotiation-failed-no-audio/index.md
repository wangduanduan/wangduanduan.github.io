---
title: "DTLS协商失败导致无声问题"
date: "2025-06-24 21:06:11"
draft: false
type: posts
tags:
- all
categories:
- all
---

# 1. 简介

DTLS（Datagram Transport Layer Security，数据报传输层安全协议）是一种为基于数据报的应用（如UDP）提供安全通信的协议。它是TLS（传输层安全协议）的扩展，专门设计用于不可靠的传输协议（如UDP），以实现数据加密、身份认证和消息完整性保护。DTLS常用于VoIP、视频会议、WebRTC等实时通信场景。

DTLS在WebRTC音视频中是强制必须使用的，否则媒体协商阶段就会失败。

使用DTLS后，就算中间人从网络中抓包，抓到了RTP流，在播放RTP流时，里面也全是噪声，无法播放的。

今天要讲的是就是DTLS协商失败导致电话即使接通，也无声的问题。

# 2. 网络结构说明

- UAS: sip server, OpenSIPS + RTPEngine组成
- UAC: WebRTC 分机

```bash
F1. UAS ----> UAC: INVITE (SDP)
F2. UAS <---- UAC: 180
F3. UAS <---- UAC: 200 Ok (SDP)
F4. UAS ----> UAC: ACK
```

从SIP信令上看，被叫应答后，UAS和UAC之间的双向媒体流应该建立起来，但是实际上却无声。

# 3. ICE/STUN/DTLS

- **ICE**: WebRTC中的ICE（Interactive Connectivity Establishment，交互式连接建立）是一种网络协议，用于帮助WebRTC客户端在不同网络环境下建立点对点（P2P）连接。ICE的主要作用是解决NAT穿透和防火墙问题，使两个终端能够找到最佳的通信路径。
- **STUN**: WebRTC中的STUN（Session Traversal Utilities for NAT，NAT会话穿越实用工具）是一种网络协议，主要用于帮助客户端发现自己的公网IP地址和端口。由于很多设备处于NAT（网络地址转换）或防火墙之后，直接通信会遇到障碍，STUN可以让客户端知道外部网络如何访问自己

在分机应答后，并在WebRTC发送本地媒体流前，还需要两个步骤协商完成UAC才会发送语音流

## 3.1 STUN协商

UAC收到来自UAS的SDP, 里面一般有如下内容

```sh
m=audio 54322 UDP/TLS/RTP/SAVPF 111 0 8
a=ice-ufrag:abcd
a=ice-pwd:1234567890abcdef
a=ice-options:trickle
a=fingerprint:sha-256 12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF
a=setup:actpass
a=candidate:1 1 udp 2130706431 1.2.3.4 54322 typ host
```

STUN是一个请求响应模型的协议。UAC将会向`a=candidate`里的1.2.3.4:54322 发送UDP消息

```sh
UAC ----> 1.2.3.4:54322: STUN请求/我的公网出口的IP地址和端口是多少？
UAC <---- 1.2.3.4:54322: STUN响应/你的公网出口地址是5.6.7.8:38292
```

STUN在回话建立前需要正确收到响应，在通话过程中，每隔2-3秒也会自动发送。

STUN请求成功后，才会进行DTLS协商

## 3.2 DLTS协商

SDP交互流程如下

```
// Offer SDP
m=audio 20300 RTP/SAVPF 8 101
a=rtcp:20301
a=rtcp-mux
a=setup:actpass
a=fingerprint:sha-256 xxxxx
a=ice-ufrag:user-s
a=ice-pwd:pw1
a=candidate:c1 1 UDP 1234 1.2.3.4 20030 typ host
a=candidate:c1 2 UDP 1235 1.2.3.4 20031 typ host


// Answer SDP
m=audio 50020 RTP/SAVPF 8 101
a=rtcp:9 IN IP4 0.0.0.0
a=rtcp-mux
a=setup:active
a=fingerprint:sha-256 xxxxxx
a=ice-ufrag:user-c
a=ice-pwd:pw2
a=candidate:c2 1 UDP 3323 192.168.1.100 50020 typ host generation 0 network-id 1 network-cost 10
a=candidate:c2 2 UDP 3323 192.168.1.100 50021 typ host generation 0 network-id 1 network-cost 10
```

整个DLTS协商需要4次交互，具体如下

```bash
alias s = 1.2.3.4:20030 // 从Offer SDP里的a=candidate属性中拿到STUN请求的目标地址
alias c = UAC
F1 c --> s: STUN Req-1 Bind user-s:user-c // 发出请求STUN 请求
F2 c <-- s: STUN Res-1 XOR-MAPPED-ADDRESS: 192.168.1.100:50020 // 收到STUN响应
F3 c --> s: DTLS Client Hello 
F4 c <-- s: DTLS Server hello, Certificate
F5 c --> s: DTLS Certficate, Client Key Exchange
F6 c <-- s: DTLS New Session Ticket
F7 c --- s: RTP // 语音包
```

- F1 - F2: STUN 协商，需要2次信息交互，这一步成功之后才会有DTLS协商。注意这里客户端可能一次性发送两个STUN请求，任意一个收到响应，都会立即做DTLS协商
	- 即使在通话过程中，STUN请求也会每隔 1-2s 周期性的发送
    - 服务器也会自动向客户端发送STUN请求
- F3 - F6: DTLS 协商，需要4次信息交互，DTLS协商成功后，客户端才会向服务端发送加密语音流。如果任意一步出现问题，都会造成无声问题。


