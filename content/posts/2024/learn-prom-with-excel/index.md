---
title: "使用Excel理解prometheus的变化率相关函数"
date: "2024-03-16 08:38:46"
draft: false
type: posts
tags:
- prom
categories:
- all
---

# counter类型的变化率 rate, irate, increase

counter类型一般是只增不减的累积值，例如系统累计的http请求数量, 累计的话单数量。

counter类型的指标变化率一般使用三个函数来计算，rate, irate, increase

指标每隔15s采样一次数据, A列是采集的指标值，B列是对应的采集时间。

```sh
demo_api_request_duration_seconds_count{instance="demo-service-0:10000",path="/api/bar",status="200",method="GET"}[1m]
```

| 序号 | A | B |
| --- | --- |--- |
| 1 | 294401976 | 1710549816.105 | 
| 2 | 294402185 | 1710549831.105 |
| 3 | 294402393 | 1710549846.105 |
| 4 | 294402599 | 1710549861.105 |

rate是计算每秒的变化率, 

- rate 计算方案 (A4-A1) / (B4-B1)， 这里选择了首尾两个值的差值，除以时长秒
- irate 计算方案 (A4-A3) / (B4-B3) , 这里只选择里最后两个点的差值，除以时长秒
- increase 计算方式 (A4-A1) / (B4-B1) * 60,  这里的60是1m,  其实increase就是rate() * windows_seconds的语法糖

# guage

```
296164749 @1710648381.105
296165055 @1710648396.105
296165364 @1710648411.105
296165668 @1710648426.105
296165978 @1710648441.105
296166186 @1710648456.105
296166505 @1710648471.105
296166826 @1710648486.105
296167151 @1710648501.105
296167478 @1710648516.105
296167810 @1710648531.105
296168139 @1710648546.105
296168472 @1710648561.105
296168764 @1710648576.105
296169026 @1710648591.105
296169363 @1710648606.105
296169709 @1710648621.105
296170059 @1710648636.105
296170410 @1710648651.105
296170759 @1710648666.107
```