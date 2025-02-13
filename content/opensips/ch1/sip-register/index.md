---
title: "SIP注册调研"
date: "2019-08-19 21:30:52"
draft: false
---


```mermaid
sequenceDiagram
    autonumber
    participant a as 192.168.0.123:55647
    participant b as 1.2.3.4:5060
    participant c as 172.10.10.3:49543

    a->>b: register cseq=1, callId=1
    b-->>a: 401 Unauthorized
    a->>b: register cseq=2, callid=1
    b-->>a: 200
    a->>b: register cseq=3, callId=1
    b-->>a: 401 Unauthorized
    a->>b: register cseq=4, callid=1
    b-->>a: 200
    c->>b: register cseq=5, callid=1
    b-->>c: 401 Unauthorized
    c->>b: register cseq=6, callid=1
    b-->>c: 500 Service Unavailable
    c->>b: register cseq=7, callid=2
    b-->>c: 401 Unauthorized
    c->>b: register cseq=8, callid=2
    b-->>c: 200
    c->>b: register cseq=9, callid=2
    b-->>c: 401 Unauthorized
    c->>b: register cseq=10, callid=2
    b-->>c: 200
    c->>b: register cseq=11, callid=2
    b-->>c: 401 Unauthorized
    c->>b: register cseq=12, callid=2
    b-->>c: 500 Service Unavailable
    a->>b: register cseq=13, callId=3
    b-->>a: 401 Unauthorized
    a->>b: register cseq=14, callid=3
    b-->>a: 200
    a->>b: register cseq=15, callId=3
    b-->>a: 401 Unauthorized
    a->>b: register cseq=16, callid=3
    b-->>a: 200
    a->>b: register cseq=17, callId=3
    b-->>a: 401 Unauthorized
    a->>b: register cseq=18, callid=3
    b-->>a: 200
    a->>b: register cseq=19, callId=3
    b-->>a: 401 Unauthorized
    a->>b: register cseq=20, callid=3
    b-->>a: 200
```

- 服务端设置的过期时间是120s
- 客户端每隔115s注册一次, callid和之前的保持不变
- 当网络变了之后，由于ip地址改变，客户端的在115秒注册，此时服务端还未超时，所以给客户端响应报错500
- 客户端在等了8秒之后，等待服务端超时，然后再次注册，再次注册时，callid改变
- 因为服务端已经超时，所以能够注册成功


![](2022-10-30-20-48-11.png)


需要注意的是，在一个注册周期内，客户端的注册信息包括IP、端口、协议、CallID都不能变，一旦改变了。如果服务端的记录还没有失效，新的注册就会失败。

有的客户会经常反馈，他们的分机总是无辜掉线。经过抓包分析，发现分机每隔1.5分钟注册一次，使用tcp注册的，每次的端口号都会变成不同的值。

然后尝试让分机用udp注册，分机就不再异常掉线了。

一个tcp socket一旦关闭，新的tcp socket必然会被分配不同的端口。但是udp不一样，udp是无连接的。

