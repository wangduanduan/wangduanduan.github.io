---
title: "sendmsg failed on 0: Socket operation on non-socket"
date: "2021-09-16 10:04:16"
draft: false
---

```bash
ERROR:core:tcp_init_listener: could not get TCP protocol number
CRITICAL:core:send_fd: sendmsg failed on 0: Socket operation on non-socket
ERROR:core:send2child: send_fd failed
```

不要将tcp_child设置为0

