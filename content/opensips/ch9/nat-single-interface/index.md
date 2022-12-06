---
title: "NAT场景下的信令处理 - 单网卡"
date: "2022-06-10 20:27:09"
draft: false
---
```
              OPS
<<<----------------------------- ingress
内网           | 公网
              ｜
              |
192.168.2.11  | 1.2.3.4
INNER_IP      | OUTER_IP
              |
              |
------------------------------>>> egress
```

常见共有云的提供的云服务器，一般都有一个内网地址如192.16.2.11和一个公网地址如1.2.3.4。 内网地址是配置在网卡上的；公网地址则只是一个映射，并未在网卡上配置。

我们称从公网到内网的方向为ingress，从内网到公网的方向为egress。

对于内网来说OpenSIPS的广播地址应该是INNER_IP,  所以对ingress方向的SIP请求，Via应该是INNER_IP。<br />对于公网来说OpenSIPS的广播地址应该是OUT_IP,  随意对于egress方向的SIP请求，Via应该是OUTER_IP。

我们模拟一下，假如设置了错误的Via的地址会怎样呢？

例如从公网到内网的一个INVITE,  如果Via头加上的是OUTER_IP， 那么这个请求的响应也会被送到OPS的公网地址。但是由于网络策略和防火墙等原因，这个来自内网的响应很可能无法被送到OPS的公网地址。

一般情况下，我们可以使用listen的as参数来设置对外的广告地址。

```
listen = udp:192.168.2.11:5060 as 1.2.3.4:5060
```

这样的情况下，从内网发送到公网请求，携带的Via就被被设置成1.2.3.4。

但是也不是as设置的广告地址一定正确。这时候我们就可以用OpenSIPS提供的核心函数set_advertised_address或者set_advertised_port()来在脚本里自定义对外地址。

例如：

```
if (请求来自外网) {
    set_advertised_address("192.168.2.11");
} else {
    set_advertised_address("1.2.3.4");
}
```

