---
title: "30秒自动挂断"
date: "2020-07-08 18:47:06"
draft: false
---
在通话接近30秒时，呼叫自动挂断。

有很大的可能和丢失了ACK有关。这个需要用sngrep去抓包看SIP时序图来确定是否是ACK丢失。

丢失ACK的原因很大可能是NAT没有处理好，或者是网络协议不匹配等等。

