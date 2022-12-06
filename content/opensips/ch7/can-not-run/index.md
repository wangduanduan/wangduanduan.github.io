---
title: "opensips无法启动"
date: "2021-08-19 19:19:52"
draft: false
---

# 排查日志
opensips的**log_stderror**参数决定写日志的位置，

- yes 写日志到标准错误
- no 写日志到syslog服务(默认)

如果使用默认的syslog服务，那么日志将会可能写到以下两个文件中。

- /var/log/messages
- /var/log/syslog

一般情况下，分析/var/log/messages日志，可以定位到无法启动的原因。

如果日志文件中无法定位到具体原因，那么就可以将log_stderror设置为yes。 

注意：**往标准错误中打印的日志，往往比网日志文件中打印的更详细。而且有些时候，我发现这个错误在标准错误中打印了，但是却不会输出到日志文件中。**

**所以，看标准错误的日志，往往更容易定位到问题。**


