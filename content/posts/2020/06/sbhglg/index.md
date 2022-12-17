---
title: "[未完成] WebSocket调研"
date: "2020-06-24 11:09:02"
draft: false
---

# 调研目的
- 在异常情况下，网络断开对WebSocket的影响


# 测试代码

- 测试代码没有心跳机制
- 心跳机制并不包含在WebSocket协议内部
```bash
var ws = new WebSocket('wss://echo.websocket.org/')

ws.onopen =function(e){

    console.log('onopen')
}

ws.onerror = function (e) {
  console.log('onerror: ' + e.code)
  console.log(e)
}

ws.onclose = function (e) {
  console.log('onclose: ' + e.code)
  console.log(e)
}
```


# 场景1: 断网后，是否会立即触发onerror, 或者onclose事件？

**答案**：不会立即触发

测试代码中没有心跳机制，断网后，并不会立即触发onerror或者onclose的回调函数。

个人测试的情况

| 及其 | 测试场景 |
| --- | --- |
| Macbook pro chrome 83.0.4103.106 | 每隔10秒发送一次消息的情况下，40秒后出发onclose事件 |
| Macbook pro chrome 83.0.4103.106 | 一直不发送消息，一直就不回出发onclose事件 |
| Macbook pro chrome 83.0.4103.106 | 发出一个消息后？ |



# 场景2: 断网后，使用send()发送数据，回触发事件吗？



# 为什么无法准确拿到断开原因？

WebSocket关闭事件中有三个属性

- code 断开原因码
- reason 具体原因
- wasClean 是否是正常断开

官方文档上，code字段有很多个值。但是大多数情况下，要么拿到的值是undefined, 要么是1006，基本上没有其他情况。

这并不是浏览器的bug,  这是浏览器故意这样做的。在w3c的官方文档上给出的原因其实是处于安全的考虑。

试想一下，如果把断开原因给出的非常具体。那么一个恶意的js脚本就有可能做端口扫描或则恶意的注入。

> User agents must not convey any failure information to scripts in a way that would allow a script to distinguish the following situations:
> 
> A server whose host name could not be resolved.

> A server to which packets could not successfully be routed.

> A server that refused the connection on the specified port.

> A server that failed to correctly perform a TLS handshake (e.g., the server certificate can't be verified).

> A server that did not complete the opening handshake (e.g. because it was not a WebSocket server).

> A WebSocket server that sent a correct opening handshake, but that specified options that caused the client to drop the connection (e.g. the server specified a subprotocol that the client did not offer).

> A WebSocket server that abruptly closed the connection after successfully completing the opening handshake.

> In all of these cases, the the WebSocket connection close code would be 1006, as required by the WebSocket Protocol specification. [WSP]

> 

> Allowing a script to distinguish these cases would allow a script to probe the user's local network in preparation for an attack.  [https://www.w3.org/TR/websockets/%23concept-websocket-close-fail](https://www.w3.org/TR/websockets/%23concept-websocket-close-fail)




