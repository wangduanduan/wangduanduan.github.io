---
title: 基于 WebRTC 构建 Web SIP Phone
date: 2018-02-11 14:44:58
tags:
- webrtc
- sip
---

# 0 阅前须知
- 本文并不是教程，只是实现方案
- 我只是从WEB端考虑这个问题，实际还需要后端sip服务器的配合
- jsSIP有个非常不错的在线demo, 可以去哪里玩耍，很好玩呢 [try jssip ](https://tryit.jssip.net/)

![](http://p3alsaatj.bkt.clouddn.com/20180211144554_nUwjgc_Screenshot.jpeg)

# 1. 技术简介
> - `WebRTC`: WebRTC，名称源自`网页即时通信`（英语：Web Real-Time Communication）的缩写，是一个支持网页浏览器进行实时语音对话或视频对话的API。它于2011年6月1日开源并在Google、Mozilla、Opera支持下被纳入万维网联盟的W3C推荐标准

> - `SIP`: `会话发起协议`（Session Initiation Protocol，缩写SIP）是一个由IETF MMUSIC工作组开发的协议，作为标准被提议用于创建，修改和终止包括视频，语音，即时通信，在线游戏和虚拟现实等多种多媒体元素在内的交互式用户会话。2000年11月，SIP被正式批准成为3GPP信号协议之一，并成为IMS体系结构的一个永久单元。SIP与H.323一样，是用于VoIP最主要的信令协议之一。

![](http://p3alsaatj.bkt.clouddn.com/20180211144604_Zdxh2x_Screenshot.jpeg)

一般来说，要么使用实体话机，要么在系统上安装基于sip的客户端程序。实体话机硬件成本高，基于sip的客户端往往兼容性差，无法跨平台，易被杀毒软件查杀。

而`WebRTC`或许是更好的解决方案，只要一个浏览器就可以实时语音视频通话，这是很不错的解决方案。WebSocket可以用来传递sip信令，而WebRTC用来实时传输语音视频流。

# 2. 前端WebRTC实现方案
其实我们不需要去自己处理WebRTC的相关方法，或者去处理视频或者媒体流。市面上已经有不错的模块可供选择。

## 2.1 [jsSIP](http://jssip.net/)
`jsSIP是JavaScript SIP 库`

![](http://p3alsaatj.bkt.clouddn.com/20180211144616_7c5Pf0_Screenshot.jpeg)

功能特点如下：

- 可以在浏览器或者Nodejs中运行
- 使用WebSocket传递SIP协议
- 视频音频实时消息使用WebRTC
- 非常轻量
- 100%纯JavaScript
- 使用简单并且具有强大的Api
- 服务端支持 OverSIP, Kamailio, Asterisk, OfficeSIP，reSIProcate，Frafos ABC SBC，TekSIP
- 是RFC 7118 and OverSIP的作者写的

下面是使用JsSIP打电话的例子，非常简单吧
```
// Create our JsSIP instance and run it:

var socket = new JsSIP.WebSocketInterface('wss://sip.myhost.com');
var configuration = {
  sockets  : [ socket ],
  uri      : 'sip:alice@example.com',
  password : 'superpassword'
};

var ua = new JsSIP.UA(configuration);

ua.start();

// Register callbacks to desired call events
var eventHandlers = {
  'progress': function(e) {
    console.log('call is in progress');
  },
  'failed': function(e) {
    console.log('call failed with cause: '+ e.data.cause);
  },
  'ended': function(e) {
    console.log('call ended with cause: '+ e.data.cause);
  },
  'confirmed': function(e) {
    console.log('call confirmed');
  }
};

var options = {
  'eventHandlers'    : eventHandlers,
  'mediaConstraints' : { 'audio': true, 'video': true }
};

var session = ua.call('sip:bob@example.com', options);
```

## 2.2 [SIP.js](https://sipjs.com/)
sip.js项目实际是fork自jsSIP的，这里主要介绍它的服务端支持情况。其他接口自己自行查阅

![](http://p3alsaatj.bkt.clouddn.com/20180211144630_24V1u8_Screenshot.jpeg)

- FreeSWITCH
- Asterisk
- OnSIP
- FreeSWITCH Legacy

# 3. 平台考量

![](http://p3alsaatj.bkt.clouddn.com/20180211144642_my1Cbb_Screenshot.jpeg)

由于WebRTC对浏览器有较高的要求，你可以看看下图，哪些浏览器支持WebRTC, 所有IE浏览器都不行，chrome系支持情况不错。

## 3.1 考量标准
- 跨平台
- 兼容性
- 体积
- 集成性
- 硬件要求
- 开发成本

## 3.2 考量表格
种类 | 适用平台 | 优点 | 缺点
--- | --- |--- | ---
基于electron开发的桌面客户端 | window, mac, linux | 跨平台，兼容好 | 要下载安装，体积大（压缩后至少48MB），对电脑性能有要求
开发js sdk | 现代浏览器 | 体积小，容易第三方集成 | 兼容差(因为涉及到webRTC, IE11以及以都不行，对宿主环境要求高)，客户集成需要开发量
开发谷歌浏览器扩展 | 谷歌浏览器 | 体积小 | 兼容差（仅限类chrome浏览器）


# 4 参考文档 and 延伸阅读 and 动手实践
- [Js SIP Getting Started](http://jssip.net/documentation/3.1.x/getting_started/)
- [120行代码实现 浏览器WebRTC视频聊天](https://segmentfault.com/a/1190000011848805)
- [SIP协议状态码：](https://en.wikipedia.org/wiki/List_of_SIP_response_codes#4xx%E2%80%94Client_Failure_Responses)

# 5 常见问题
## 422: "Session Interval Too Small"

jsSIP默认携带`Session-Expires: 90`的头部信息，如果这个超时字段小于服务端的设定值，那么就会得到如下422的响应。参见[SIP协议状态码：](https://en.wikipedia.org/wiki/List_of_SIP_response_codes#4xx%E2%80%94Client_Failure_Responses), 可以在call请求中设置`sessionTimersExpires`, 使其超过服务端的设定值即可
```
call(targer, options
)
option.sessionTimersExpires
Number (in seconds) for the default Session Timers interval (default value is 90, do not set a lower value).
```


# 6 最后，你我共勉

![clipboard.png](https://i.imgur.com/ZKAN9K7.gif)



  [1]: /img/bV0PUm
  [2]: /img/bV0PST
  [3]: /img/bV0PSZ
  [4]: /img/bV0PS6
  [5]: /img/bV0PTb
  [6]: /img/bV0PTx