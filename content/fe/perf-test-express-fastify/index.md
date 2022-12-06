---
title: "Perf Test Express Fastify"
date: "2021-05-31 13:28:00"
draft: false
---

机器信息：4C32G
测试工具：wrk
Node: v14.17.0

express.js
```bash
'use strict'                                                                                                                                                                                  

const express = require('express')
const app = express()

app.get('/', function (req, res) {
  res.json({ hello: 'world' })
})

app.listen(3000)

```
fastify.js
```bash
'use strict'                                                                                                                                                                                  
const fastify = require('fastify')()

fastify.get('/', function (req, reply) {
  reply.send({ hello: 'world' })
})

fastify.listen(3000)
~

```

# 测试结果
```bash
# express.js
Running 10s test @ http://127.0.0.1:3000                                                       
  12 threads and 400 connections                                                               
  Thread Stats   Avg      Stdev     Max   +/- Stdev                                            
    Latency    55.36ms   11.53ms 173.22ms   93.16%                                             
    Req/Sec   602.58    113.03   830.00     84.97%                                             
  72034 requests in 10.10s, 17.31MB read                                                       
Requests/sec:   7134.75                                                                                                                                                                       
Transfer/sec:      1.71MB  

# fastify.js
Running 10s test @ http://127.0.0.1:3000                                                       
  12 threads and 400 connections                                                               
  Thread Stats   Avg      Stdev     Max   +/- Stdev                                            
    Latency    16.26ms    5.73ms 105.76ms   96.26%                                             
    Req/Sec     2.08k   490.82    14.63k    94.92%                                             
  249114 requests in 10.09s, 44.43MB read                                                      
Requests/sec:  24688.94                                                                        
Transfer/sec:      4.40MB  
```

fastify是express的3.4倍， 所以对性能有所追求的话，最好用fastify。
