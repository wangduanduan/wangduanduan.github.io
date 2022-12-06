---
title: "flash_player_admin_guide"
date: "2020-09-23 16:28:06"
draft: false
---
虽然flash已经几乎被淘汰了，但是在某些老版本的IE里面，依然有他们顽强的身影。

使用flash 模拟websocket, 有时会遇到下面的问题。虽然flash安全策略文件已经部署，但是客户端依然报错。

[WebSocket] cannot connect to Web Socket Server at ... make sure the server is runing and Flash policy file is correct placed.

解决方案：

在**%WINDIR%\System32\Macromed\Flash**下创建一个名为mms.cfg的文件, 如果文件已经存在，则不用创建。

文件内容如下：

```bash
DisableSockets=0
```


[flash_player_admin_guide.pdf](https://www.yuque.com/attachments/yuque/0/2020/pdf/280451/1600849762923-f66702f2-a7f1-4951-b746-fc0666c2d1cf.pdf)

