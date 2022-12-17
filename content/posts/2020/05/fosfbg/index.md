---
title: "从pcap文件提取转wav语音文件"
date: "2020-05-01 09:36:26"
draft: false
---
wireshark具有这个功能，但是并不适合做批量执行。

下面的方案比较适合批量执行。

```c
# 1. 安装依赖
yum install gcc libpcap-devel libnet-devel sox -y

# 2. 克隆源码
git clone https://github.com/wangduanduan/rtpsplit.git

# 3. 切换目录
cd rtpsplit

# 4. 编译可执行文件
make

# 5. 将可执行文件复制到/usr/local/bin目录下
cp src/rtpbreak /usr/local/bin

# 6. 切换到录音文件的目录，假如当前目录只有一个文件
rtpbreak -r krk9hprvin1u1laqe14g-8beffe8aaeb9bf99.pcap -g -m -d ./
    
  audio git:(edge) ✗ rtpbreak -r krk9hprvin1u1laqe14g-8beffe8aaeb9bf99.pcap -g -m -d ./
 + rtpbreak v1.3a running here!
 + pid: 1885, date/time: 01/05/2020#09:49:05
 + Configuration
   + INPUT
     Packet source: rxfile 'krk9hprvin1u1laqe14g-8beffe8aaeb9bf99.pcap'
     Force datalink header length: disabled
   + OUTPUT
     Output directory: './'
     RTP raw dumps: enabled
     RTP pcap dumps: enabled
     Fill gaps: enabled
     Dump noise: disabled
     Logfile: './/rtp.0.txt'
     Logging to stdout: enabled
     Logging to syslog: disabled
     Be verbose: disabled
   + SELECT
     Sniff packets in promisc mode: enabled
     Add pcap filter: disabled
     Expecting even destination UDP port: disabled
     Expecting unprivileged source/destination UDP ports: disabled
     Expecting RTP payload type: any
     Expecting RTP payload length: any
     Packet timeout: 10.00 seconds
     Pattern timeout: 0.25 seconds
     Pattern packets: 5
   + EXECUTION
     Running as user/group: root/root
     Running daemonized: disabled
 * You can dump stats sending me a SIGUSR2 signal
 * Reading packets...
open di .//rtp.0.0.txt
 ! [rtp0] detected: pt=0(g711U) 192.168.40.192:26396 => 192.168.60.229:20000
open di .//rtp.0.1.txt
 ! [rtp1] detected: pt=0(g711U) 10.197.169.10:49265 => 192.168.60.229:20012
 * eof reached.
--
Caught SIGTERM signal (15), cleaning up...
--
 * [rtp1] closed: packets inbuffer=0 flushed=285 lost=0(0.00%), call_length=0m12s
 * [rtp0] closed: packets inbuffer=0 flushed=586 lost=0(0.00%), call_length=0m12s
 + Status
   Alive RTP Sessions: 0
   Closed RTP Sessions: 2
   Detected RTP Sessions: 2
   Flushed RTP packets: 871
   Lost RTP packets: 0 (0.00%)
   Noise (false positive) packets: 8
 + No active RTP streams
 
 # 7. 查看输出文件
 -rw-r--r--. 1 root root 185K May  1 09:22 krk9hprvin1u1laqe14g-8beffe8aaeb9bf99.pcap
-rw-r--r--. 1 root root 132K May  1 09:49 rtp.0.0.pcap
-rw-r--r--. 1 root root  92K May  1 09:49 rtp.0.0.raw
-rw-r--r--. 1 root root  412 May  1 09:49 rtp.0.0.txt
-rw-r--r--. 1 root root  52K May  1 09:49 rtp.0.1.pcap
-rw-r--r--. 1 root root  33K May  1 09:49 rtp.0.1.raw
-rw-r--r--. 1 root root  435 May  1 09:49 rtp.0.1.txt
-rw-r--r--. 1 root root 1.7K May  1 09:49 rtp.0.txt

# 8. 使用sox 转码以及合成wav文件
sox -r8000 -c1 -t ul rtp.0.0.raw -t wav 0.wav
sox -r8000 -c1 -t ul rtp.0.1.raw -t wav 1.wav
sox -m 0.wav 1.wav call.wav

# 最终合成的 call.wav文件，就是可以放到浏览器中播放的双声道语音文件
```



# 参考

## rtpbreak帮助文档
```c
Copyright (c) 2007-2008 Dallachiesa Michele <micheleDOTdallachiesaATposteDOTit>
rtpbreak v1.3a is free software, covered by the GNU General Public License.

USAGE: rtpbreak (-r|-i) <source> [options]

 INPUT

  -r <str>      Read packets from pcap file <str>
  -i <str>      Read packets from network interface <str>
  -L <int>      Force datalink header length == <int> bytes

 OUTPUT

  -d <str>      Set output directory to <str> (def:.)
  -w            Disable RTP raw dumps
  -W            Disable RTP pcap dumps
  -g            Fill gaps in RTP raw dumps (caused by lost packets)
  -n            Dump noise packets
  -f            Disable stdout logging
  -F            Enable syslog logging
  -v            Be verbose

 SELECT

  -m            Sniff packets in promisc mode
  -p <str>      Add pcap filter <str>
  -e            Expect even destination UDP port
  -u            Expect unprivileged source/destination UDP ports (>1024)
  -y <int>      Expect RTP payload type == <int>
  -l <int>      Expect RTP payload length == <int> bytes
  -t <float>    Set packet timeout to <float> seconds (def:10.00)
  -T <float>    Set pattern timeout to <float> seconds (def:0.25)
  -P <int>      Set pattern packets count to <int> (def:5)

 EXECUTION

  -Z <str>      Run as user <str>
  -D            Run in background (option -f implicit)

 MISC

  -k            List known RTP payload types
  -h            This
```

