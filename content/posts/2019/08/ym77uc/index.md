---
title: "【笔记】操作系统：虚拟化 并发 持久化"
date: "2019-08-01 13:20:13"
draft: false
---

# 虚拟化
问题：

1. 操作系统如何虚拟化?
2. 虚拟化有什么好处?

操作系统向下控制硬件，向上提供API给应用程序调用。 

系统的资源是有限的，应用程序都需要资源才能正常运行，所以操作系统也要负责资源的分配和协调。通常计算机有以下的资源。

1. cpu
2. 内存
3. 磁盘
4. 网络

有些资源可以轮流使用，而有些资源只能被独占使用。
