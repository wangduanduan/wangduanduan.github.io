---
title: "tshark 快速分析语音流问题"
date: "2022-03-08 11:02:18"
draft: false
---
wireshark安装之后，tshark也会自动安装。tshark也可以单独安装。

如果我们想快速的分析语音刘相关的问题，可以参考下面的一个命令。

语音卡顿，常见的原因就是网络丢包，tshark在命令行中快速输出语音流的丢包率。

如下所示，rtp的丢包率分别是2.5%和4.6%。
```
tshark -r abc.pcap -q -z rtp,streams
========================= RTP Streams ========================
   Start time      End time     Src IP addr  Port    Dest IP addr  Port       SSRC          Payload  Pkts         Lost   Min Delta(ms)  Mean Delta(ms)   Max Delta(ms)  Min Jitter(ms) Mean Jitter(ms)  Max Jitter(ms) Problems?
     2.666034     60.446026    192.168.69.12 18892   192.168.68.111 26772 0x76EFFF66            g711A  2807    72 (2.5%)           0.011          20.592         120.002           0.001           0.074           2.430 X
     0.548952     60.467686   192.168.68.111 26772    192.168.69.12 18892 0xA655E7B6            g711A  2215   106 (4.6%)           9.520          21.202         219.777           0.055           6.781         256.014 X
==============================================================
```

# tshark的-z参数
-z参数可以用来提取各种统计数据。

> -z  <statistics>
> 
>            Get TShark to collect various types of statistics and display the result after finishing reading the capture file. Use the -q option if you’re reading a capture file and only want the statistics printed, not any
>            per-packet information.
> 
>            Statistics are calculated independently of the normal per-packet output, unaffected by the main display filter. However, most have their own optional filter parameter, and only packets that match that filter (and any
>            capture filter or read filter) will be used in the calculations.
> 
>            Note that the -z proto option is different - it doesn’t cause statistics to be gathered and printed when the capture is complete, it modifies the regular packet summary output to include the values of fields specified
>            with the option. Therefore you must not use the -q option, as that option would suppress the printing of the regular packet summary output, and must also not use the -V option, as that would cause packet detail
>            information rather than packet summary information to be printed.


tshark -z help可以打
```
tshark -z help

```
常用的

-z conv,tcp<br />-z conv,ip<br />-z conv,udp<br />-z endpoints,type[,filter]<br />-z expert,sip<br />-z sip,stat<br />-z ip_hosts,tree<br />-z rtp,streams

