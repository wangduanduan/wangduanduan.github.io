---
title: Express代理中间件问题与解决方案
date: 2018-09-30 09:41:44
tags:
- express
- proxy
- http-proxy-middleware
- node-http-proxy
---

# 前后端分离应用的架构

在前后端分离架构中，为了避免跨域以及暴露内部服务地址。一般来说，我会在Express这层中加入一个反向代理。

所有向后端服务访问的请求，都通过代理转发到内部的各个服务。

![](http://on-img.com/chart_image/5ac48a5fe4b00dc8a02d30f4.png)

这个反向代理服务器，做起来很简单。用[http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)这个模块，几行代码就可以搞定。

```
// app.js
Object.keys(proxyTable).forEach(function (context) {
  app.use(proxyMiddleware(context, proxyTable[context]))
})
```

http-proxy-middleware实际上是对于[node-http-proxy](https://github.com/nodejitsu/node-http-proxy)的更加简便的封装。node-http-proxy是http-proxy-middleware的底层包，如果node-http-proxy有问题，那么这个问题就会影响到http-proxy-middleware这个包。

# 最近的bug

http-proxy-middleware最近有个问题，请求体在被代理转发前，如果请求体被解析了。那么后端服务将会收不到请求结束的消息，从浏览器的网络面板可以看出，一个请求一直在pending状态。

[Cannot proxy after parsing body #299](https://github.com/chimurai/http-proxy-middleware/issues/299), 实际上这个问题在node-http-proxy也被提出过，而且处于open状态。[POST fails/hangs examples to restream also not working #1279](https://github.com/nodejitsu/node-http-proxy/issues/1279)

目前这个bug还是处于open状态，但是还是有解决方案的。就是`将请求体解析的中间件挂载在代理之后`。

下面的代码，express.json()会对json格式的请求体进行解析。方案1在代理前就进行body解析，所有格式是json的请求体都会被解析。

但是有些走代理的请求，如果我们并不关心请求体的内容是什么，实际上我们可以不解析那些走代理的请求。所以，可以先挂载代理中间件，然后挂载请求体解析中间件，最后挂载内部的一些接口服务。

```
// 方案1 bad
app.use(express.json())
Object.keys(proxyTable).forEach(function (context) {
  app.use(proxyMiddleware(context, proxyTable[context]))
})
app.use('/api', (req, res, next)=> {

})

// 方案2 good
Object.keys(proxyTable).forEach(function (context) {
  app.use(proxyMiddleware(context, proxyTable[context]))
})
app.use(express.json())
app.use('/api', (req, res, next)=> {

})
```

# 总结

经过这个问题，我对Express中间件的挂载顺序有了更加深刻的认识。

同时，在使用第三方包的过程中，如果该包bug，那么也需要自行找出合适的解决方案。而这个能力，往往就是高手与新手的区别。