---
title: "window轻量级抓包工具RawCap介绍"
date: "2020-04-09 16:58:20"
draft: false
---
相比于wireshark, RawCap非常小，仅有48kb。


使用RawCap命令需要**使用管理员权限打开CMD**，然后进入到RawCap.exe的目录。例如F:\Tools


# 显示网卡列表
输入RawCap.exe --help, 可以显示命令的使用帮助、网卡列表还有使用例子。

```bash
F:\Tools>RawCap.exe --help
NETRESEC RawCap version 0.2.0.0

Usage: RawCap.exe [OPTIONS] <interface> <pcap_target>
 <interface> can be an interface number or IP address
 <pcap_target> can be filename, stdout (-) or named pipe (starting with \\.\pipe\)

OPTIONS:
 -f          Flush data to file after each packet (no buffer)
 -c <count>  Stop sniffing after receiving <count> packets
 -s <sec>    Stop sniffing after <sec> seconds
 -m          Disable automatic creation of RawCap firewall entry
 -q          Quiet, don't print packet count to standard out

INTERFACES:
 0.     IP        : 169.254.63.243
        NIC Name  : Local Area Connection
        NIC Type  : Ethernet

 1.     IP        : 192.168.1.129
        NIC Name  : WiFi
        NIC Type  : Wireless80211

 2.     IP        : 127.0.0.1
        NIC Name  : Loopback Pseudo-Interface 1
        NIC Type  : Loopback

 3.     IP        : 10.165.240.132
        NIC Name  : Mobile 12
        NIC Type  : Wwanpp

Example 1: RawCap.exe 0 dumpfile.pcap
Example 2: RawCap.exe -s 60 127.0.0.1 localhost.pcap
Example 3: RawCap.exe 127.0.0.1 \\.\pipe\RawCap
Example 4: RawCap.exe -q 127.0.0.1 - | Wireshark.exe -i - -k
```


:::warning
注意：

- 执行RawCap.exe的时候，不要用 ./RawCap.exe , 直接用文件名 RawCap.exe 加执行参数
- RawCap的功能很弱，没有包过滤。只能指定网卡抓包，然后保存为文件。
:::

# 抓指定网卡的包

```bash
Example 1: RawCap.exe 0 dumpfile.pcap
Example 2: RawCap.exe -s 60 127.0.0.1 localhost.pcap
Example 3: RawCap.exe 127.0.0.1 \\.\pipe\RawCap
Example 4: RawCap.exe -q 127.0.0.1 - | Wireshark.exe -i - -k
```



# 参考
[https://www.netresec.com/?page=RawCap](https://www.netresec.com/?page=RawCap)


# 附件
附件中有两个版本的rawcap文件。


- [raw-cap.zip](https://www.yuque.com/attachments/yuque/0/2020/zip/280451/1586423016907-8d5d20f4-7638-4ad1-91c8-3334f48e971b.zip?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2020%2Fzip%2F280451%2F1586423016907-8d5d20f4-7638-4ad1-91c8-3334f48e971b.zip%22%2C%22name%22%3A%22raw-cap.zip%22%2C%22size%22%3A38058%2C%22type%22%3A%22application%2Fzip%22%2C%22ext%22%3A%22zip%22%2C%22status%22%3A%22done%22%2C%22uid%22%3A%221586423016629-0%22%2C%22progress%22%3A%7B%22percent%22%3A99%7D%2C%22percent%22%3A0%2C%22id%22%3A%22Ot6Vk%22%2C%22card%22%3A%22file%22%7D)

