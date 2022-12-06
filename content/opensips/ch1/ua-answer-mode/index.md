---
title: "UA应答模式的实现"
date: "2019-09-26 20:37:08"
draft: false
---

# Notify
使用noify消息，通知分机应答，这个notify一般发送在分机回180响应之后


# Answer-mode

- Answer-Mode一般有两个值
   - Auto: UA收到INVITE之后，立即回200OK，没有180的过程
   - Manual: UA收到INVITE之后，等待用户手工点击应答

通常Answer-Mode还会跟着require, 表示某个应答方式如果不被允许，应当回403 Forbidden 作为响应。

```bash
Answer-Mode: Auto;require
```

和Answer-mode头类似的有个SIP头叫做：Priv-Answer-Mode，这个功能和Answer-Mode类似，但是他有个特点。

如果UA设置了免打扰，Priv-Answer-Mode头会无视免打扰这个选项，强制让分机应答，这个头适合用于紧急呼叫。


# 结论
如果要实现分机的自动应答，显然Answer-Mode的应答速度回更快。但是对于依赖180响应的系统，可能要考虑这种没有180相应的情况。

要记住，在SIP消息里，对于UA来说，1xx的响应都是不必须的可以缺少的。

