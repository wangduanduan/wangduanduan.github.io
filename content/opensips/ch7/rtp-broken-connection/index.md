---
title: "奥科网关 Rtp Broken Connection"
date: "2022-10-29 10:11:59"
draft: false
---

通话10多秒后，fs对两个call leg发送bye消息。

Bye消息给的原因是  Reason: Q.850 ;cause=31 ;text=”local, RTP Broken Connection”

在通话的前10多秒，SIP信令正常，双方也能听到对方的声音。

首先排查了下fs日志，没发现什么异常。然后根据这个报错内容，在网上搜了下。 

发现了这篇文章 https://www.wavecoreit.com/blog/serverconfig/call-drop-transfer-rtp-broken-connection/

这篇文章给出的解决办法是通过配置了奥科AudioCodes网关来解决的。

然后咨询了下客户，证实他们用的也是奥科网关。所以就参考教程，配制了一下。

主要是在两个地方进行配置

1.
Click Setup -> Signaling&Media -> Expand Coders & Profiles -> Click IP Profiles -> Edityour SFB Profile -> Broken Connection Mode-> Select Ignore -> Click Apply

2.
Expand SIP Definitions -> Click SIP Definitions General Settings -> Broken Connection Mode -> Select Ignore -> Click Apply -> Click Save

这两个地方，都是配置Broken Connection Mode，选择ignore来设置的。

关于RTP的connection mode，有时间再研究下。