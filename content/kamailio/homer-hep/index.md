---
title: "kamailio 集成 HEP Server"
date: "2025-02-17 22:57:11"
draft: true
type: posts
tags:
- kamailio
categories:
- all
---

# 目标
- kamailio将所收到的SIP消息封装成HEP格式，然后已UDP发送给Hep Server

# 环境说明
- kamailio版本 5.6
- Hep server地址 192.168.0.100

# kamailio脚本

```cfg
listen
```


# 参考文档
- https://www.kamailio.org/docs/modules/5.6.x/modules/siptrace.html
- https://github.com/sipcapture/homer/discussions/619
- https://github.com/sipcapture/homer/wiki/Examples%3A-Kamailio
