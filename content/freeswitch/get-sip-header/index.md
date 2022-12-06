---
title: "通道变量与SIP 消息头"
date: "2019-07-15 23:06:57"
draft: false
---
<a name="2aMRO"></a>
# 自定义SIP消息头如何从通道变量中获取？
 if you pass a header variable called `type` from the proxy server, it will get displayed as `variable_sip_h_type` in FreeSWITCH™. To access that variable, you should strip off the `variable_`, and just do `${sip_h_type}`



