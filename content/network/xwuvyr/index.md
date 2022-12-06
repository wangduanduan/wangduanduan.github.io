---
title: "2 链路层"
date: "2019-11-28 13:35:34"
draft: false
---


# 最大传输单元MTU
以太网和802.3对数据帧的长度有个限制，其最大长度分别是1500和1942。链路层的这个特性称作MTU,  最大传输单元。不同类型的网络大多数都有一个限制。

如果IP层的数据报的长度比链路层的MTU大，那么IP层就需要分片，每一片的长度要小于MTU。

使用netstat -in可以打印出网络接口的MTU

```makefile
➜  ~ netstat -in
Kernel Interface table
Iface       MTU Met    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth2       1500   0 1078767768   2264    689      0 1297577913      0      0      0 BMRU
lo        16436   0   734474      0      0      0   734474      0      0      0 LRU
```


# 路径MTU

信息经过多个网络时，不同网络可能会有不同的MTU，而其中最小的一个MTU, 称为路径MTU。

