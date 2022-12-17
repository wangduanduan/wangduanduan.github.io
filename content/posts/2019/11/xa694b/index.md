---
title: "打印易于提取关键词的日志"
date: "2019-11-01 09:30:37"
draft: false
---
下面的日志是打印出socket.io断开的信息

```javascript
// bad
logger.info(`socket.io ${socket.handshake.query.agentId} disconnect. reason: ${reason} ${socket.id}`)
```

但是这条日志不利于关键词搜索，如果搜disconnect，那么可能很多地方都有这个关键词。


```javascript
// good
logger.info(`socket.io disconnect ${socket.handshake.query.agentId} reason: ${reason} ${socket.id}`)
```


```javascript
// bad
logger.info(`socket.io ${socket.handshake.query.agentId} disconnect. reason: ${reason} ${socket.id}`)
```


总结经验

- **多个关键词位置要靠前**
- **多个关键词要集中**
- **日志日志要标记来自特殊的用于，比如说，来自**

