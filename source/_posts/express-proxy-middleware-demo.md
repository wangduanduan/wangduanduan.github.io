---
title: Express 代理中间件的写法
date: 2018-02-18 10:43:05
tags:
- proxy
- http
- Express
---

# 配置文件写法

```
// filename: config/default.js
// 开发环境配置文件
module.exports = {
  'ENV': 'dev',
  'PORT': '8088',

  'maxAge': 10,
  proxyTable: {
    // 这里是http代理
    // 含有路径重写功能
    '/p/olap': {
      target: 'http://192.168.40.231:30092',
      pathRewrite: {
        '^/p/olap': '/olap'
      }
    },
    // 这里是http代理
    // 含有路径重写功能
    '/p/qc': {
      target: 'http://192.168.40.231:30088',
      pathRewrite: {
        '^/p/qc': '/qc'
      }
    },
    // 这是WebSocket代理
    '/mvc/stomp': {
      target: 'http://192.168.40.231:30412',
      changeOrigin: true,
      ws: true,
      logLevel: 'debug',
      onError: function (err, req, res) {
        console.log('Something went wrong. And we are reporting a custom error message.')
        console.log(err)

        res.writeHead(500, {
          'Content-Type': 'text/plain'
        })
        res.end('Something went wrong. And we are reporting a custom error message.')
      }
    }
  }
}
```

# app.js写法

```
var express = require('express')
var compression = require('compression')
var path = require('path')

// config会根据NODE_ENV环境变量自动去读取config目录下的文件，默认读取的default.js文件
// 你可以在config目录下设置production.js, test.js等配置文件
var config = require('config')
var proxyMiddleware = require('http-proxy-middleware')

// 这里可以获取到配置文件的proxyTable
var proxyTable = config.get('proxyTable')

...

var app = express()
...

// 这里是要点
// 遍历proxyTable，将配置文件中的路径挂载到app上
Object.keys(proxyTable).forEach(function (context) {
  app.use(proxyMiddleware(context, proxyTable[context]))
})

...

module.exports = app

```
