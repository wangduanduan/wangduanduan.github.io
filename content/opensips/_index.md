---
title: OpenSIPS2.4.X 中文实战系列
linktitle: Opensips
description: OpenSIPS VOIP
toc: true
---

本系列文章是我在学习 OpenSIPS 过程中，慢慢总结出来的。虽说是实战，但是笔记的成分可能会多点，我也无法保证里面的内容是否完全正确。

VOIP 对我来说是个比较陌生的领域。进入这个领域可以说是一个意外。在学习过程和实战过程中，我发现了 VOIP 有很大的复杂性。生产环境也会有常常有怪异棘手的各种问题。在解决这些问题的过程中，有种升级打怪的感觉。

本知识库重点在于讲解 OpenSIPS，当然其中也涵盖了 SIP 协议，FreeSWITCH, rtpproxy, rtpengine，以及一些排查问题的工具。

推荐在学习的过程中，一定要啃一遍 RFC 3261 协议，这是 VOIP 的基石。

QQ学习交流群：
![](2022-12-03-20-58-09.png)

# 文章目录

-   1: SIP 协议

    -   [1.1 学习建议](/opensips/ch1/study-tips)
    -   [1.2 SIP 协议简介](/opensips/ch1/sip-overview)
    -   [1.3 Via route Record-Route 的区别](ch1/via-route-record-route)
    -   [1.4 SIP Path 头](/opensips/ch1/sip-path)
    -   [1.5 Trunk PBX Gateway](/opensips/ch1/trunk-pbx-gateway)
    -   [1.6 SIP 协议拾遗补缺](/opensips/ch1/sip-notes)
    -   [1.7 SIP 与 SDP 的关系](/opensips/ch1/sip-with-sdp)
    -   [1.8 SIP 信令和媒体都绕不开的 NAT 问题](/opensips/ch1/nat-sip-rtp)
    -   [1.9 STUN 协议笔记](/opensips/ch1/stun-notes)
    -   [1.10 SIP 注册调研](/opensips/ch1/sip-register)
    -   [1.11 深入 SIP ACK 消息](/opensips/ch1/sip-ack)
    -   [1.12 UA 应答模式](/opensips/ch1/ua-answer-mode)
    -   [1.13 NAT 深入学习](/opensips/ch1/deep-in-nat)
    -   [1.14 解决 NAT 问题](/opensips/ch1/fix-nat)
    -   [1.15 From To Request URL 之间的关系](/opensips/ch1/from-to-request-url)
    -   [1.16 SIP 相关 RFC 协议](/opensips/ch1/sip-rfcs)
    -   [1.17 漫话 NAT 的历史](/opensips/ch1/story-of-nat)
    -   [1.18 媒体协商 offer/answer 模型](/opensips/ch1/offer-answer)
    -   [1.19 媒体路径与信令路径](/opensips/ch1/sip-rtp-path)
    -   [1.20 CSTA 呼叫模型简介](/opensips/ch1/csta-call-model)
-  2. 常识
    -   [2.1 几种常用电话信号音的含义](/opensips/ch2/early-media-type)
    -   [2.2 回铃音](/opensips/ch2/early-media)

-  3. OpenSIPS安装与管理
    - [3.1 opensips介绍](/opensips/ch3/about-opensips)
    - [3.2 debian jessie opensips 2.4.7 安装](/opensips/ch3/install-opensips)
    - [3.3 centos7 安装opensips](/opensips/ch3/centos-install)
    - [3.4 设置独立日志文件](/opensips/ch3/log)
    - [3.5 核心MI命令](/opensips/ch3/core-mi)
    - [3.6 opensips管理命令](/opensips/ch3/opensipsctl)
    - [3.7 centos7 2.2 升级到2.4.6](/opensips/ch3/centos7-2.4/)
    - [3.8 OpenSIPS监控](/opensips/ch3/opensips-monitor/)
    - [3.9 模块缓存策略与reload方法](/opensips/ch3/cache-reload/)
    - [3.10 SIP消息格式CRLF](/opensips/ch3/sip-crlf/)
    - [3.10 opensips日志写入elasticsearch](/opensips/ch3/elk/)
    - [3.10 生产环境监控告警](/opensips/ch3/prd-warning/)

- 4. 媒体相关
  - [4.1 RTP 不连续的timestamp和SSRC](/opensips/ch4/rtp-timestamp/)
  - [4.2 常见媒体流编码及其特点](/opensips/ch4/media-codec/)
  - [4.2 rtpproxy录音](/opensips/ch4/rtp-record/)
  - [4.2 rtp编码表](/opensips/ch4/codec-table/)

