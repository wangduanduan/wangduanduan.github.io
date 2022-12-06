---
title: "日志xlog"
date: "2019-07-09 17:52:55"
draft: false
---


# 建议日志格式

```bash
xlog("$rm $fu->$tu:$cfg_line some msg")
```



# 日志级别

- L_ALERT (-3)
- L_CRIT (-2)
- L_ERR (-1) - this is used by default if log_level is omitted
- L_WARN (1)
- L_NOTICE (2)
- L_INFO (3)
- L_DBG (4)

日志级别如果设置为2， 那么只会打印小于等于2的日志。默认使用xlog("hello"), 那么日志级别就会是L_ERR

**生产环境建议将日志界别调整到-1**

1.x的opensips使用 debug=3 设置日志级别<br />2.x的opensips使用 log_level=3 设置日志级别



# 动态设置日志级别

在程序运行时，可以通过opensipctl 命令动态设置日志级别

```c
opensipsctl fifo log_level -2
```



# 最好使用日志级别

```
不要为了简便，都用 xlog("msg")

如果msg是信息级别，用xlog("L_INFO", "msg")
如果msg是错误信息，则使用xlog("msg")
```


