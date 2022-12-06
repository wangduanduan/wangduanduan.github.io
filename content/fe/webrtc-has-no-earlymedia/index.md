---
title: "记一次WebRTC无回铃音问题排查"
date: "2022-10-29 11:31:05"
draft: false
---


# 什么是回铃音？

回铃音的特点

- 回铃音是由运营商送给手机的，而不是由被叫送给主叫的。
- 回铃音的播放阶段是在被叫接听前播放，被叫一旦接听，回铃音则播放结束
- 回铃音一般是450Hz, 嘟一秒，停4秒，5秒一个周期

回铃音分为三种

1. 舒适噪音阶段：就是嘟一秒，停4秒的阶段
2. 彩铃阶段：有的手机，在接听之前，会向主叫方播放个性化的语音，例如放点流行音乐之类的
3. 定制回音阶段：例如被叫放立即把电话给拒绝了，但是主叫放这边并没有挂电话，而是在播放：对不起，您拨打的电话无人接听，请稍后再播

# 问题现象

- WebRTC拨打出去之后，在客户接听之前，听不到任何回铃音。在客户接听之后，可以短暂的听到一点点回铃音。

# 问题排查思路

1. 服务端问题
2. 客户端问题
3. 网络问题

# 网络架构

![](https://cdn.nlark.com/yuque/__graphviz/489f16c87abf155331b416bed85d4af5.svg#lake_card_v2=eyJjb2RlIjoiZ3JhcGh7XG5cdHJhbmtkaXI9TFJcblx0d2VicnRjIC0tIOi3r-eUseWZqCBbbGFiZWw9XCJhXCJdXG5cdOi3r-eUseWZqCAtLSDkupLogZTnvZFcblx05LqS6IGU572RIC0tIFNJUOacjeWKoeWZqEEgXG5cdFNJUOacjeWKoeWZqEEgLS0gU0lQ5pyN5Yqh5ZmoQiBbbGFiZWw9XCJiXCJdXG59IiwidHlwZSI6ImdyYXBodml6IiwibWFyZ2luIjp0cnVlLCJpZCI6IklZVlplIiwidXJsIjoiaHR0cHM6Ly9jZG4ubmxhcmsuY29tL3l1cXVlL19fZ3JhcGh2aXovNDg5ZjE2Yzg3YWJmMTU1MzMxYjQxNmJlZDg1ZDRhZjUuc3ZnIiwiaGVpZ2h0Ijo4MiwiY2FyZCI6ImRpYWdyYW0ifQ==)
- 首先根据网络架构图，我决定在a点和b点进行抓包

抓包之后用wireshark进行分析。得出以下结论

1. sip服务器AB之间用的是g711编码，语音流没有加密。从b点抓的包，能够从中提取出SIP服务器B向sip服务器A发送的语音流，可以听到回铃音。说明SIP服务器A是收到了回铃音的。
2. ab两点之间的WebRTC语音流是加密的，无法分析出其中是否含有语音流。
3. 虽然无法提取出WebRTC语音流。但是通过wireshark Statistics -> Conversation 分析，得出结论：在电话接通之前，a点收到的udp包和从b点发出的udp包的数量是是一致的。说明webrtc客户端实际上是收到了语音流。只不过客户端没有播放。然后问题定位到客户端的js库。
4. 通过分析客户端库的代码，定位到具体代码的位置。解决问题，并向开源库提交了修复bug的的pull request。实际上只是修改了一行代码。[https://github.com/versatica/JsSIP/pull/669](https://github.com/versatica/JsSIP/pull/669)


# 问题总结
解决问题看似很简单，但是需要的很强的问题分析能力，并且对网络协议，网络架构，wireshark抓包分析都要精通，才能真正的看到深层次的东西。