- 5. 配置文件和路由脚本
  - [5.1 配置文件](/opensips/ch5/routing-script/)
  - [5.2 全局参数配置](/opensips/ch5/global-params/)
  - [5.3 路由分类](/opensips/ch5/routing-type/)
  - [5.4 路由的触发时机](/opensips/ch5/triger-time/)
  - [5.5 严格路由和松散路由](/opensipsch5/strict-loose-routing/)
  - [5.6 函数特点](/opensips/ch5/function/)
  - [5.7 使用return语句减少逻辑嵌套](/opensips/ch5/return/)
  - [5.8 条件语句特点](/opensips/ch5/condition/)
  - [5.9 常用语句](/opensips/ch5/statement/)
  - [5.10 变量的使用](/opensips/ch5/var/)
  - [5.11 核心变量说明](/opensips/ch5/core-var/)
  - [5.12 优雅的使用xlog输出日志行](/opensips/ch5/xlog/)
  - [5.13 脚本路由模块化](/opensips/ch5/module/)
  - [5.14 有状态和无状态路由](/opensips/ch5/stateful-stateless/)
  - [5.15 【重点】初始化请求和序列化请求](/opensips/ch5/init-seque/)
  - [5.16 SIP路由头](/opensips/ch5/via-route/)
  - [5.17 avp_db_query数值null值比较](/opensips/ch5/avp-db-query/)
  - [5.18 日志xlog](/opensips/ch5/xlog-level/)
  - [5.19 opensips 集成 homer6](/opensips/ch5/homer6/)
  - [5.20 【必读】深入对外公布地址](/opensips/ch5/adv-address/)
  - [5.21 使用m4增强opensips.cfg脚本预处理能力](/opensips/ch5/m4/)
  - [5.22 db_mode调优](/opensips/ch5/db-mode/)
  - [5.23 mysql建表语句](/opensips/ch5/sql-table/)
  - [5.24 核心变量解读2-100%](/opensips/ch5/core-var-2/)

- 6. 模块使用教程
  - [6.1 acc呼叫记录模块](/opensips/ch6/acc/)
  - [6.2 cachedb的相关问题](/opensips/ch6/cachedb/)
  - [6.3 负载均衡模块load_balance](/opensips/ch6/load-balance/)
  - [6.4 sip消息分发之dispatcher模块](/opensips/ch6/dispatcher/)

- 7. 常见问题
  - [7.1 opensips 477 Send failed (477/TM)](/opensips/ch7/tm-send-failed/)
  - [7.2 sendmsg failed on 0: Socket operation on non-socket](/opensips/ch7/sendmsg-failed/)
  - [7.3 信令路径逃逸分析](/opensips/ch7/escape-msg/)
  - [7.4 opensips崩溃分析](/opensips/ch7/crash/)
  - [7.5 opensips无法启动](/opensips/ch7/can-not-run/)
  - [7.6 UDP分片导致SIP消息丢失](/opensips/ch7/big-udp-msg/)
  - [7.7 奥科网关 Rtp Broken Connection](/opensips/ch7/rtp-broken-connection)
  - [7.8 ACK 无法正常送到FS](/opensips/ch7/miss-ack/)
  - [7.9 30秒自动挂断](/opensips/ch7/30-seconds-drop/)
  - [7.10 script_trace 打印opensips的脚本执行过程](/opensips/ch7/cfg-trace/)
  - [7.11 一方听不到另外一方的声音](/opensips/ch7/one-leg-audio/)
  - [7.12 回音问题调研](/opensips/ch7/echo-back/)
  - [7.13 opensips启动失败没有任何报错日志](/opensips/ch7/without-log/)
  - [7.14 通话质量差](/opensips/ch7/poor-quality/)
  - [7.15 ERROR:carrierroute:carrier_tree_fixup: default_carrier not found](/opensips/ch7/without-default-carrier/)

- 8. 脚本学习
  - [8.1 拓扑隐藏学习以及实践](/opensips/ch8/topology-hiding/)
  - [8.2 serial_183](/opensips/ch8/serial-183/)
  - [8.3 replicate](/opensips/ch8/replicate/)
  - [8.4 redirect](/opensips/ch8/redirect/)
  - [8.5 pstn](/opensips/ch8/pstn/)
  - [8.6 nathelper](/opensips/ch8/nathelper/)
  - [8.7 msilo](/opensips/ch8/msilo/)
  - [8.8 logging](/opensips/ch8/logging/)
  - [8.9 httpd](/opensips/ch8/httpd/)
  - [8.10 fork](/opensips/ch8/fork/)
  - [8.11 flag reply](/opensips/ch8/flag-reply/)
  - [8.12 exec](/opensips/ch8/exec/)
  - [8.13 acc](/opensips/ch8/acc/)
  - [8.14 acc-mysql](/opensips/ch8/acc-mysql/)
  - [8.15 default](/opensips/ch8/default/)
  - [8.16 mid register](/opensips/ch8/mid-register/)
  - [8.17 fs loadbalance](/opensips/ch8/fs-loadbalance/)
  - [8.18 fraud](/opensips/ch8/fraud/)
  - [8.19 dtmf](/opensips/ch8/dtmf-lan/)
  - [8.20 siprec](/opensips/ch8/siprec/)

