---
title: "Udp Checksum Offload"
date: 2022-06-30
type: posts
draft: false
---

在服务端抓包，然后在wireshark上分析，发现wireshark提示：udp checksum字段有问题

checksum 0x... incrorect should be 0x.. (maybe caused by udp checksum offload)

以前我从未遇到过udp checksum的问题。所以这次是第一次遇到，所以需要学习一下。
首先udp checksum是什么？

我们看下udp的协议组成的字段，其中就有16位的校验和


校验和一般都是为了检验数据包在传输过程中是否出现变动的。

1. 如果接受端收到的udp消息校验和错误，将会被悄悄的丢弃
2. udp校验和是一个端到端的校验和。端到端意味它不会在中间网络设备上校验。
3. 校验和由发送方负责计算，接收端负责验证。目的是为了发现udp首部和和数据在发送端和接受端之间是否发生了变动
4. udp校验和是可选的功能，但是总是应该被默认启用。
5. 如果发送方设置了udp校验和，则接受方必须验证

发送方负责计算？具体是谁负责计算

计算一般都是CPU的工作，但是有些网卡也是支持checksum offload的。

所谓offload, 是指本来可以由cpu计算的，改变由网卡硬件负责计算。
这样做有很多好处，

1.  可以降低cpu的负载，提高系统的性能
2. 网卡的硬件checksum, 效率更高


# 为什么只有发送方出现udp checksum 错误？

我在接受方和放松方都进行了抓包，一个比较特殊的特征是，只有发送方发现了udp checksum的错误，在接受方，同样的包，udp checksum的值却是正确的。

一句话的解释：tcpdump在接收方抓到的包，本身checksum字段还没有被计算，在后续的步骤，这个包才会被交给NIC, NIC来负责计算。


# 结论
maybe caused by udp checksum offload 这个报错并没有什么问题。

# 参考
● 《tcp/ip 详解》
● https://www.kernel.org/doc/html/latest/networking/checksum-offloads.html
● https://dominikrys.com/posts/disable-udp-checksum-validation/
● https://sokratisg.net/2012/04/01/udp-tcp-checksum-errors-from-tcpdump-nic-hardware-offloading/

