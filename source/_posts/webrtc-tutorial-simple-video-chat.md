---
title: webrtc-tutorial-simple-video-chat
date: 2018-02-09 12:56:12
tags:
- webrtc
---

> 本例子是参考[webrtc-tutorial-simple-video-chat](https://www.scaledrone.com/blog/posts/webrtc-tutorial-simple-video-chat)做的。
> 这个教程应该主要是去宣传ScaleDrone的sdk, 他们的服务是收费的，但是免费的也可以用，就是有些次数限制。

[本栗子的地址](https://github.com/wangduanduan/webrtc)
[本栗子的pages地址](https://wangduanduan.github.io/webrtc/)


# 准备
- 使用最新版谷歌浏览器（62版）
- 视频聊天中 一个是windows, 一个是mac
- stun服务器使用谷歌的，trun使用[ScaleDrone](https://www.scaledrone.com/)的sdk，这样我就不用管服务端了。

# 先上效果图
![](http://p3alsaatj.bkt.clouddn.com/20180209125722_GO0Ee0_Screenshot.jpeg)

# 再上在线例子[点击此处](https://wangduanduan.github.io/webrtc/demos/chat-with-your-friend.html)

# 源码分析

```
// 产生随机数
if (!location.hash) {
    location.hash = Math.floor(Math.random() * 0xFFFFFF).toString(16);
}
// 获取房间号
var roomHash = location.hash.substring(1);

// 放置你自己的频道id, 这是我注册了ScaleDrone 官网后，创建的channel
// 你也可以自己创建
var drone = new ScaleDrone('87fYv4ncOoa0Cjne');
// 房间名必须以 'observable-'开头
var roomName = 'observable-' + roomHash;
var configuration = {
    iceServers: [{
        urls: 'stun:stun.l.google.com:19302' // 使用谷歌的stun服务
    }]
};

var room;
var pc;
function onSuccess() {}

function onError(error) {
    console.error(error);
}

drone.on('open', function(error){
    if (error) { return console.error(error);}

    room = drone.subscribe(roomName);
    room.on('open', function(error){
        if (error) {onError(error);}
    });

    // 已经链接到房间后，就会收到一个 members 数组，代表房间里的成员
    // 这时候信令服务已经就绪
    room.on('members', function(members){
        console.log('MEMBERS', members);

        // 如果你是第二个链接到房间的人，就会创建offer
        var isOfferer = members.length === 2;
        startWebRTC(isOfferer);
    });
});

// 通过Scaledrone发送信令消息
function sendMessage(message) {
    drone.publish({
        room: roomName,
        message
    });
}

function startWebRTC(isOfferer) {
    pc = new RTCPeerConnection(configuration);

    // 当本地ICE Agent需要通过信号服务器发送信息到其他端时
    // 会触发icecandidate事件回调
    pc.onicecandidate = function(event){
        if (event.candidate) {
            sendMessage({ 'candidate': event.candidate });
        }
    };

    // 如果用户是第二个进入的人，就在negotiationneeded 事件后创建sdp
    if (isOfferer) {
        // onnegotiationneeded 在要求sesssion协商时发生
        pc.onnegotiationneeded = function() {
            // 创建本地sdp描述 SDP (Session Description Protocol) session描述协议
            pc.createOffer().then(localDescCreated).catch(onError);
        };
    }

    // 当远程数据流到达时，将数据流装载到video中
    pc.onaddstream = function(event){
        remoteVideo.srcObject = event.stream;
    };

    // 获取本地媒体流
    navigator.mediaDevices.getUserMedia({
        audio: true,
        video: true,
    }).then( function(stream) {
        // 将本地捕获的视频流装载到本地video中
        localVideo.srcObject = stream;

        // 将本地流加入RTCPeerConnection 实例中 发送到其他端
        pc.addStream(stream);
    }, onError);

    // 从Scaledrone监听信令数据
    room.on('data', function(message, client){
        // 消息是我自己发送的，则不处理
        if (client.id === drone.clientId) {
            return;
        }

        if (message.sdp) {
            // 设置远程sdp, 在offer 或者 answer后
            pc.setRemoteDescription(new RTCSessionDescription(message.sdp), function(){
                // 当收到offer 后就接听
                if (pc.remoteDescription.type === 'offer') {
                    pc.createAnswer().then(localDescCreated).catch(onError);
                }
            }, onError);
        }
        else if (message.candidate) {
            // 增加新的 ICE canidatet 到本地的链接中
            pc.addIceCandidate(
                new RTCIceCandidate(message.candidate), onSuccess, onError
            );
        }
    });
}

function localDescCreated(desc) {
    pc.setLocalDescription(desc, function(){
        sendMessage({ 'sdp': pc.localDescription });
    },onError);
}
```

# WebRTC简介
## 介绍
WebRTC 是一个开源项目，用于Web浏览器之间进行实时音频视频通讯，数据传递。
WebRTC有几个JavaScript APIS。 点击链接去查看demo。

- [getUserMedia(): 捕获音频视频]()
- [MediaRecorder: 记录音频视频]()
- [RTCPeerConnection: 在用户之间传递音频流和视频流]()
- [RTCDataChannel: 在用户之间传递文件流]()

## 在哪里使用WebRTC?
- Chrome
- FireFox
- Opera
- Android
- iOS

## 什么是信令
WebRTC使用`RTCPeerConnection`在浏览器之间传递流数据, 但是也需要一种机制去协调收发控制信息，这就是信令。信令的方法和协议并不是在WebRTC中明文规定的。 在codelad中用的是Node，也有许多其他的方法。

## 什么是STUN和TURN和ICE? 
> STUN（Session Traversal Utilities for NAT，NAT会话穿越应用程序）是一种网络协议，它允许位于NAT（或多重NAT）后的客户端找出自己的公网地址，查出自己位于哪种类型的NAT之后以及NAT为某一个本地端口所绑定的Internet端端口。这些信息被用来在两个同时处于NAT路由器之后的主机之间创建UDP通信。该协议由RFC 5389定义。 [wikipedia STUN](https://zh.wikipedia.org/wiki/STUN)

> TURN（全名Traversal Using Relay NAT, NAT中继穿透），是一种资料传输协议（data-transfer protocol）。允许在TCP或UDP的连线上跨越NAT或防火墙。
TURN是一个client-server协议。TURN的NAT穿透方法与STUN类似，都是通过取得应用层中的公有地址达到NAT穿透。但实现TURN client的终端必须在通讯开始前与TURN server进行交互，并要求TURN server产生"relay port"，也就是relayed-transport-address。这时TURN server会建立peer，即远端端点（remote endpoints），开始进行中继（relay）的动作，TURN client利用relay port将资料传送至peer，再由peer转传到另一方的TURN client。[wikipedia TURN](https://zh.wikipedia.org/wiki/TURN)

> ICE （Interactive Connectivity Establishment，互动式连接建立 ），一种综合性的NAT穿越的技术。
互动式连接建立是由IETF的MMUSIC工作组开发出来的一种framework，可整合各种NAT穿透技术，如STUN、TURN（Traversal Using Relay NAT，中继NAT实现的穿透）、RSIP（Realm Specific IP，特定域IP）等。该framework可以让SIP的客户端利用各种NAT穿透方式打穿远程的防火墙。[wikipedia ICE]

![](http://p3alsaatj.bkt.clouddn.com/20180209125753_F5e9Xf_Screenshot.jpeg)

![](http://p3alsaatj.bkt.clouddn.com/20180209125803_bcjg2P_Screenshot.jpeg)

WebRTC被设计用于点对点之间工作，因此用户可以通过最直接的途径连接。然而，WebRTC的构建是为了应付现实中的网络: `客户端应用程序需要穿越NAT网关和防火墙，并且对等网络需要在直接连接失败的情况下进行回调。` 作为这个过程的一部分，WebRTC api使用STUN服务器来获取计算机的IP地址，并将服务器作为中继服务器运行，以防止对等通信失败。(现实世界中的WebRTC更详细地解释了这一点。)

## WebRTC是否安全?
WebRTC组件是强制要求加密的，并且它的JavaScript APIS只能在安全的域下使用(HTTPS 或者 localhost)。信令机制并没有被WebRTC标准定义，所以是否使用安全的协议就取决于你自己了。

# WebRTC 参考资料
- [官网教程](https://webrtc.org/)
- [WebRTC 简单的视频聊天](https://www.scaledrone.com/blog/posts/webrtc-tutorial-simple-video-chat) [repo](https://github.com/ScaleDrone/webrtc)
- [WebRTC 教程](https://www.tutorialspoint.com/webrtc/index.html)
- [MDN WebRTC API](https://developer.mozilla.org/zh-CN/docs/Web/API/WebRTC_API)
- [谷歌codelab WebRT教程](https://codelabs.developers.google.com/codelabs/webrtc-web/#0)
- [github上WebRTC各种例子](https://github.com/webrtc/samples)
- [segemntfault上关于WebRTC的教程](https://segmentfault.com/bookmark/1230000011819985)


  [1]: /img/bVXSyk
  [2]: /img/bVXSyN
  [3]: /img/bVXSyP