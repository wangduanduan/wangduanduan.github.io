---
title: "DNS域名解析对MicroSIP注册的影响分析"
date: "2025-04-30 17:36:58"
draft: false
type: posts
tags:
- all
categories:
- all
---

# microSIP DNS域名解析影响分析

MicroSIP是一款流行的windows VoIP客户端，它允许用户通过互联网进行语音和视频通话。在使用MicroSIP时，DNS域名解析是确保正确连接到服务器的重要步骤之一。

DNS域名解析是将人类可读的域名（如www.example.com）转换为机器可读的IP地址的过程。这个过程通常由用户的网络服务提供商(ISP)或本地计算机上的DNS缓存完成。

域名解析可以将一个域名解析为多个IP地址，例如：[ip1, ip2, ip3], 但是每次解析返回的顺序往往是不确定的，这取决于DNS服务器的配置和负载均衡策略。

例如第一次解析的结果可能是[ip1, ip2, ip3]，而第二次解析的结果可能是[ip2, ip3, ip1]。

MicroSIP客户端在注册时，会尝试连接到这些IP地址中的第一个。

- 当分机使用TCP方式注册时，如果其第一个IP地址无法连接，它会继续尝试下一个IP地址，直到成功或所有IP地址都失败为止
- 如果分机使用UDP方式注册，它只会用第一个IP地址尝试注册，如果失败，还是继续尝试第一个IP。 这种行为似乎有点傻，为什么一直要尝试第一个IP地址，而不是尝试下一个呢？ MicroSIP底层用了pjsip库，而pjsip只有在用tcp/tls注册时， 才会自动尝试下一个IP。pjsip官网也给出了具体的解决方案，就是应用层主动调用 pjsua_acc_modify() 函数，手动修改账号配置，然后重新注册。 但是microSIP并没有这么做，而是直接用一个固定的IP地址去尝试注册。

> Our DNS SRV failover support is only limited to TCP (or TLS) connect failure, which in this case pjsip will automatically retries the next server.
> https://docs.pjsip.org/en/latest/specific-guides/sip/dns_failover.html

所以，总体上说。在使用域名注册的情况下，当前的注册和上一次的注册可能发往不同的SIP服务器。

考虑如下场景：
```
# t1 dns解析结果 ip1, ip2, ip3
REGISTER sip:ip1:5060 SIP/2.0
200 Ok

# t2 dns解析结果 ip3, ip1, ip2
REGISTER sip:ip3:5060 SIP/2.0
200 ok
```

一般分机都在内网环境，出口的公网IP是不变的，但是t1和t2的注册由于目标IP不同，所以出口的NAT映射的端口也是不同的。

| 时间 | 分机内网IP | 分机内网端口 | 分机公网IP | 分机公网端口 | 注册目标IP  | 公网端口号 |
| ---- | ------- | ---------- | -------- | ---------- | -------- | -------- |
| t1 | 192.168.1.10 | 5060 | 203.0.113.195  | `13450`       | ip1    | 5060 |
| t2 | 192.168.1.10 | 5060 | 203.0.113.195  | `13000`       | ip3    | 5060 |

如果t2的的注册是成功的，那么分机最新的出口端口是13000，如果呼叫依然是送到203.0.113.195:13450, 很可能NAT是无法转发过来的。


# IP重写对MicroSIP注册的影响

MicroSIP的账户设置上，可以开启或者关闭IP重写功能。

> Allow IP rewrite
> Can be used to solve call flow and media delivery issues when you don't have dedicated public IP address. If enabled, MicroSIP will keep track of the public IP address from the response of REGISTER request. Public IP will be used in later SIP queries in Via, Contact and SDP.
> See also: Public address, STUN.

开启IP重写后，MicroSIP会将如果发现自己的出口IP:PORT发生改变， 那么会先使用ip1做一次取消注册， 取消注册后，再使用ip3发起新的注册。

那么问题来了， microSIP是怎么知道自己的出口IP:PORT发生了改变呢？

```
# 分机注册
REGITSTER sip:ip1:5060 SIP/2.0
Via: SIP/2.0/UDP 192.168.1.8:54644;rport;branch=z9hG4bKPjE9fHx.Zlv3t3dl3hMt-uYlNAv423a-uX

# 收到200 ok
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.1.8:54644;branch=z9hG4bKPjE9fHx.Zlv3t3dl3hMt-uYlNAv423a-uX;received=1.2.3.4;rport=38857
```

可以看到，在200 ok中，包含了received=1.2.3.4;rport=38857。 received就是分机的出口IP，rport是分机出口的端口。

MicroSIP会将这个IP和端口缓存起来，下一次注册时，会和上一次的出口IP和端口做对比，如果不同，则会先取消注册，再重新发起新的注册。

如果不希望MicroSIP再发现出口IP和端口变化后，不主动取消注册，可以关闭IP重写功能。

# 参考
- https://www.microsip.org/
- https://docs.pjsip.org/en/latest/specific-guides/sip/dns_failover.html
- https://docs.pjsip.org/en/latest/specific-guides/network_nat/ip_change.html
- https://www.ietf.org/rfc/rfc3263.txt