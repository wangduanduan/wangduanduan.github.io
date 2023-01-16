---
title: "udp cluster 多进程调度策略学习"
date: "2021-07-21 12:57:03"
draft: false
---
本来我的目的是使用cluster模块的fork出多个进程，让各个进程都能处理udp消息的。但是最终测试发现，实际上仅有一个进程处理了绝大数消息，其他的进程，要么不处理消息，要么处理的非常少的消息。

然而使用cluster来开启http服务的多进程，却能够达到多进程的负载。


# server端demo代码：

```makefile
const cluster = require('cluster')
const numCPUs = require('os').cpus().length
const { logger } = require('./logger')
const dgram = require('dgram')

// const { createHTTPServer, createUDPServer } = require('./app')

const port = 8088

if (cluster.isMaster) {
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork()
  }

  cluster.on('exit', (worker, code, signal) => {
    logger.info(`工作进程 ${worker.process.pid} 已退出`)
  })
} else {
  const server = dgram.createSocket({
    type: 'udp4',
    reuseAddr: true
  })

  server.on('error', (err) => {
    logger.info(`udp server error:\n${err.stack}`)
    server.close()
  })

  server.on('message', (msg, rinfo) => {
    logger.info(`${process.pid} udp server got: ${msg} from ${rinfo.address}:${rinfo.port}`)
  })

  server.on('listening', () => {
    const address = server.address()
    logger.info(`udp server listening ${address.address}:${address.port}`)
  })

  server.bind(port)
}
```

日志库如下：

```makefile
const logger = require('pino')()

module.exports = {
  logger
}
```
启动服务之后，从日志中可以看到：启动了四个进程。
```makefile
{"level":30,"time":1626601194869,"pid":98795,"hostname":"wdd-2.local","msg":"udp server listening 0.0.0.0:8088"}
{"level":30,"time":1626601194870,"pid":98797,"hostname":"wdd-2.local","msg":"udp server listening 0.0.0.0:8088"}
{"level":30,"time":1626601194872,"pid":98798,"hostname":"wdd-2.local","msg":"udp server listening 0.0.0.0:8088"}
{"level":30,"time":1626601194876,"pid":98796,"hostname":"wdd-2.local","msg":"udp server listening 0.0.0.0:8088"}
```
然后我们使用nc, 来向这个udpserver发送消息

```makefile
nc 0.0.0.0 8088
...



```

然后观察server的日志发现：

- 基本上所有的消息都被最后一个进程消费
- pid 98798 消费一个消息
- 其他进程没有消费消息

```makefile
{"level":30,"time":1626601201509,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: adf\n from 127.0.0.1:53080"}
{"level":30,"time":1626601202172,"pid":98798,"hostname":"wdd-2.local","msg":"98798 udp server got: asdflasdf\n from 127.0.0.1:53080"}
{"level":30,"time":1626601202382,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601202545,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601202678,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601202832,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203332,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203420,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203500,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203609,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203669,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203752,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203836,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601203920,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204004,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204089,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204172,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204256,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204340,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204423,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204507,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204590,"pid":98798,"hostname":"wdd-2.local","msg":"98798 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204674,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204759,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204842,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601204926,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601205010,"pid":98798,"hostname":"wdd-2.local","msg":"98798 udp server got: \n from 127.0.0.1:53080"}
{"level":30,"time":1626601205093,"pid":98796,"hostname":"wdd-2.local","msg":"98796 udp server got: \n from 127.0.0.1:53080"}
```

# 

# 为什么会这样？看看cluster模块的代码



## lib/cluster.js

- lib/cluster.js
- cluster除去注释，代码仅有两行
```javascript
'use strict';

// 根据环境变量中是否有NODE_UNIQUE_ID来判断当前进程是主进程还是子进程
const childOrPrimary = 'NODE_UNIQUE_ID' in process.env ? 'child' : 'primary';
// 根据进程类型不同，加载的文件也不同
// 对于主进程，则加载 internal/cluster/primary
// 对于自进程，则加载 internal/cluster/child
module.exports = require(`internal/cluster/${childOrPrimary}`);
```

## internal/cluster/primary.js


### 轮询策略的种类

通过阅读源码，我们可以获取到以下结论：

1. cluster模块实际上是一个事件发射器
2. cluster模块有两种负载均衡方式
   1. SCHED_NONE 由操作系统决定
   2. SCHED_RR 轮询的方式

```javascript
const {
  ArrayPrototypePush,
  ArrayPrototypeSlice,
  ArrayPrototypeSome,
  ObjectKeys,
  ObjectValues,
  RegExpPrototypeTest,
  SafeMap,
  StringPrototypeStartsWith,
} = primordials;

const assert = require('internal/assert');
const { fork } = require('child_process');
const path = require('path');
const EventEmitter = require('events');
const RoundRobinHandle = require('internal/cluster/round_robin_handle');
const SharedHandle = require('internal/cluster/shared_handle');
const Worker = require('internal/cluster/worker');
const { internal, sendHelper } = require('internal/cluster/utils');
const cluster = new EventEmitter();
const intercom = new EventEmitter();
const SCHED_NONE = 1;
const SCHED_RR = 2;
const minPort = 1024;
const maxPort = 65535;
const { validatePort } = require('internal/validators');

module.exports = cluster;

const handles = new SafeMap();
cluster.isWorker = false;
cluster.isMaster = true; // Deprecated alias. Must be same as isPrimary.
cluster.isPrimary = true;
cluster.Worker = Worker;
cluster.workers = {};
cluster.settings = {};
cluster.SCHED_NONE = SCHED_NONE;  // Leave it to the operating system.
cluster.SCHED_RR = SCHED_RR;      // Primary distributes connections.
```


### 轮询策略如何选择

接下来，我们就要再看看，两种不同的负载策略是如何选择的？

- 负载策略刚开始来自NODE_CLUSTER_SCHED_POLICY这个环境变量
   - 这个环境变量有两个值 rr和none
   - 但是如果系统平台是win32, 也就是windows的情况下，则不会使用轮训的负载方式
   - 除此以外，默认将会使用轮训的负载方式
```javascript
// XXX(bnoordhuis) Fold cluster.schedulingPolicy into cluster.settings?
let schedulingPolicy = process.env.NODE_CLUSTER_SCHED_POLICY;
if (schedulingPolicy === 'rr')
  schedulingPolicy = SCHED_RR;
else if (schedulingPolicy === 'none')
  schedulingPolicy = SCHED_NONE;
else if (process.platform === 'win32') {
  // Round-robin doesn't perform well on
  // Windows due to the way IOCP is wired up.
  schedulingPolicy = SCHED_NONE;
} else
  schedulingPolicy = SCHED_RR;

cluster.schedulingPolicy = schedulingPolicy;
```
那么，为什么udp的多进程服务器，并没有做到轮询的负载呢？



### 轮询策略的使用

- 即使调用策略是轮询的方式，如果socker是udp的，也不会用轮训的方式去处理，而用SharedHandle去处理
- 注释里面写，udp使用轮询的方式是无意义的，这点我不太理解
```javascript
    // UDP is exempt from round-robin connection balancing for what should
    // be obvious reasons: it's connectionless. There is nothing to send to
    // the workers except raw datagrams and that's pointless.   

		if (schedulingPolicy !== SCHED_RR ||
        message.addressType === 'udp4' ||
        message.addressType === 'udp6') {
      handle = new SharedHandle(key, address, message);
    } else {
      handle = new RoundRobinHandle(key, address, message);
    }
```



