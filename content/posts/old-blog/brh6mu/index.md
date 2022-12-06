---
title: "面向异常编程todo"
date: "2021-08-05 08:58:30"
draft: false
---
程序可能大部分时间都是按照正常的逻辑运行，然而也有少数的概率，程序发生异常。 

优秀程序，不仅仅要考虑正常运行，还需要考虑两点：

1. **如何处理异常**
2. **如何在发生异常后，快速定位原因** 

正常的处理如果称为收益的话，异常的处理就是要能够及时止损。

能稳定运行364天的程序，很可能因为一天的问题，就被客户抛弃。因为这一天的损失，就可能会超过之前收益的总和。 


# 异常应当如何处理 

> 如果事情有变坏的可能，不管这种可能性有多小，它总会发生。《莫非定律》


对于程序来说，避免变坏的方法只有一个，就是不要运行程序（纯粹废话😂）。


## 1. 及时崩溃
```javascript
var conn = nil
var maxConnectTimes = 3
var reconnectDelay = 3 * 1000
var currentReconnectTimes = 0
var timeId = 0

func InitDb () {
	conn = connect("数据库")
  conn.on("connected", ()=>{
    // 将当前重连次数重制为0
  	currentReconnectTimes = 0
  })
  conn.on("error", ReconnectDb)
}

func ReconnectDb () {
	conn.Close()
  // 如果重连次数大于最大重连次数，将不在重连
  if currentReconnecTimes > maxConnectTimes {
  	return
  }
  // 如果已经催在重连的任务，则先关闭
  if timeId != 0 {
  	cleanTimeout(timeId)
  }
  // 当前重连次数增加
  currentReconnectTimes++
  
  // 开始延迟重连
  timeId = setTimeout(InitDb, reconnectDelay)
}
```

## 2. <br /><br />

# 如何快速定位问题 


第一，代码的敬畏之心 <br />第二，及时告警。日志，或者http请求 <br />第三，编程时，就要考虑异常。例如程序依赖 MQ或者Mysql，当与之交互的链接断开后，应该怎样处理？ <br />第四，多实例问题考虑 <br />第五，检查清单 

