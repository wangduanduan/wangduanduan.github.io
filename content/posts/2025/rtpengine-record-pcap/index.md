---
title: "RTPEngine 录制 PCAP 文件"
date: "2025-07-15 19:26:06"
draft: false
type: posts
tags:
  - rtpengine
  - 录音
categories:
  - rtpengine
---

# 为什要用 RTPEngine 来录制 PCAP 文件？

一般我们用 Freeswitch 来作为录音服务器， 但是某些场景，例如备份录音，需要在不同节点进行录音。

如果直接录制成 wav 文件，那么比较占用资源，而且备份录音用的几率也是比较小的。

因此录制成 PCAP 文件，可以节省资源，后期 pcap 转语音也能比较容易的实现。

# 实现步骤

1. 配置rtpengine启动参数

```
--pcaps-dir=/var/log/records --record-method=pcap --recording-format=eht
```

2. 在opensips在做SDP Offer

```
rtpengine_offer("record-call=yes");
```

3. 录音文件位置

录音文件在`/var/log/records`目录下，文件名是呼叫的sip Call-ID-16hex随机数.pcap

```sh
call1-1234567890abcdef.pcap
call2-1234567890abcdef.pcap
```

4. 录音文件内容

录音文件用wireshark分析，可以听到主被叫双方的声音。


5. 其他

除了录音文件，一些录音的元数据，例如SDP之类的信息，会被记录到录音的目录下。