---
title: Express 通过log4js写日志到Logstash(ELK)
date: 2018-07-11 14:59:41
tags:
---
- express
- log4js
- logstash
- kibana
- ELK

# package.json

确认版本, 不谈版本都是耍流氓。

```
  "dependencies": {
    "body-parser": "1.18.3",
    "compression": "1.7.2",
    "cookie-parser": "1.4.3",
    "ejs": "2.6.1",
    "express": "4.16.3",
    "forever": "0.15.3",
    "http-proxy-middleware": "0.18.0",
    "log4js": "2.9.0",
    "log4js-logstash-tcp": "1.0.1",
    "serve-favicon": "2.5.0"
  },
```

# Logstash配置

- 你需要知道logstash服务的IP和端口
- 你需要知道写日志是通过什么协议：TCP，还是UDP

> 在我向logstash写日志之前，已经有同事向Logstash写过日志了。当时只是知道logstash的ip和端口，没有搞清楚协议，所以没有写进去。

# logger

```
// filename: /logs/logger.js

var log4js = require('log4js')

// 获取配置文件中logstash的IP地址和端口
var {logHost, logPort} = require('../config/index.js') 

if (!logHost || !logPort) {
  console.log('ERROR not config logstash_host or logstash_port')
}

log4js.configure({
  appenders: {
    console: { type: 'console' },
    logstash: {
      // 因为我们的logstash暴露的是tcp写日志的端口，所以我用了log4js-logstash-tcp，
      // 这个需要安装 https://github.com/Aigent/log4js-logstash-tcp
      // 如果你的logstash使用UDP的，参考 https://github.com/log4js-node/logstashUDP
      type: 'log4js-logstash-tcp', 
      host: logHost,
      port: parseInt(logPort)
    }
  },
  categories: {
    default: { appenders: ['logstash'], level: 'debug' }
  }
})

const logger = log4js.getLogger('default')
```

# app.js

```
// filename: /app.js
var express = require('express')
var compression = require('compression')
var path = require('path')
var log4js = require('log4js')
var proxyMiddleware = require('http-proxy-middleware')
var cookieParser = require('cookie-parser')

var logger = require('./logs/logger.js') // 这了引用了上面的logger
var {proxyTable, maxAge} = require('./config/index.js')

...
Object.keys(proxyTable).forEach(function (context) {
  if (!proxyTable[context].ws) {
    // 这里我是用的反向代理，当代理响应时，开始写日志
    proxyTable[context].onProxyRes = writeLog
  }
  app.use(proxyMiddleware(context, proxyTable[context]))
})
...

// 主要谢日日志的就是这里
function writeLog (proxyRes, req, res) {
  var baseLog = `${req.method} ${proxyRes.statusCode} ${req.cookies.email} ${req.url}`
  var msgObj = {
    method: req.method,
    statusCode: proxyRes.statusCode,
    url: req.url,
    email: req.cookies.email || '',
    sessionId: req.cookies.sessionId || '',
    instanceId: 'newTm',
    nodeName: 'newTm'
  }

  if (proxyRes.statusCode < 400) {
    logger.info(baseLog, msgObj)
  } else {
    logger.error(baseLog, msgObj)
  }
}
```

在kibana中输入关键词：`nodeName:newTm`
可以搜到如下的记录

```
{
  "_index": "logstash-2018.07.11",
  "_type": "logs",
  "_id": "AWSIGyY0vR6RLdfU8xZj",
  "_score": null,
  "_source": {
    "nodeName": "newTm",
    "method": "GET",
    "level": "INFO",
    "sessionId": "",
    "message": "GET 204 test.cc.com /api/touch?_=1531291286527",
    "url": "/api/touch?_=1531291286527",
    "@timestamp": "2018-07-11T06:53:29.059Z",
    "port": 57250,
    "@version": "1",
    "host": "192.168.2.74",
    "fields": {
      "nodeName": "newTm",
      "method": "GET",
      "level": "INFO",
      "sessionId": "",
      "category": "default",
      "url": "/api/touch?_=1531291286527",
      "email": "test.cc.com",
      "statusCode": 204
    },
    "category": "default",
    "email": "test.cc.com",
    "statusCode": 204
  },
  "fields": {
    "@timestamp": [
      1531292009059
    ]
  },
  "highlight": {
    "nodeName": [
      "@kibana-highlighted-field@newTm@/kibana-highlighted-field@"
    ]
  },
  "sort": [
    1531292009059
  ]
}
```

# 注意

- 要注意写日志是用UDP还是TCP
- 如果要用，Logstash (UDP and HTTP) appender，该功能已经被移动到 https://github.com/log4js-node/logstashUDP 最好要单独安装