---
title: "RTPEngine mr13版本, 特殊的fmtp参数会导致某些语音编码被移除"
date: "2025-06-18 20:04:52"
draft: false
type: posts
tags:
- all
categories:
- all
---

# 场景说明

如下图所示

- Offer阶段，F1, F2 步骤里PCMU编码有个fmtp参数`abc=no`, 这个参数可能只对呼叫发起方有意义，对被叫方来说，只会被忽略。
- Answer阶段, 例如被叫是个FreeSWITCH, 它不认识abc=no, 就直接忽略，然后应答编码是PCMU。但是rtpengine认为不带abc=no的参数，就认为这个PCMU的编码是不可能被选中的，然后就直接删掉了PCMU编码， 只保留了一个101编码
- 由于主叫收到101的编码，而没有语音的编码，所以主叫收到200 Ok后立马就发送了BYE

```sh
// F1: send offer to rtpegnine
m=audio 2000 RTP/AVP 0 8 101
a=rtpmap:0 PCMU/8000
a=fmtp:0 abc=no
a=rtpmap:8 PCMA/8000
a=fmtp:8 abc=no
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15

// F2: receive offer from rtpengine
m=audio PORT RTP/AVP 0 8 101
c=IN IP4 203.0.113.1
a=rtpmap:0 PCMU/8000
a=fmtp:0 abc=no
a=rtpmap:8 PCMA/8000
a=fmtp:8 abc=no
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15


// F3: send answer to rtepngine
m=audio 2002 RTP/AVP 0 101
a=rtpmap:0 PCMU/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15

// F4: expect receive answer from rtpengine
m=audio PORT RTP/AVP 0 101
c=IN IP4 203.0.113.1
a=rtpmap:0 PCMU/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-15
```

# 问题原因

刚开始我以为是， https://github.com/sipwise/rtpengine/commit/9c00f30 这次commit引起的问题，我尝试注释代码，然后进行测试，发现可以解决问题。

但是后续官方维护者用了更好的方案解决，https://github.com/sipwise/rtpengine/commit/92ee47116a8a56148cad391321fc291cc5e11837 

新的解决方案是知识针对G711编码，配置了 `.format_cmp = format_cmp_ignore,`

# 参考
- https://github.com/sipwise/rtpengine/issues/1948
- https://github.com/sipwise/rtpengine/commit/9c00f30
- https://github.com/sipwise/rtpengine/commit/3e0bd2e




