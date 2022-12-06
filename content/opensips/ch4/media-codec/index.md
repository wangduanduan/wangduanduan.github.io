---
title: "常见媒体流编码及其特点"
date: "2019-09-13 09:04:12"
draft: false
---

| 编码 | 带宽 | MOS | 环境 | 特点 | 说明 |
| --- | --- | --- | --- | --- | --- |
| G.711 | 64 kbps | 4.45 | LAN/WAN | 语音质量高，适合对接网关 | G.711实际上就是PCM, 是最基本的编码方式。PCM又分为两类PCMA(g711a), PCMU(g711u)。<br /><br />中国使用的是PCMA |
| G.729 | 8 kbps | 4.04 | WAN | 带宽占用率很小，同时能保证不错的语音质量 | 分为G729a和G729b两种，G729之所以带宽占用是G711的1/8, 是因为G729的压缩算法不同。G729传输的不是真正的语音，而是语音压缩后的结果。<br />G729的编解码是由专利的，也就说不免费。 |
| G.722 | 64 kbps | 4.5 | LAN | 语音质量高 HD | hd语音 |
| GSM | 13.3 kbps | 3.01 |  |  |  |
| iLBA | 13.3 15.2 |  |  | 抗丢包 |  |
| OPUS | 6-510 kbps | - | INTERNET | OPUS的带宽范围跨度很广，适合语音和视屏 |  |


MOS值，Mean Opinion Score，用来定义语音质量。满分为5分，最低1分。

| MOS | 质量 |
| --- | --- |
| 5 | 极好的 |
| 4 | 不错的 |
| 3 | 还行吧 |
| 2 | 中等差 |
| 1 | 最差 |


通常的打包是20ms一个包，那么一秒就会传输1000/20=50个包。如果采样评率是8000Hz,  那么每个包的会携带 8000/50=160个采样数据。在PCMA或者PCMU中，每个采样数据占用1字节。因此20ms的一个包就携带160字节的数据。

在RTP包协议中，160字节还要加上12个自己的RTP头。<br />![Jietu20190913-095311.jpg](https://cdn.nlark.com/yuque/0/2019/jpeg/280451/1568339615992-252e86b4-91d2-44f6-b896-fe8c29d98fdc.jpeg#align=left&display=inline&height=608&name=Jietu20190913-095311.jpg&originHeight=608&originWidth=2048&size=174948&status=done&style=none&width=2048)


在fs上可以使用下面的命令查看fs支持的编码。

```bash
show codec
```


