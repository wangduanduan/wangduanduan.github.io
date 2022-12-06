---
title: "【必读】深入对外公布地址"
date: "2019-11-04 13:11:30"
draft: false
---
如果你仅仅是本地运行OpenSIPS, 你可以不用管什么对外公布地址。但是如果你的SIP服务器想在公网环境提供服务，则必然要深刻的理解对外公布地址。


在一个集群中，可能有多台SIP服务器，例如如下图的网络架构中

- register 负责注册相关的业务 192.168.1.100(内网)
- uas 负责呼叫相关的业务 192.168.1.101(内网)
- entry 负责接入 192.168.1.102(内网)，1.2.3.4(公网地址)   

一般情况下，register和uas只有内外地址，没有公网地址。而entry既有内网地址，也有公网地址。公网地址一般是由云服务提供商分配的。


![](https://cdn.nlark.com/yuque/__graphviz/a6627f4c47acb6b0870a87628b91cf95.svg#lake_card_v2=eyJ0eXBlIjoiZ3JhcGh2aXoiLCJjb2RlIjoiZ3JhcGgge1xuXHRyYW5rZGlyPVwiTFJcIlxuXHQgc3ViZ3JhcGggY2x1c3Rlcl8yIHtcbiAgICBsYWJlbD1cIuWGhemDqOe9kee7nFwiO1xuICAgIGJnY29sb3I9XCJtaW50Y3JlYW1cIjtcblx0XHRcInJlZ2lzdGVyXCIgLS0gXCJlbnRyeVwiXG5cdCAgXCJ1YXNcIiAtLSBcImVudHJ5XCJcbiAgfVxuXHRcblx0XCJlbnRyeVwiIC0tIFwi5LqS6IGU572RXCJcblx0XCLkupLogZTnvZFcIiAtLSBcIuWIhuaculwiXG59IiwidXJsIjoiaHR0cHM6Ly9jZG4ubmxhcmsuY29tL3l1cXVlL19fZ3JhcGh2aXovYTY2MjdmNGM0N2FjYjZiMDg3MGE4NzYyOGI5MWNmOTUuc3ZnIiwiaWQiOiJHVWZpRiIsImhlaWdodCI6MzQ1LCJjYXJkIjoiZGlhZ3JhbSJ9)

我们希望内部网络register和uas以及entry必须使用内网通信，而entry和互联网使用公网通信。

有时候经常遇到的问题就是某个请求，例如INVITE, uas从内网地址发送到了entry的公网地址上，这时候就可能产生一些列的奇葩问题。


# 如何设置公布地址


## listen as
```
listen = udp:192.168.1.102:5060 as 1.2.3.4:5060
```

在listen 的参数上直接配置公布地址。好处的方便，后续如果调用record_route()或者add_path_received(), OpenSIPS会自动帮你选择对外公布地址。

但是，OpenSIPS选择可能并不是我们想要的。

例如： INVITE请求从内部发送到互联网，这时OpenSIPS能正常设置对外公布地址。但是如果请求从外表进入内部，OpenSIPS可能还是会用公网地址作为对外公布地址。

所以，listen as虽然方便，但不够灵活。


## set_advertised_address() 和 set_advertised_port(int)
set_advertised_address和set_advertised_port属于OpenSIPS和核心函数部分，可以在脚本里根据不同条件，灵活的设置公布地址。

例如:

```
if 请求发生到公网 {
	set_advertised_address("1.2.3.4");
}
```

> ⚠️ 如果你选择用set_advertised_address和set_advertised_port来手动设置，就千万不要用as了。


#### 


# 几个注意点SIP头

- record_route头
- Path头

上面的两个头，在OpenSIPS里可以用下面的函数去设置。设置的时候，务必要主义选择合适的网络地址。否者请求将会不回按照你期望方式发送。

- record_route
- record_route_preset
- add_path
- add_path_received

