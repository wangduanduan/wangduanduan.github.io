---
title: "负载均衡模块load_balance"
date: "2020-05-19 09:42:10"
draft: false
---
- 负载均衡只能均衡INVITE, 不能均衡REGISTER请求。因为load_blance底层是使用dialog模块去跟踪目标地址的负载情况。
- load_balance方法会改变INVITE的$du,  而不会修改SIP URL
- 呼叫结束的时候，目标地址的负载会自动释放


# 选择逻辑

|  | 网关A | 网关B |
| --- | --- | --- |
| 通道数 | 30 | 60 |
| 正在使用的通道数 | 20 | 55 |
| 空闲通道数 | 10 | 5 |


load_balance是会先选择最大可用资源的目标地址。假如A网关的最大并发呼叫是30， B网关最大并发呼叫是60。在某个时刻，A网关上已经有20和呼叫了, B网关上已经有55个呼叫。 此时load_balance会优先选择网关A。









# 参考

- [https://opensips.org/Documentation/Tutorials-LoadBalancing-1-9](https://opensips.org/Documentation/Tutorials-LoadBalancing-1-9)

