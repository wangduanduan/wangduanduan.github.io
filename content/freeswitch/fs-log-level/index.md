---
title: "fs日志级别"
date: "2019-07-11 17:13:29"
draft: false
---
fs日志级别

```bash
0 "CONSOLE",
1 "ALERT",
2 "CRIT",
3 "ERR",
4 "WARNING",
5 "NOTICE",
6 "INFO",
7 "DEBUG"
```

**日志级别设置的越高，显示的日志越多**

在autoload_configs/switch.conf.xml 设置了一些快捷键，可以在fs_cli中使用

- **F7**将日志级别设置为0，显示的日志最少
- **F8**将日志级别设置为7， 显示日志最多

同时也可以使用 console loglevel指令自定义设置级别

```bash
console loglevel 1
console loglevel notice
```

<a name="ZADYQ"></a>
# 参考

- [https://freeswitch.org/confluence/display/FREESWITCH/Troubleshooting+Debugging](https://freeswitch.org/confluence/display/FREESWITCH/Troubleshooting+Debugging)

