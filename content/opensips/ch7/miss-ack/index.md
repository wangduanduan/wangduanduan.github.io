---
title: "ACK 无法正常送到FS"
date: "2021-03-09 17:10:54"
draft: false
---
通过sngrep抓包发现，通话正常，ACK无法送到FS。导致通话一段时间后，FS因为没有收到ACK，就发送了BYE来挂断呼叫。

sngrep定位到问题可能出在OpenSIPS上，然后分析opensips的日志。

```shell
Mar  9 16:58:00 dd opensips[84]: ERROR:dialog:dlg_validate_dialog: failed to validate remote contact: dlg=[sip:9999@192.168.2.161:5080;transport=udp] , req    =[sip:192.168.2.109:18627;lr;ftag=CX3CDinLARXn1ZRNIlPaFexgirQczdr7;did=4c1.a9657441]
```

上面的日志，提示问题出在dialog验证上，dialog验证失败的原因可能与contact头有关。

然后我有仔细的分析了一下SIP转包。发现contact中的ip地址192.168.2.161并不是fs的地址。但是它为什么会出现在fs回的200ok中呢？

这是我就想起了fs vars.xml，其中有几个参数是用来配置服务器的ip地址的。

由于我的fs是个树莓派，ip是自动分配的，重启之后，可能获取了新的ip。但是老的ip地址，还是存在于vars.xml中。

然后我就去排查了一下fs的var.xml， 发现下面三个参数都是192.168.2.161， 但是实际上树莓派的地址已经不是这个了。

```shell
bind_server_ip
external_rtp_ip
external_sip_ip
```

解决方案：改变fs vars.xml中的地址配置信息，然后重启fs。

除了fs的原因，还有一部分原因可能是错误的使用了**fix_nated_contact。**<br />**<br />务必记住：对于位于边界的SIP服务器来说，对于进入的SIP请求，一般需要fix_nated_contaced。对于这个请求的响应，则不需要进行nat处理。

深入思考一下，为什么concact头修改的错了，往往ack就会有问题呢？ 实际上ack请求的url部分，就是由响应消息的contact头的ulr部分。

