---
title: "Wireshark 附带的19命令行程序"
date: 2022-06-30
type: posts
draft: false
---

大多数时候我们都是图形界面的方式使用wireshak, 其实一般只要你安装了wireshark，同时也附带安装了一些命令行工具。
这些工具也可以极大的提高生产效率。
本文只是对工具的功能简介，可以使用命令 -h, 查看命令的具体使用文档。

# 1. editcap 编辑抓包文件
Editcap (Wireshark) 3.6.1 (v3.6.1-0-ga0a473c7c1ba)
Edit and/or translate the format of capture files.
举例: 按照时间范围从input.pcap文件中拿出指定时间范围的包

```
editcap -A '2014-12-10 10:11:01' -B '2014-12-10 10:21:01' input.pcap output.pcap
```

# 2. androiddump
这个命令似乎可以用来对安卓系统进行抓包，没玩过安卓，不再多说。

```
Wireshark - androiddump v1.1.0
Usage:
 androiddump --extcap-interfaces [--adb-server-ip=<arg>] [--adb-server-tcp-port=<arg>]
 androiddump --extcap-interface=INTERFACE --extcap-dlts
 androiddump --extcap-interface=INTERFACE --extcap-config
 androiddump --extcap-interface=INTERFACE --fifo=PATH_FILENAME --capture
```

# 3. ciscodump

似乎是对思科的网络进行抓包的，没用过
Wireshark - ciscodump v1.0.0
Usage:
 ciscodump --extcap-interfaces
 ciscodump --extcap-interface=ciscodump --extcap-dlts
 ciscodump --extcap-interface=ciscodump --extcap-config
 ciscodump --extcap-interface=ciscodump --remote-host myhost --remote-port 22222 --remote-username myuser --remote-interface gigabit0/0 --fifo=FILENAME --capture

# 4. randpktdump
这个似乎也是一个网络抓包的
Wireshark - randpktdump v0.1.0
Usage:
 randpktdump --extcap-interfaces
 randpktdump --extcap-interface=randpkt --extcap-dlts
 randpktdump --extcap-interface=randpkt --extcap-config
 randpktdump --extcap-interface=randpkt --type dns --count 10 --fifo=FILENAME --capture

# 5. sshdump
这个应该是对ssh进行抓包的
Wireshark - sshdump v1.0.0
Usage:
 sshdump --extcap-interfaces
 sshdump --extcap-interface=sshdump --extcap-dlts
 sshdump --extcap-interface=sshdump --extcap-config
 sshdump --extcap-interface=sshdump --remote-host myhost --remote-port 22222 --remote-username myuser --remote-interface eth2 --remote-capture-command 'tcpdump -U -i eth0 -w -' --fifo=FILENAME --capture

# 6. idl2wrs
# 7. mergecap 合并多个抓包文件
mergecap -w output.pcap input1.pcap input2.pcap input3.pcap
# 8. mmdbresolve
# 9. randpkt
# 10. rawshark
# 11. reordercap

Reordercap (Wireshark) 3.6.1 (v3.6.1-0-ga0a473c7c1ba)
Reorder timestamps of input file frames into output file.
See https://www.wireshark.org for more information.
Usage: reordercap [options] <infile> <outfile>
Options:
  -n        don't write to output file if the input file is ordered.
  -h        display this help and exit.
  -v        print version information and exit.

# 12. sharkd

Usage: sharkd [<classic_options>|<gold_options>]
Classic (classic_options):
  [-|<socket>]
  <socket> examples:
  - unix:/tmp/sharkd.sock - listen on unix file /tmp/sharkd.sock
Gold (gold_options):
  -a <socket>, --api <socket>
                           listen on this socket
  -h, --help               show this help information
  -v, --version            show version information
  -C <config profile>, --config-profile <config profile>
                           start with specified configuration profile
  Examples:
    sharkd -C myprofile
    sharkd -a tcp:127.0.0.1:4446 -C myprofile
See the sharkd page of the Wireshark wiki for full details.

# 13. text2pcap

Text2pcap (Wireshark) 3.6.1 (v3.6.1-0-ga0a473c7c1ba)
Generate a capture file from an ASCII hexdump of packets.
See https://www.wireshark.org for more information.
Usage: text2pcap [options] <infile> <outfile>
where  <infile> specifies input  filename (use - for standard input)
      <outfile> specifies output filename (use - for standard output)
# 14. tshark
命令行版本的wireshark, 用的最多的
TShark (Wireshark) 3.6.1 (v3.6.1-0-ga0a473c7c1ba)
Dump and analyze network traffic.
See https://www.wireshark.org for more information.

# 15. udpdump

Wireshark - udpdump v0.1.0
Usage:
 udpdump --extcap-interfaces
 udpdump --extcap-interface=udpdump --extcap-dlts
 udpdump --extcap-interface=udpdump --extcap-config
 udpdump --extcap-interface=udpdump --port 5555 --fifo myfifo --capture
Options:
  --extcap-interfaces: list the extcap Interfaces
  --extcap-dlts: list the DLTs
  --extcap-interface <iface>: specify the extcap interface
  --extcap-config: list the additional configuration for an interface
  --capture: run the capture
  --extcap-capture-filter <filter>: the capture filter
  --fifo <file>: dump data to file or fifo
  --extcap-version: print tool version
  --debug: print additional messages
  --debug-file: print debug messages to file
  --help: print this help
  --version: print the version
  --port <port>: the port to listens on. Default: 5555

# 16. capinfos
打印出包的各种信息
Capinfos (Wireshark) 3.6.1 (v3.6.1-0-ga0a473c7c1ba)
Print various information (infos) about capture files.
See https://www.wireshark.org for more information.
Usage: capinfos [options] <infile> ...
General infos:
  -t display the capture file type
  -E display the capture file encapsulation
  -I display the capture file interface information
  -F display additional capture file information
  -H display the SHA256, RIPEMD160, and SHA1 hashes of the file
  -k display the capture comment

# 17. captype
Captype (Wireshark) 3.6.1 (v3.6.1-0-ga0a473c7c1ba)
Print the file types of capture files.

# 18. dftest
➜  ~ dftest --help

Filter: --help

# 19. dumpcap
See https://www.wireshark.org for more information.

