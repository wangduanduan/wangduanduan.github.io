---
title: "wireshark合并和按时间截取pcap文件"
date: "2020-11-25 10:11:22"
draft: false
---
tcpdump可以在抓包时，按照指定时间间隔或者按照指定的包大小，产生新的pcap文件。用wireshark分析这些包时，往往需要将这些包做合并或者分离操作。


# mergecap
如果安装了Wireshark那么mergecap就会自动安装，可以使用它来合并多个pcap文件。
```bash
// 按照数据包中的时间顺序合并文件
mergecap -w output.pcap input1.pcap input2.pcap input3.pcap

// 按照命令行中的输入数据包文件顺序合并文件
// 不加-a, 可能会导致SIP时序图重复的问题
mergecap -a -w output.pcap input1.pcap input2.pcap input3.pcap
```

# editcap

对于一个很大的pcap文件，按照时间范围分割出新的pcap包
```bash
editcap -A '2014-12-10 10:11:01' -B '2014-12-10 10:21:01' input.pcap output.pcap
```

- 参考 [https://blog.csdn.net/qq_19004627/article/details/82287172](https://blog.csdn.net/qq_19004627/article/details/82287172)

