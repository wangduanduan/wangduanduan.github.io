---
title: "acc呼叫记录模块"
date: "2020-05-29 09:35:43"
draft: false
---
opensips 1.x 使用各种flag去设置一个呼叫是否需要记录。从opensips 2.2开始，不再使用flag的方式，而使用 `do_accounting()` 函数去标记是否需要记录呼叫。

注意 do_accounting()函数并不是收到SIP消息后立即写呼叫记录，也仅仅是做一个标记。实际的写数据库或者写日志发生在事务或者dialog完成的时候。



