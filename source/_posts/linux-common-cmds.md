---
title: linux常用命令使用场景总结
date: 2018-01-31 09:58:33
tags:
- linux
- shell
---

# lsof: 根据端口号查监听的进程号
[参考](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/lsof.html)

使用模型：`lsof -i :port`

已知某服务占用8088端口，请查出使用该端口的进程号

```
lsof -i :8088
```

> lsof（list open files）是一个查看当前系统文件的工具。在linux环境下，任何事物都以文件的形式存在，通过文件不仅仅可以访问常规数据，还可以访问网络连接和硬件。如传输控制协议 (TCP) 和用户数据报协议 (UDP) 套接字等，系统在后台都为该应用程序分配了一个文件描述符，该文件描述符提供了大量关于这个应用程序本身的信息。[lsof命令详情](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/lsof.html)

# grep: 搜索神器

参考： [GNU Grep 3.0](https://www.gnu.org/software/grep/manual/grep.html)
```
--color:高亮显示匹配到的字符串
-v：显示不能被pattern匹配到的
-i：忽略字符大小写
-o：仅显示匹配到的字符串
-q：静默模式，不输出任何信息
-A#：after，匹配到的后#行
-B#：before，匹配到的前#行
-C#：context，匹配到的前后各#行
-E：使用ERE，支持使用扩展的正则表达式

－c：只输出匹配行的计数。
－I：不区分大 小写(只适用于单字符)。
－h：查询多文件时不显示文件名。
－l：查询多文件时只输出包含匹配字符的文件名。
－n：显示匹配行及 行号。
- m: 匹配多少个关键词之后就停止搜索
－s：不显示不存在或无匹配文本的错误信息。
－v：显示不包含匹配文本的所有行。
```

##普通：搜索trace.log 中含有ERROR字段的日志
`grep ERROR trace.log `

##输出文件：可以将日志输出文件中
`grep ERROR trace.log > error.log`

##反向：搜索不包含ERROR字段的日志
`grep -v ERROR trace.log`

##向前：搜索包含ERROR,并且显示ERROR前10行的日志
`grep -B 10 ERROR trace.log`

##向后：搜索包含ERROR字段，并且显示ERROR后10行的日志
`grep -A 10 ERROR trace.log`

##上下文：搜索包含ERROR字段，并且显示ERROR字段前后10行的日志
`grep -C 10 ERROR trace.log`

##多字段：搜索包含ERROR和DEBUG字段的日志
`gerp -E 'ERROR|DEBUG' trace.log`

##多文件：从多个.log文件中搜索含有ERROR的日志
`grep ERROR *.log`

##省略文件名：从多个.log文件中搜索ERROR字段日志，并不显示日志文件名
从多个文件中搜索的日志默认每行会带有日志文件名

`grep -h ERROR *.log`

##时间范围： 按照时间范围搜索日志
`awk '$2>"17:30:00" && $2<"18:00:00"' trace.log`
日志形式如下, $2代表第二列即11:44:58, awk需要指定列
```
11-21 16:44:58 /user/info/
```

##有没有：搜索到第一个匹配行后就停止搜索
`grep -m 1 ERROR trace.log`

## 行数统计: 统计ERROR出现了多少行
`grep -c ERROR trace.log`

## 单词统计：统计ERROR出现了多少次
`grep -c ERROR trace.log | wc -w`

# wc：单词统计


# 参考文献
- [Linux工具快速教程](http://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html)