- 9. 扩展
  - [9.1 WebRTC学习资料分享](/opensips/ch9/webrtc-ref/)
  - [9.2 WebRTC简介](/opensips/ch9/notes/)
  - [9.3 opensips with webrtc](/opensips/ch9/webrtc-pdf/)
  - [9.4 BLF指示灯](/opensips/ch9/blf/)
  - [9.5 ISUP SIP ISDN对照码表](/opensips/ch9/isup-sip-isdn/)
  - [9.6 rtpengine cli](/opensips/ch9/rtpengine-manu/)
  - [9.7 rtpengine 增加对ilbc编解码的支持](/opensips/ch9/rtpengine-ilbc/)
  - [9.8 sdp协议简介](/opensips/ch9/sdp/)
  - [9.9 rtpproxy学习](/opensips/ch9/rtpproxy/)
  - [9.10 SIP feature codes SIP功能码](/opensips/ch9/feature-code/)
  - [9.11 sbc 100rel](/opensips/ch9/100-rel/)
  - [9.12 blf 功能笔记](/opensips/ch9/blf-note/)
  - [9.13 NAT场景下的信令处理 - 单网卡](/opensips/ch9/nat-single-interface/)
  - [9.14 集群共享分机注册信息](/opensips/ch9/cluster-share-location/)
  - [9.15 参考资料与书籍](/opensips/ch9/books/)

- 10. 相关工具
  - [10.1 tshark 快速分析语音流问题](/opensips/tools/tshark/)
  - [10.2 heplify SIP信令抓包客户端](/opensips/tools/heplify/)
  - [10.3 baresip 非常好用的终端SIP UA](/opensips/tools/baresip/)
  - [10.4 sipsak](/opensips/tools/sipsak/)
  - [10.5 wireshark 播放抓包文件](/opensips/tools/wireshark-player-pcap/)
  - [10.6 sngrep: 最好用的sip可视化抓包工具](/opensips/tools/sngrep/)
  - [10.7 homer: 统一的sip包集中处理工具](/opensips/tools/homer/)
  - [10.8 siphub 轻量级实时SIP信令收包的服务](/opensips/tools/siphub/)
  - [10.9 SIPp：sip压测模拟ua工具](/opensips/tools/sipp/)
  - [10.10 SIPP subscriber 测试](/opensips/tools/sipp-subscriber/)
  - [10.11 tcpdump](/opensips/tools/tcp-dump/)
  - [10.12 pjsip](/opensips/tools/pjsip/)
  - [10.13 Wireshark SIP 抓包](/opensips/tools/wireshark-sip/)
  - [10.14 另一个功能强大的sip server: kamailio](/opensips/tools/kamailio/)

- 11. 官方博客 

  - [Load Balancing in OpenSIPS](/opensips/blog/load-balance/)
  - [Dialog triggers, or how to control the calls from script](/opensips/blog/dialog-trigers/)
  - [Cross-dialog data accessing](/opensips/blog/cross-dialog-data/)
  - [Calls management using the new Call API tool](/opensips/blog/calls-manager/)
  - [Improved series-based call statistics using OpenSIPS 3.2](/opensips/blog/call-stat/)
  - [Exploring SSL/TLS libraries for OpenSIPS 3.2](/opensips/blog/opensips3-tls/)
  - [The OpenSIPS and OpenSSL journey](/opensips/blog/openssl-opensips/)
  - [SIP bridging over multiple interfaces](/opensips/blog/mutltiple-interface/)
  - [CANCEL请求和Reason头](/opensips/blog/cancel-reason/)
  - [Introducing OpenSIPS 3.0](/opensips/blog/opensips3x/)
  - [Clustered SIP User Location: The Full Sharing Topology](/opensips/blog/cluster-location/)
  - [Clustering ongoing calls with OpenSIPS 2.4](/opensips/blog/cluster-call/)
  - [Full Anycast support in OpenSIPS 2.4](/opensips/blog/full-anycast/)
  - [深入OpenSIPS统计引擎](/opensips/blog/deepin-stat-engine/)
  - [Running OpenSIPS in the Cloud](/opensips/blog/runing-opensips-in-cloud/)
  - [Troubleshooting OpenSIPS script](/opensips/blog/troubleshooting-opensips-script/)
  - [Troubleshooting missing ACK in SIP](/opensips/blog/miss-ack/)
  - [理解并测量OpenSIPS的内存资源](/opensips/blog/memory-usage/)

-   问题列表
    -   [utimer task <tm-utimer> already scheduled](/opensips/ch1/utime-task-scheduled)
- OpenSIPS 3X
  - [模块传参的重构](/opensips/3x/module-args/)
- [模块开发实战](/opensips/module-dev/)
- [OpenSIPS Summit PDF学习资料](/opensips/pdf/)
- [源码学习视频教程](/opensips/dev-audio/)

# 文章列表