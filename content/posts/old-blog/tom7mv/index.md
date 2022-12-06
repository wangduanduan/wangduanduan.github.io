---
title: "使用nginx为udp服务负载均衡"
date: "2021-07-17 19:28:18"
draft: false
---

# 对nginx的最低版本要求是？
- 1.9.13
> The ngx_stream_proxy_module module (1.9.0) allows proxying data streams over TCP, UDP (1.9.13), and UNIX-domain sockets.



# 简单的配置是什么样？

例如监听本地53的udp端口，然后转发到192.168.136.130和192.168.136.131的53端口

注意事项

1. stream是顶层的配置，不能包含在http模块里面
2. proxy_responses很重要，如果你的udp服务只接受udp消息，并不发送udp消息，那么务必将proxy_responses的值设置为0

```makefile
stream {
    upstream dns_upstreams {
        server 192.168.136.130:53;
        server 192.168.136.131:53;
    }

    server {
        listen 53 udp;
        proxy_pass dns_upstreams;
        proxy_timeout 1s;
        proxy_responses 0;
        error_log logs/dns.log;
    }
}
```

| Syntax: | **proxy_responses** _number_;

 |
| --- | --- |
| Default: | — |
| Context: | stream, server

 |

> This directive appeared in version 1.9.13.

> Sets the number of datagrams expected from the proxied server in response to a client datagram if the [UDP](http://nginx.org/en/docs/stream/ngx_stream_core_module.html#udp) protocol is used. The number serves as a hint for session termination. By default, the number of datagrams is not limited.
> **If zero value is specified, no response is expected**. However, if a response is received and the session is still not finished, the response will be handled.



# 我能用HAProxy吗？

答： HAProxy不支持udp Proxy，你不能用

> HAProxy is a free, **_very_** fast and reliable solution offering [high availability](http://en.wikipedia.org/wiki/High_availability), [load balancing](http://en.wikipedia.org/wiki/Load_balancer), and proxying for TCP and HTTP-based applications



# 参考

- [http://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_responses](http://nginx.org/en/docs/stream/ngx_stream_proxy_module.html#proxy_responses)
- [https://stackoverflow.com/questions/31255780/udp-traffic-with-iperf-for-haproxy](https://stackoverflow.com/questions/31255780/udp-traffic-with-iperf-for-haproxy)

