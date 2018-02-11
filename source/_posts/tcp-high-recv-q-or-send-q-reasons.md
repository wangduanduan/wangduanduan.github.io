---
title: TCP链接高Recv-Q的原因以及解决方法
date: 2018-02-08 21:58:31
tags:
- tcp
- Recv-Q
---

```
tcp 1692012 0 172.17.72.4:48444 10.254.149.149:58080 ESTABLISHED 27/node
```



# 1. 参考文献
- [What is the reason for a high Recv-Q of a TCP connection?
](https://stackoverflow.com/questions/34108513/what-is-the-reason-for-a-high-recv-q-of-a-tcp-connection)
- [TCP buffers keep filling up (Recv-Q full): named unresponsive](https://unix.stackexchange.com/questions/100913/tcp-buffers-keep-filling-up-recv-q-full-named-unresponsive)
- [linux探秘:netstat中Recv-Q 深究](http://blog.51cto.com/191274/1592101)
- [深入剖析 Socket——TCP 通信中由于底层队列填满而造成的死锁问题](http://blog.51cto.com/191274/1592101)
- [netstat Recv-Q和Send-Q](http://blog.csdn.net/sjin_1314/article/details/9853163)
- [深入剖析 Socket——数据传输的底层实现](http://wiki.jikexueyuan.com/project/java-socket/socket-advanced.html)
- [Use of Recv-Q and Send-Q](https://stackoverflow.com/questions/36466744/use-of-recv-q-and-send-q)