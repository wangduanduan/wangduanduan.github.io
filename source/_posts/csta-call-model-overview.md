---
title: CSTA 呼叫模型简介
date: 2018-01-29 21:35:24
tags:
- csta
---

# 1. 内容概要
- CSTA协议与标准概述
- CSTA OpenScape 语音架构概述

# 2. CSTA协议标准

## 2.1. 什么是CSTA ?
- CSTA：电脑支持通讯程序(Computer Supported TelecommunicationsApplications)
- 基本的呼叫模型在1992建立，后来随着行业发展，呼叫模型也被加强和扩展，例如新的协议等等
- CSTA是一个应用层接口，用来监控呼叫，设备和网络 
- CSTA创建了一个通讯程序的抽象层:
    - CSTA并不依赖任何底层的信令协议
        - E.g.H.323,SIP,Analog,T1,ISDN,etc.
    - CSTA并不要求用户必须使用某些设备
        - E.g.intelligentendpoints,low-function/stimulusdevices,SIPSignalingmodels-3PCC vs. Peer/Peer

- 适用不同的操作模式
    - 第三方呼叫控制
    - 一方呼叫控制
- CSTA的设计目标是为了提高各种CSTA实现之间的移植性
    - 规范化呼叫模型和行为
    - 完成服务、事件定义
    - 规范化标准

# 3. CSTA 标准的进化史
- 阶段1 (发布于 June ’92)
    - 40 特性, 66 页 (服务定义)
    - 专注于呼叫控制
- 阶段2 (发布于 Dec. ’94)
    - 77 特性, 145 页 (服务定义)
    - I/O & 语音单元服务, 更多呼叫控制服务
- 阶段3 - CSTA Phase II Features & versit CTI Technology
    - 发布于 Dec. ‘98
    - 136 特性, 650 页 (服务定义)
    - 作为ISO 标准发布于 July 2000
    - 发布 CSTA XML (ECMA-323) June 2004
    - 发布 “Using CSTA with Voice Browsers” (TR/85) Dec. 02
    - 发布 CSTA WSDL (ECMA-348) June 2004

- June 2004: 发布对象模型 TR/88
- June 2004: 发布 “Using CSTA for SIP Phone User Agents (uaCSTA)” TR/87
- June 2004: 发布 “Application Session Services” (ECMA-354)
- June 2005: 发布 “WS-Session: WSDL for ECMA-354”(ECMA-366)
- December 2005 : 发布 “Management Notification and Computing Function
Services”
- December 2005 : Session Management, Event Notification, Amendements for ECMA-
348” (TR/90)
- December 2006 : Published new editions of ECMA-269, ECMA-323, ECMA-348

# 4. CSTA 标准文档
![](/images/20180129213747_HP5lYR_Jietu20180129-213719.jpeg)

# 5. CSTA 标准扩展
- 新的特性可以被加入标准通过发布新版本的标准
- 新的参数，新的值可以被加入通过发布新版本的标准
- 未来的新版本必须下向后兼容
- 具体的实施可以增加属性通过CSTA自带的扩展机制(e.g. ONS – One Number Service)

# 6. CSTA 操作模型
- CSTA操作模型由`计算域`和`转换域`组成，是CSTA定义在两个域之间的接口
- CSTA标准规定了消息（服务以及事件上报）,还有与之相关的行为
- `计算域`是CSTA程序的宿主环境，用来与`转换域`交互与控制
- `转换域` - CSTA模型提供抽象层，程序可以观测并控制的。`转换渔`包括一些对象例如CSTA呼叫，设备，链接。

![](/images/20180129213839_Tor6cE_Screenshot.jpeg)

# 7. CSTA 操作模型：呼叫，设备，链接

![](/images/20180129213917_6hEPjl_Screenshot.jpeg)

相关说明是的的的的

                
# 8. 参考
- [CSTAoverview](http://ecma-international.org/activities/Communications/TG11/CSTAoverview.pdf)
- [CSTA_introduction_and_overview](http://wiki.unify.com/images/3/3e/CSTA_introduction_and_overview.pdf)




