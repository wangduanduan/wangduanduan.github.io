---
title: "ssh保持连接状态不断开"
date: "2019-10-06 19:41:44"
draft: false
---

```bash
编辑这个文件 ~/.ssh/config
在顶部添加下边两行

Host *
ServerAliveInterval=30
```

每隔30秒向服务端发送 no-op包

