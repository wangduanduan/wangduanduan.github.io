---
title: "WebRTC 人声检测与舒适噪音"
date: 2022-06-01T08:27:53+08:00
type: posts
tags:
- WebRTC
- FreeSWITCH
---

# 人声检测 VAD

人声检测(VAD: Voice Activity Detection)是区分语音中是人说话的声音，还是其他例如环境音的一种功能。

除此以外，人声检测还能用于减少网络中语音包传输的数据量，从而极大的降低语音的带宽，极限情况下能降低50%的带宽。

在一个通话中，一般都是只有一个人说话，另一人听。很少可能是两个人都说话的。

例如A在说话的时候，B可能在等待。 

虽然B在等待过程中，B的语音流依然再按照原始速度和编码再发给A, 即使这里面是环境噪音或者是无声。

```log
A ----> B # A在说话
A <---  B # B在等待过程中，B的语音流依然再按照原始速度和编码再发给A
```

如果B具有VAD检测功能，那么B就可以在不说话的时候，发送特殊标记的语音流或者通过减少语音流发送的频率，来减少无意义语音的发送。 

从而极大的降低B->A的语音流。

下图是Wireshark抓包的两种RTP包，g711编码的占214字节，但是用舒适噪音编码的只有63字节。将近减少了4倍的带宽。

![](/images/Xnip2022-06-01_14-08-05.jpg)

# 舒适噪音生成器 CNG

舒适噪音(CN stands for Comfort Noise), 是一种模拟的背景环境音。舒适噪音生成器在接收端根据发送到给的参数，来产生类似接收端的舒适噪音, 用来模拟发送方的噪音环境。

CN也是一种RTP包的格式，定义在[RFC 3389](https://www.rfc-editor.org/rfc/rfc3389)

舒适噪音的payload, 也被称作静音插入描述帧(SID: a Silence Insertion Descriptor frame), 包括一个字节的数据，用来描述噪音的级别。也可以包含其他的额外的数据。早期版本的舒适噪音的格式定义在RFC 1890中，这个版本的格式只包含一个字段，就是噪音级别。

噪音级别占用一个字节，其中第一个bit必须是0， 因此噪音级别有127中可能。

```
 0 1 2 3 4 5 6 7
+-+-+-+-+-+-+-+-+
|0|   level     |
+-+-+-+-+-+-+-+-+
```

跟着噪音级别的后续字节都是声音的频谱信息。

```
Byte        1      2    3    ...   M+1
       +-----+-----+-----+-----+-----+
       |level|  N1 |  N2 | ... |  NM |
       +-----+-----+-----+-----+-----+

Figure 2: CN Payload Packing Format
```

在SIP INVITE的SDP中也可以看到编码，如下面的CN

```
m=audio 20000 RTP/AVP 8 111 63 103 104 9 0 106 105 13 110 112 113 126
a=rtpmap:106 CN/32000
a=rtpmap:105 CN/16000
a=rtpmap:13 CN/8000
```

当VAD函数检测到没有人声时，就会发送舒适噪音。通常来说，只有当环境噪音发生变化的时候，才需要发送CN包。接收方在收到新的CN包后，会更新产生舒适噪音的参数。

比如下图是sngrep抓包关于webrtc的呼叫时，就能看到浏览器送到SIP Server的CN包。

```
│ <────────────────────────────────────────────────── RTP (g711a) 130 ─────────────────────
│ ──────────────────────────────────── RTP (g711a) 130 ─────────────────────────────────> │
│ ────────────────────────────────────────────────── RTP (g711a) 1168 ─────────────────────
│ <<<──── 200 OK (SDP) ────── │                             │                             │
│ ────────────────────── 200 OK (SDP) ──────────────────>>> │                             │
│ ──────────── ACK ─────────> │                             │                             │
│ <────────────────────────── ACK ───────────────────────── │                             │
│ ──────────── ACK ─────────> │                             │                             │
│ <────────── INFO ────────── │                             │                             │
│ ────────────────────────── INFO ────────────────────────> │                             │
│ <──────────────────────── 200 OK ──────────────────────── │                             │
│ ────────── 200 OK ────────> │                             │                             │
│ <─────────────────────────────────────────────────── RTP (cn) 208 ───────────────────────
│ ───────────────────────────────────── RTP (cn) 208 ───────────────────────────────────> │
│ <────────────────────────── BYE ───────────────────────── │                             │
```

# FreeSWITCH WebRTC 录音质量差

FreeSWITCH bridge两个call leg, 一侧是WebRTC一侧是普通SIP终端，在录音的时候发现录音卡顿基本没办法听，但是双发通话的语音是正常的。

最终发现录音质量差和舒适噪音有关。

方案1: 全局抑制舒适噪音

```
  <!-- Video Settings -->
  <!-- Setting the max bandwdith -->
  <X-PRE-PROCESS cmd="set" data="rtp_video_max_bandwidth_in=3mb"/>
  <X-PRE-PROCESS cmd="set" data="rtp_video_max_bandwidth_out=3mb"/>

  <!-- WebRTC Video -->
  <!-- Suppress CNG for WebRTC Audio -->
  <X-PRE-PROCESS cmd="set" data="suppress_cng=true"/>
  <!-- Enable liberal DTMF for those that can't get it right -->
  <X-PRE-PROCESS cmd="set" data="rtp_liberal_dtmf=true"/>
  <!-- Helps with WebRTC Audio -->

  <!-- Stock Video Avatars -->
  <X-PRE-PROCESS cmd="set" data="video_mute_png=$${images_dir}/default-mute.png"/>
  <X-PRE-PROCESS cmd="set" data="video_no_avatar_png=$${images_dir}/default-avatar.png"/>
```

方案2: 在Bleg抑制舒适噪音

```
<action application="set" data="bridge_generate_comfort_noise=true"/>
<action application="bridge" data="sofia/user/1000"/>
```

# 参考

- https://freeswitch.org/confluence/display/FREESWITCH/VAD+and+CNG
- https://www.rfc-editor.org/rfc/rfc3389
- https://www.rfc-editor.org/rfc/rfc1890
- https://freeswitch.org/confluence/display/FREESWITCH/Sofia+Configuration+Files#SofiaConfigurationFiles-suppress-cng
- https://freeswitch.org/confluence/display/FREESWITCH/bridge_generate_comfort_noise
