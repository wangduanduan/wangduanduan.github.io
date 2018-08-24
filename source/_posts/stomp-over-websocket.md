---
title: 在实践中我遇到stompjs, websocket和nginx的问题与总结
date: 2018-03-20 22:09:34
tags:
- stompjs
- websocket
---

# 1. AWS EC2 不支持WebSocket

[直达解决方案 英文版](https://www.menubar.io/websockets-aws-elasticbeanstalk-ec2/)

简单说一下思路：WebSocket底层基于TCP协议的，如果你的服务器基于HTTP协议暴露80端口，那WebSocket肯定无法连接。`你只要将HTTP协议修改成TCP协议就可以了。`

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180320223231_T2gHyb_Screenshot.jpeg)

然后是安全组的配置：

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180320223255_pGGCWF_Screenshot.jpeg)

同样如果使用了NGINX作为反向代理，那么NGINX也需要做配置的。

```
// https://gist.githubusercontent.com/unshift/324be6a8dc9e880d4d670de0dc97a8ce/raw/29507ed6b3c9394ecd7842f9d3228827cffd1c58/elasticbeanstalk_websockets

files:
    "/etc/nginx/conf.d/01_websockets.conf" :
        mode: "000644"
        owner: root
        group: root
        content : |
            upstream nodejs {
                server 127.0.0.1:8081;
                keepalive 256;
            }

            server {
                listen 8080;

                location / {
                    proxy_pass  http://nodejs;
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
                    proxy_http_version 1.1;
                    proxy_set_header        Host            $host;
                    proxy_set_header        X-Real-IP       $remote_addr;
                    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                }
            }

    "/opt/elasticbeanstalk/hooks/appdeploy/enact/41_remove_eb_nginx_confg.sh":
        mode: "000755"
        owner: root
        group: root
        content : |
            mv /etc/nginx/conf.d/00_elastic_beanstalk_proxy.conf /etc/nginx/conf.d/00_elastic_beanstalk_proxy.conf.old
```

# 2. NGINX做反向代理是需要注意的问题

如果排除所有问题后，那剩下的问题可以考虑出在反向代理上，一下有几点是可以考虑的。

- HTTP的版本问题: http有三个版本，http 1.0, 1.1, 2.0, 现在主流的浏览器都是使用http 1.1版本，为了保证更好的兼容性，最好转发时不要修改协议的版本号

- NGINX具有路径重写功能，如果你使用了该功能，就要考虑问题可能出在这里，因为NGINX在路径重写时，需要对路径进行编解码，有可能在解码之后，没有编码就发送给后端的服务器，导致后端服务器无法对URL进行解码。


# 3. IE8 IE9 有没有简单方便支持WebSocket的方案

目前测试下来，最简单方案是基于flash的。参考：https://github.com/gimite/web-socket-js, 

注意该方案需要在WebSocket服务上的843端口, 提供[socket_policy_files](https://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html), 也可以参考：[A PolyFill for WebSockets](http://old.briangonzalez.org/posts/websockets-polyfill)

网上也有教程是使用socket.io基于ajax长轮训的方案，如果服务端已经确定的情况下，一般是不会轻易改动服务端代码的。而且ajax长轮训也是有延迟，和disconnect时，无法回调的问题。


# 4. stompjs connected后，没有调用connect_callBack
该问题主要是使用web-socket-js，在ie8,ie9上出现的

该问题还没有分析出原因，但是看了stompjs的源码不是太多，明天用源码调试看看原因。

问题已经找到，请参考：https://github.com/wangduanduan/stomp-websocket#about-ie8-ie9-use-websocket


# 5. 参考文献
- [STOMP Over WebSocket](http://jmesnil.net/stomp-websocket/doc/)
- [STOMP Protocol Specification, Version 1.1](http://stomp.github.io/stomp-specification-1.1.html)
- [Stomp Over Websocket文档](https://segmentfault.com/a/1190000006617344), 