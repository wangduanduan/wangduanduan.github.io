---
title: "FS日志设置"
date: 2022-05-28T17:14:05+08:00
draft: false
---

# 开启sip信令的日志

这样会让fs把收发的sip信令打印到fs_cli里面，但不是日志文件里面

```
sofia global siptrace on

# sofia global siptrace off 关闭
```


# 开启sofia模块的日志

sofia 模块的日志即使开启，也是输出到fs_cli里面的，不会输出到日志文件里面

```
sofia loglevel all 7
# sofia loglevel <all|default|tport|iptsec|nea|nta|nth_client|nth_server|nua|soa|sresolv|stun> [0-9]
```

# 将fs_cli的输出，写到日志文件里

```
sofia tracelevel 会将某些日志重定向到日志文件里

sofia tracelevel debug

# sofia tracelevel <console|alert|crit|err|warning|notice|info|debug>
```

注意，debug级别的日志非常多，仅仅适用于debug

大量的日志写入磁盘

1. 占用太多的io
2. 磁盘空间可能很快占满

