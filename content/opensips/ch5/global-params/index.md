---
title: "全局参数配置"
date: "2019-06-16 11:03:12"
draft: false
---
本全局参数基于opensips 2.4介绍。

opensips的全局参数有很多，具体可以参考。[https://www.opensips.org/Documentation/Script-CoreParameters-2-4#toc37](https://www.opensips.org/Documentation/Script-CoreParameters-2-4#toc37)

下面介绍几个常用的参数

```bash
log_level=3
log_facility=LOG_LOCAL0
listen=172.16.200.228:4400
```


# log_level
log_level的值配置的越大，输出的日志越详细。log_level的值的范围是[-3, 4]

- -3 - Alert level
- -2 - Critical level
- -1 - Error level
- 1 - Warning level
- 2 - Notice level
- 3 - Info level
- 4 - Debug level


# log_facility
log_facility用来设置独立的opensips日志文件，参考[https://www.yuque.com/wangdd/opensips/log](https://www.yuque.com/wangdd/opensips/log)


# listen
listen用来设置opensips监听的端口和协议, 由于opensips底层支持的协议很多，所以你可以监听很多不同协议。

**注意一点**：不要监听本地环回地址127.0.0.1, 而要监听etho0的ip地址。

```bash
listen:udp:172.16.200.228:5060
listen:tcp:172.16.200.228:5061
listen:ws:172.16.200.228:5062
```


