---
title: "mysql远程连接速度太慢"
date: "2019-08-08 16:56:12"
draft: false
---
编辑/etc/my.cnf，增加skip-name-resolve

```bash
skip-name-resolve
```

然后重启mysql



