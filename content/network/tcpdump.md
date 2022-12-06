---
title: "Tcpdump抓包教程"
date: "2022-10-25 09:09:05"
draft: false
type: posts
---


# 查看帮助文档

从帮助文档可以看出，包过滤的表达式一定要放在最后一个参数
```bash
       tcpdump [ -AbdDefhHIJKlLnNOpqStuUvxX# ] [ -B buffer_size ]
               [ -c count ] [ --count ] [ -C file_size ]
               [ -E spi@ipaddr algo:secret,...  ]
               [ -F file ] [ -G rotate_seconds ] [ -i interface ]
               [ --immediate-mode ] [ -j tstamp_type ] [ -m module ]
               [ -M secret ] [ --number ] [ --print ] [ -Q in|out|inout ]
               [ -r file ] [ -s snaplen ] [ -T type ] [ --version ]
               [ -V file ] [ -w file ] [ -W filecount ] [ -y datalinktype ]
               [ -z postrotate-command ] [ -Z user ]
               [ --time-stamp-precision=tstamp_precision ]
               [ --micro ] [ --nano ]
               [ expression ]
```
# 列出所有网卡
```bash
tcpdump -D

1.enp89s0 [Up, Running, Connected]
2.docker0 [Up, Running, Connected]
3.vetha051ecc [Up, Running, Connected]
4.vethe67e03a [Up, Running, Connected]
5.vethc58c174 [Up, Running, Connected]

```
# 指定网卡 -i

```bash
tcpdump -i eth0
```

# 所有网卡
```bash
tcpdump -i any
```

# 不要域名解析
```bash
tcpdump -n -i any
```

# 指定主机

```bash
tcpdoump host 192.168.0.1
```

# 指定源IP或者目标IP
```
# 根据源IP过滤
tcpdump src 192.168.3.2

# 根据目标IP过滤
tcpdump dst 192.168.3.2
```
# 指定协议过滤

```bash
tcpdump tcp
```

# 指定端口

```bash
# 根据某个端口过滤
tcpdomp port 33

# 根据源端口或者目标端口过滤
tcpdump dst port 33
tcpdump src port 33

# 根据端口范围过滤
tcpdump portrange 30-90
```

# 根据IP和地址

```bash
tcpdump -i ens33 tcp and host 192.168.40.30
```

# 抓包结果写文件

```bash
tcpdump -i ens33 tcp and host 192.168.40.30 -w log.pcap
```

# 每隔30秒写一个文件

- `-G 30` 表示每隔30秒写一个文件
- 文件名中的%实际上是时间格式

```bash
tcpdump -i ens33 -G 30 tcp and host 192.168.40.30 -w %Y_%m%d_%H%M_%S.log.pcap
```

# 每达到30MB产生一个文件

- `-C 30` 每达到30MB产生一个文件
```bash
tcpdump -i ens33 -C 30 tcp and host 192.168.40.30 -w log.pcap
```

# 指定抓包的个数
在流量很大的网络上抓包，如果写文件的话，很可能将磁盘写满。所以最好指定一个最大的抓包个数，在达到包的个数后，自动退出。

```bash
tcpdump -c 100000 -i eth0 host 21.23.3.2 -w test.pcap
```

# 抓包文件太大，切割成小包

把原来的包文件切割成20M大小的多个包
```makefile
tcpdump -r old_file -w new_files -C 20
```

# 按照包长大小过滤
```bash
# 包长小于某个值
tcpdump less 30

# 包长大于某个值
tcpdump greater 30
```
# 
# 按照16进制的方式显示包的内容

# BPF 过滤规则

```bash
port 53
src port 53
dest port 53
host 1.2.3.4
src host 1.2.3.4
dest host 1.2.3.4
host 1.2.3.4 and port 53
```

# 读取old.pcap文件 然后根据条件过滤 产生新的文件

适用于从一个大的pcap文件中过滤出需要的包

```
tcpdump -r old.pcap -w new.pcap less 1280
```

# 最佳实践

## 1. 关注 packets dropped by kernel的值

有时候，抓包停止后，tcpdump打印xxx个包drop by kernel。一旦这个值不为零，就要注意了。某些包并不是在网络中丢包了，而是在tcpdump这个工具给丢弃了。
```
60 packets captured
279514 packets received by filter
279368 packets dropped by kernel
```

默认情况下，tcpdump抓包时会做dns解析，这个dns解析会降低tcpdump的处理速度，造成tcpdump的buffer被填满，然后就被tcpdump丢弃。

我们可以用两个方法解决这个问题

1. -B 指定buffer的大小，默认单位为kb。例如-B 1024
2. -n -nn 设置tcpdump 不要解析host地址，不要抓换协议和端口号

```
-n     Don't convert host addresses to names.  This can be used to avoid DNS lookups.

-nn    Don't convert protocol and port numbers etc. to names either.

-B buffer_size
--buffer-size=buffer_size
  Set the operating system capture buffer size to buffer_size, in units of KiB (1024 bytes).
```

# 参考

- [https://serverfault.com/questions/131872/how-to-split-a-pcap-file-into-a-set-of-smaller-ones](https://serverfault.com/questions/131872/how-to-split-a-pcap-file-into-a-set-of-smaller-ones)
- [http://alumni.cs.ucr.edu/~marios/ethereal-tcpdump.pdf](http://alumni.cs.ucr.edu/~marios/ethereal-tcpdump.pdf)
- [ethereal-tcpdump.pdf](https://www.yuque.com/attachments/yuque/0/2021/pdf/280451/1626588032882-a3eda373-8e1e-46be-9f97-5ad42473a6d9.pdf?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2021%2Fpdf%2F280451%2F1626588032882-a3eda373-8e1e-46be-9f97-5ad42473a6d9.pdf%22%2C%22name%22%3A%22ethereal-tcpdump.pdf%22%2C%22size%22%3A78412%2C%22type%22%3A%22application%2Fpdf%22%2C%22ext%22%3A%22pdf%22%2C%22status%22%3A%22done%22%2C%22taskId%22%3A%22u847a776e-8d93-4565-9217-1ea315a6320%22%2C%22taskType%22%3A%22upload%22%2C%22id%22%3A%22ua4c30b92%22%2C%22card%22%3A%22file%22%7D)
- [https://unix.stackexchange.com/questions/144794/why-would-the-kernel-drop-packets](https://unix.stackexchange.com/questions/144794/why-would-the-kernel-drop-packets)

