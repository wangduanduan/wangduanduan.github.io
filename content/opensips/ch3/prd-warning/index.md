---
title: "生产环境监控告警"
date: "2021-08-19 20:08:28"
draft: false
---

# 日志监控

务必监控opensips日志，如果其中出现了CRITICAL关键字, 很可能马上opensips就要崩溃。

第一要发出告警信息。<br />第二要有主动的自动重启策略，例如使用systemd启动的话，服务崩溃会会立马被重启。或者用docker或者k8s，这些虚拟化技术，可以让容器崩溃后自动重启。


# 指标监控
opensips有内部的统计模块，可以很方便的通过opensipsctl或者相关的http的mi接口获取到内部的统计数据。

以下给出几个关键的统计指标：

- 'total_size',   全部内存
- 'used_size',   使用的内存
- 'real_used_size',   真是使用的内存
- 'max_used_size',   最大使用的内存
- 'free_size',   空闲内存
- 'fragments',   
- 'active_dialogs',   接通状态的通话
- 'early_dialogs',     振铃状态的通话
- 'inuse_transactions',   正在使用的事务
- 'waiting_udp',   堆积的udp消息
- 'waiting_tcp'     堆积的tcp消息

当然还有很多的一些指标，可以使用：`opensipsctl fifo get_statistics all`来获取。



