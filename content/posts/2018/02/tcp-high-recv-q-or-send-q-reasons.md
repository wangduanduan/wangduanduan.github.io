---
title: 哑代理 - TCP链接高Recv-Q，内存泄露的罪魁祸首
date: 2018-02-08 21:58:31
tags:
- tcp
- Recv-Q
- 哑代理
- 内存泄露
---

# 1. 问题现象

使用`netstat -ntp`命令时发现，Recv-Q 1692012 异常偏高（正常情况下，该值应该是0），导致应用占用过多的内存。

```
tcp 1692012 0 172.17.72.4:48444 10.254.149.149:58080 ESTABLISHED 27/node
```

问题原因：`代理的转发时，没有删除逐跳首部`

# 2. 什么是Hop-by-hop 逐跳首部？
http首部可以分为两种
- 端到端首部 End-to-end: 端到端首部代理在转发时必须携带的
- 逐跳首部 Hop-by-hop: 逐跳首部只对单次转发有效，代理在转发时，必须删除这些首部

逐跳首部有以下几个, `这些首部在代理进行转发前必须删除`
- Connetion
- Keep-Alive
- Proxy-Authenticate
- Proxy-Authortization
- Trailer
- TE
- Transfer-Encodeing
- Upgrade


# 3. 什么是哑代理？

很多老的或简单的代理都是盲中继(blind relay),它们只是将字节从一个连接转发到另一个连接中去,不对Connection首部进行特殊的处理。

![](https://wdd.js.org/img/images/20180222111857_Wi3Sye_Screenshot.jpeg)

- (1)在图4-15a中 Web客户端向代理发送了一条报文,其中包含了Connection:Keep-Alive首部,如果可能的话请求建立一条keep-alive连接。客户端等待响应,以确定对方是否认可它对keep-alive信道的请求。

- (2)  哑代理收到了这条HTTP请求,但它并不理解 Connection首部(只是将其作为一个扩展首部对待)。代理不知道keep-alive是什么意思,因此只是沿着转发链路将报文一字不漏地发送给服务器(图4-15b)。但Connection首部是个逐跳首部,只适用于单条传输链路,不应该沿着传输链路向下传输。接下来,就要发生一些很糟糕的事情了。

- (3)  在图4-15b中,经过中继的HTTP请求抵达了Web服务器。当Web服务器收到经过代理转发的Connection: Keep-Alive首部时,会误以为代理(对服务器来说,这个代理看起来就和所有其他客户端一样)希望进行keep-alive对话!对Web服务器来说这没什么问题——它同意进行keep-alive对话,并在图4-15c中回送了一个Connection: Keep-Alive响应首部。所以,此时W eb服务器认为它在与代理进行keep-alive对话,会遵循keep-alive的规则。但代理却对keep-alive一无所知。不妙。

- (4)  在图4-15d中,哑代理将Web服务器的响应报文回送给客户端,并将来自Web服务器的Connection: Keep-Alive首部一起传送过去。客户端看到这个首部,就会认为代理同意进行keep-alive对话。所以,此时客户端和服务器都认为它们在进行keep-alive对话,但与它们进行对话的代理却对keep-alive一无所知。

- (5)  由于代理对keep-alive一无所知,所以会将收到的所有数据都回送给客户端,然后等待源端服务器关闭连接。但源端服务器会认为代理已经显式地请求它将连接保持在打开状态了,所以不会去关闭连接。这样,代理就会挂在那里等待连接的关闭。

- (6)  客户端在图4-15d中收到了回送的响应报文时,会立即转向下一条请求,在keep-alive连接上向代理发送另一条请求(参见图4-15e)。而代理并不认为同一条连接上会有其他请求到来,请求被忽略,浏览器就在这里转圈,不会有任何进展了。

- (7)  这种错误的通信方式会使浏览器一直处于挂起状态,直到客户端或服务器将连接超时,并将其关闭为止。 --《HTTP权威指南》


这是HTTP权威指南中，关于HTTP哑代理的描述。这里这里说了哑代理会造成的一个问题。
- 这种错误的通信方式会使浏览器一直处于挂起状态,直到客户端或服务器将连接超时,并将其关闭为止。

实际上，我认为哑代理还是造成以下问题的原因
- TCP链接高Recv-Q
- tcp链接不断开，导致服务器内存过高，内存泄露
- 节点iowait高

在我们自己的代理的代码中，我有发现，在代理进行转发时，只删除了headers.host, 并没有删除headers.Connection等逐跳首部的字段

```
delete req.headers.host

var option = {
  url: url,
  headers: req.headers
}

var proxy = request(option)
req.pipe(proxy)
proxy.pipe(res)
```

# 4. 解决方案

解决方案有两个， 我推荐使用第二个方案，具体方法参考[Express 代理中间件的写法](https://wdd.js.org/express-proxy-middleware-demo.html)

1. 更改自己的原有代码
2. 使用成熟的开源产品

# 5. 参考文献
- [What is the reason for a high Recv-Q of a TCP connection?](https://stackoverflow.com/questions/34108513/what-is-the-reason-for-a-high-recv-q-of-a-tcp-connection)
- [TCP buffers keep filling up (Recv-Q full): named unresponsive](https://unix.stackexchange.com/questions/100913/tcp-buffers-keep-filling-up-recv-q-full-named-unresponsive)
- [linux探秘:netstat中Recv-Q 深究](http://blog.51cto.com/191274/1592101)
- [深入剖析 Socket——TCP 通信中由于底层队列填满而造成的死锁问题](http://blog.51cto.com/191274/1592101)
- [netstat Recv-Q和Send-Q](http://blog.csdn.net/sjin_1314/article/details/9853163)
- [深入剖析 Socket——数据传输的底层实现](http://wiki.jikexueyuan.com/project/java-socket/socket-advanced.html)
- [Use of Recv-Q and Send-Q](https://stackoverflow.com/questions/36466744/use-of-recv-q-and-send-q)
- 【美】David Gourley / Brian Totty  [HTTP权威指南](https://book.douban.com/subject/10746113/) 
- 【日】上野宣 于均良 [图解HTTP](https://book.douban.com/subject/25863515/)