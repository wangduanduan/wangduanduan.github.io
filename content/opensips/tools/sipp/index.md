---
title: "SIPp：sip压测模拟ua工具"
date: "2019-09-04 12:47:07"
draft: false
---

# 安装
- SIPp 3.3

```bash
# 解压
tar -zxvf sipp-3.3.990.tar.gz

# centos 安装依赖
yum install lksctp-tools-devel libpcap-devel gcc-c++ gcc -y

# ubuntu 安装以来
apt-get install -y pkg-config dh-autoreconf ncurses-dev build-essential libssl-dev libpcap-dev libncurses5-dev libsctp-dev lksctp-tools

./configure --with-sctp --with-pcap
make && make install

sipp -v
SIPp v3.4-beta1 (aka v3.3.990)-SCTP-PCAP built Oct  6 2019, 20:12:17.

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License as
 published by the Free Software Foundation; either version 2 of
 the License, or (at your option) any later version.
```


# 附件
[sipp-3.3.990.tar.gz](https://www.yuque.com/attachments/yuque/0/2019/gz/280451/1570361385989-dc5d2db9-e445-4e47-bc4e-98dc3e755838.gz?_lake_card=%7B%22uid%22%3A%221570361384718-0%22%2C%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2019%2Fgz%2F280451%2F1570361385989-dc5d2db9-e445-4e47-bc4e-98dc3e755838.gz%22%2C%22name%22%3A%22sipp-3.3.990.tar.gz%22%2C%22size%22%3A422956%2C%22type%22%3A%22application%2Fx-gzip%22%2C%22ext%22%3A%22gz%22%2C%22progress%22%3A%7B%22percent%22%3A0%7D%2C%22status%22%3A%22done%22%2C%22percent%22%3A0%2C%22id%22%3A%226Yf7Z%22%2C%22card%22%3A%22file%22%7D)


# 使用默认场景

## uas

```shell
sipp -sn uas -i 192.168.2.101
```

- -sn 表示使用默认场景文件
   - uas 作为sip服务器
   - uac 作为sip客户端
- -i 设置本地ip给Contact头


# demo场景
sipp模拟sip服务器，当收到invite之后，先返回100，然后返回183，然后返回500

首先我们将sipp内置的uas场景文件拿出来，基于这个场景文件做修改

1. 生成配置文件
```shell
sipp -sd uas > uas.xml
```

2. 编辑配置文件


3. 启动uas

```shell
sipp -sf uas.xml -i 192.168.40.77 -p 18627 -bg -skip_rlimit
```


# 帮助文档

```shell
Usage:

  sipp remote_host[:remote_port] [options]

  Available options:

   -v               : Display version and copyright information.

   -aa              : Enable automatic 200 OK answer for INFO, UPDATE and
                      NOTIFY messages.

   -auth_uri        : Force the value of the URI for authentication.
                      By default, the URI is composed of
                      remote_ip:remote_port.

   -au              : Set authorization username for authentication challenges.
                      Default is taken from -s argument

   -ap              : Set the password for authentication challenges. Default
                      is 'password'

   -base_cseq       : Start value of [cseq] for each call.

   -bg              : Launch SIPp in background mode.

   -bind_local      : Bind socket to local IP address, i.e. the local IP
                      address is used as the source IP address.  If SIPp runs
                      in server mode it will only listen on the local IP
                      address instead of all IP addresses.

   -buff_size       : Set the send and receive buffer size.

   -calldebug_file  : Set the name of the call debug file.

   -calldebug_overwrite: Overwrite the call debug file (default true).

   -cid_str         : Call ID string (default %u-%p@%s).  %u=call_number,
                      %s=ip_address, %p=process_number, %%=% (in any order).

   -ci              : Set the local control IP address

   -cp              : Set the local control port number. Default is 8888.

   -d               : Controls the length of calls. More precisely, this
                      controls the duration of 'pause' instructions in the
                      scenario, if they do not have a 'milliseconds' section.
                      Default value is 0 and default unit is milliseconds.

   -deadcall_wait   : How long the Call-ID and final status of calls should be
                      kept to improve message and error logs (default unit is
                      ms).

   -default_behaviors: Set the default behaviors that SIPp will use.  Possbile
                      values are:
                      - all	Use all default behaviors
                      - none	Use no default behaviors
                      - bye	Send byes for aborted calls
                      - abortunexp	Abort calls on unexpected messages
                      - pingreply	Reply to ping requests
                      If a behavior is prefaced with a -, then it is turned
                      off.  Example: all,-bye


   -error_file      : Set the name of the error log file.

   -error_overwrite : Overwrite the error log file (default true).

   -f               : Set the statistics report frequency on screen. Default is
                      1 and default unit is seconds.

   -fd              : Set the statistics dump log report frequency. Default is
                      60 and default unit is seconds.

   -i               : Set the local IP address for 'Contact:','Via:', and
                      'From:' headers. Default is primary host IP address.


   -inf             : Inject values from an external CSV file during calls into
                      the scenarios.
                      First line of this file say whether the data is to be
                      read in sequence (SEQUENTIAL), random (RANDOM), or user
                      (USER) order.
                      Each line corresponds to one call and has one or more
                      ';' delimited data fields. Those fields can be referred
                      as [field0], [field1], ... in the xml scenario file.
                      Several CSV files can be used simultaneously (syntax:
                      -inf f1.csv -inf f2.csv ...)

   -infindex        : file field
                      Create an index of file using field.  For example -inf
                      users.csv -infindex users.csv 0 creates an index on the
                      first key.

   -ip_field        : Set which field from the injection file contains the IP
                      address from which the client will send its messages.
                      If this option is omitted and the '-t ui' option is
                      present, then field 0 is assumed.
                      Use this option together with '-t ui'

   -l               : Set the maximum number of simultaneous calls. Once this
                      limit is reached, traffic is decreased until the number
                      of open calls goes down. Default:
                        (3 * call_duration (s) * rate).

   -log_file        : Set the name of the log actions log file.

   -log_overwrite   : Overwrite the log actions log file (default true).

   -lost            : Set the number of packets to lose by default (scenario
                      specifications override this value).

   -rtcheck         : Select the retransmisison detection method: full
                      (default) or loose.

   -m               : Stop the test and exit when 'calls' calls are processed

   -mi              : Set the local media IP address (default: local primary
                      host IP address)

   -master          : 3pcc extended mode: indicates the master number

   -max_recv_loops  : Set the maximum number of messages received read per
                      cycle. Increase this value for high traffic level.  The
                      default value is 1000.

   -max_sched_loops : Set the maximum number of calsl run per event loop.
                      Increase this value for high traffic level.  The default
                      value is 1000.

   -max_reconnect   : Set the the maximum number of reconnection.

   -max_retrans     : Maximum number of UDP retransmissions before call ends on
                      timeout.  Default is 5 for INVITE transactions and 7 for
                      others.

   -max_invite_retrans: Maximum number of UDP retransmissions for invite
                      transactions before call ends on timeout.

   -max_non_invite_retrans: Maximum number of UDP retransmissions for non-invite
                      transactions before call ends on timeout.

   -max_log_size    : What is the limit for error and message log file sizes.

   -max_socket      : Set the max number of sockets to open simultaneously.
                      This option is significant if you use one socket per
                      call. Once this limit is reached, traffic is distributed
                      over the sockets already opened. Default value is 50000

   -mb              : Set the RTP echo buffer size (default: 2048).

   -message_file    : Set the name of the message log file.

   -message_overwrite: Overwrite the message log file (default true).

   -mp              : Set the local RTP echo port number. Default is 6000.

   -nd              : No Default. Disable all default behavior of SIPp which
                      are the following:
                      - On UDP retransmission timeout, abort the call by
                        sending a BYE or a CANCEL
                      - On receive timeout with no ontimeout attribute, abort
                        the call by sending a BYE or a CANCEL
                      - On unexpected BYE send a 200 OK and close the call
                      - On unexpected CANCEL send a 200 OK and close the call
                      - On unexpected PING send a 200 OK and continue the call
                      - On any other unexpected message, abort the call by
                        sending a BYE or a CANCEL


   -nr              : Disable retransmission in UDP mode.

   -nostdin         : Disable stdin.


   -p               : Set the local port number.  Default is a random free port
                      chosen by the system.

   -pause_msg_ign   : Ignore the messages received during a pause defined in
                      the scenario

   -periodic_rtd    : Reset response time partition counters each logging
                      interval.

   -plugin          : Load a plugin.

   -r               : Set the call rate (in calls per seconds).  This value can
                      bechanged during test by pressing '+','_','*' or '/'.
                      Default is 10.
                      pressing '+' key to increase call rate by 1 *
                      rate_scale,
                      pressing '-' key to decrease call rate by 1 *
                      rate_scale,
                      pressing '*' key to increase call rate by 10 *
                      rate_scale,
                      pressing '/' key to decrease call rate by 10 *
                      rate_scale.
                      If the -rp option is used, the call rate is calculated
                      with the period in ms given by the user.

   -rp              : Specify the rate period for the call rate.  Default is 1
                      second and default unit is milliseconds.  This allows
                      you to have n calls every m milliseconds (by using -r n
                      -rp m).
                      Example: -r 7 -rp 2000 ==> 7 calls every 2 seconds.
                               -r 10 -rp 5s => 10 calls every 5 seconds.

   -rate_scale      : Control the units for the '+', '-', '*', and '/' keys.

   -rate_increase   : Specify the rate increase every -fd units (default is
                      seconds).  This allows you to increase the load for each
                      independent logging period.
                      Example: -rate_increase 10 -fd 10s
                        ==> increase calls by 10 every 10 seconds.

   -rate_max        : If -rate_increase is set, then quit after the rate
                      reaches this value.
                      Example: -rate_increase 10 -rate_max 100
                        ==> increase calls by 10 until 100 cps is hit.

   -no_rate_quit    : If -rate_increase is set, do not quit after the rate
                      reaches -rate_max.

   -recv_timeout    : Global receive timeout. Default unit is milliseconds. If
                      the expected message is not received, the call times out
                      and is aborted.

   -send_timeout    : Global send timeout. Default unit is milliseconds. If a
                      message is not sent (due to congestion), the call times
                      out and is aborted.

   -sleep           : How long to sleep for at startup. Default unit is
                      seconds.

   -reconnect_close : Should calls be closed on reconnect?

   -reconnect_sleep : How long (in milliseconds) to sleep between the close and
                      reconnect?

   -ringbuffer_files: How many error/message files should be kept after
                      rotation?

   -ringbuffer_size : How large should error/message files be before they get
                      rotated?

   -rsa             : Set the remote sending address to host:port for sending
                      the messages.

   -rtp_echo        : Enable RTP echo. RTP/UDP packets received on port defined
                      by -mp are echoed to their sender.
                      RTP/UDP packets coming on this port + 2 are also echoed
                      to their sender (used for sound and video echo).

   -rtt_freq        : freq is mandatory. Dump response times every freq calls
                      in the log file defined by -trace_rtt. Default value is
                      200.

   -s               : Set the username part of the resquest URI. Default is
                      'service'.

   -sd              : Dumps a default scenario (embeded in the sipp executable)

   -sf              : Loads an alternate xml scenario file.  To learn more
                      about XML scenario syntax, use the -sd option to dump
                      embedded scenarios. They contain all the necessary help.

   -shortmessage_file: Set the name of the short message log file.

   -shortmessage_overwrite: Overwrite the short message log file (default true).

   -oocsf           : Load out-of-call scenario.

   -oocsn           : Load out-of-call scenario.

   -skip_rlimit     : Do not perform rlimit tuning of file descriptor limits.
                      Default: false.

   -slave           : 3pcc extended mode: indicates the slave number

   -slave_cfg       : 3pcc extended mode: indicates the file where the master
                      and slave addresses are stored

   -sn              : Use a default scenario (embedded in the sipp executable).
                      If this option is omitted, the Standard SipStone UAC
                      scenario is loaded.
                      Available values in this version:

                      - 'uac'      : Standard SipStone UAC (default).
                      - 'uas'      : Simple UAS responder.
                      - 'regexp'   : Standard SipStone UAC - with regexp and
                        variables.
                      - 'branchc'  : Branching and conditional branching in
                        scenarios - client.
                      - 'branchs'  : Branching and conditional branching in
                        scenarios - server.

                      Default 3pcc scenarios (see -3pcc option):

                      - '3pcc-C-A' : Controller A side (must be started after
                        all other 3pcc scenarios)
                      - '3pcc-C-B' : Controller B side.
                      - '3pcc-A'   : A side.
                      - '3pcc-B'   : B side.


   -stat_delimiter  : Set the delimiter for the statistics file

   -stf             : Set the file name to use to dump statistics

   -t               : Set the transport mode:
                      - u1: UDP with one socket (default),
                      - un: UDP with one socket per call,
                      - ui: UDP with one socket per IP address The IP
                        addresses must be defined in the injection file.
                      - t1: TCP with one socket,
                      - tn: TCP with one socket per call,
                      - l1: TLS with one socket,
                      - ln: TLS with one socket per call,
                      - s1: SCTP with one socket (default),
                      - sn: SCTP with one socket per call,
                      - c1: u1 + compression (only if compression plugin
                        loaded),
                      - cn: un + compression (only if compression plugin
                        loaded).  This plugin is not provided with sipp.


   -timeout         : Global timeout. Default unit is seconds.  If this option
                      is set, SIPp quits after nb units (-timeout 20s quits
                      after 20 seconds).

   -timeout_error   : SIPp fails if the global timeout is reached is set
                      (-timeout option required).

   -timer_resol     : Set the timer resolution. Default unit is milliseconds.
                      This option has an impact on timers precision.Small
                      values allow more precise scheduling but impacts CPU
                      usage.If the compression is on, the value is set to
                      50ms. The default value is 10ms.

   -T2              : Global T2-timer in milli seconds

   -sendbuffer_warn : Produce warnings instead of errors on SendBuffer
                      failures.

   -trace_msg       : Displays sent and received SIP messages in <scenario file
                      name>_<pid>_messages.log

   -trace_shortmsg  : Displays sent and received SIP messages as CSV in
                      <scenario file name>_<pid>_shortmessages.log

   -trace_screen    : Dump statistic screens in the
                      <scenario_name>_<pid>_screens.log file when
                      quitting SIPp. Useful to get a final status report in
                      background mode (-bg option).

   -trace_err       : Trace all unexpected messages in <scenario file
                      name>_<pid>_errors.log.

   -trace_calldebug : Dumps debugging information about aborted calls to
                      <scenario_name>_<pid>_calldebug.log file.

   -trace_stat      : Dumps all statistics in <scenario_name>_<pid>.csv file.
                      Use the '-h stat' option for a detailed description of
                      the statistics file content.

   -trace_counts    : Dumps individual message counts in a CSV file.

   -trace_rtt       : Allow tracing of all response times in <scenario file
                      name>_<pid>_rtt.csv.

   -trace_logs      : Allow tracing of <log> actions in <scenario file
                      name>_<pid>_logs.log.

   -users           : Instead of starting calls at a fixed rate, begin 'users'
                      calls at startup, and keep the number of calls constant.

   -watchdog_interval: Set gap between watchdog timer firings.  Default is 400.

   -watchdog_reset  : If the watchdog timer has not fired in more than this
                      time period, then reset the max triggers counters.
                      Default is 10 minutes.

   -watchdog_minor_threshold: If it has been longer than this period between watchdog
                      executions count a minor trip.  Default is 500.

   -watchdog_major_threshold: If it has been longer than this period between watchdog
                      executions count a major trip.  Default is 3000.

   -watchdog_major_maxtriggers: How many times the major watchdog timer can be tripped
                      before the test is terminated.  Default is 10.

   -watchdog_minor_maxtriggers: How many times the minor watchdog timer can be tripped
                      before the test is terminated.  Default is 120.

   -tls_cert        : Set the name for TLS Certificate file. Default is
                      'cacert.pem

   -tls_key         : Set the name for TLS Private Key file. Default is
                      'cakey.pem'

   -tls_crl         : Set the name for Certificate Revocation List file. If not
                      specified, X509 CRL is not activated.

   -3pcc            : Launch the tool in 3pcc mode ("Third Party call
                      control"). The passed ip address is depending on the
                      3PCC role.
                      - When the first twin command is 'sendCmd' then this is
                        the address of the remote twin socket.  SIPp will try to
                        connect to this address:port to send the twin command
                        (This instance must be started after all other 3PCC
                        scenarii).
                          Example: 3PCC-C-A scenario.
                      - When the first twin command is 'recvCmd' then this is
                        the address of the local twin socket. SIPp will open
                        this address:port to listen for twin command.
                          Example: 3PCC-C-B scenario.

   -tdmmap          : Generate and handle a table of TDM circuits.
                      A circuit must be available for the call to be placed.
                      Format: -tdmmap {0-3}{99}{5-8}{1-31}

   -key             : keyword value
                      Set the generic parameter named "keyword" to "value".

   -set             : variable value
                      Set the global variable parameter named "variable" to
                      "value".

   -multihome       : Set multihome address for SCTP

   -heartbeat       : Set heartbeat interval in ms for SCTP

   -assocmaxret     : Set association max retransmit counter for SCTP

   -pathmaxret      : Set path max retransmit counter for SCTP

   -pmtu            : Set path MTU for SCTP

   -gracefulclose   : If true, SCTP association will be closed with SHUTDOWN
                      (default).
                       If false, SCTP association will be closed by ABORT.


   -dynamicStart    : variable value
                      Set the start offset of dynamic_id varaiable

   -dynamicMax      : variable value
                      Set the maximum of dynamic_id variable

   -dynamicStep     : variable value
                      Set the increment of dynamic_id variable

Signal handling:

   SIPp can be controlled using posix signals. The following signals
   are handled:
   USR1: Similar to press 'q' keyboard key. It triggers a soft exit
         of SIPp. No more new calls are placed and all ongoing calls
         are finished before SIPp exits.
         Example: kill -SIGUSR1 732
   USR2: Triggers a dump of all statistics screens in
         <scenario_name>_<pid>_screens.log file. Especially useful
         in background mode to know what the current status is.
         Example: kill -SIGUSR2 732

Exit code:

   Upon exit (on fatal error or when the number of asked calls (-m
   option) is reached, sipp exits with one of the following exit
   code:
    0: All calls were successful
    1: At least one call failed
   97: exit on internal command. Calls may have been processed
   99: Normal exit without calls processed
   -1: Fatal error
   -2: Fatal error binding a socket


Example:

   Run sipp with embedded server (uas) scenario:
     ./sipp -sn uas
   On the same host, run sipp with embedded client (uac) scenario
     ./sipp -sn uac 127.0.0.1
```



# 参考

- [http://sipp.sourceforge.net/doc/reference.html](http://sipp.sourceforge.net/doc/reference.html)
- [http://sipp.sourceforge.net/doc3.3/reference.html](http://sipp.sourceforge.net/doc3.3/reference.html)


# 实战脚本学习
下面的两个链接里面有很多的真实场景测试的xml文件，可以用来深入学习

- [https://github.com/pbertera/SIPp-by-example](https://github.com/pbertera/SIPp-by-example)
- [https://tomeko.net/other/sipp/sipp_cheatsheet.php?lang=pl](https://tomeko.net/other/sipp/sipp_cheatsheet.php?lang=pl)


# 中文教程

- [sippZhong Wen Jiao Cheng - Knight.pdf](https://www.yuque.com/attachments/yuque/0/2021/pdf/280451/1617863565582-87c4c364-817f-47c2-ad73-786197ab5ae6.pdf?_lake_card=%7B%22uid%22%3A%221617863557810-0%22%2C%22src%22%3A%22https%3A%2F%2Fwww.yuque.com%2Fattachments%2Fyuque%2F0%2F2021%2Fpdf%2F280451%2F1617863565582-87c4c364-817f-47c2-ad73-786197ab5ae6.pdf%22%2C%22name%22%3A%22sippZhong%20Wen%20Jiao%20Cheng%20-%20Knight.pdf%22%2C%22size%22%3A2779461%2C%22type%22%3A%22application%2Fpdf%22%2C%22ext%22%3A%22pdf%22%2C%22progress%22%3A%7B%22percent%22%3A99%7D%2C%22status%22%3A%22done%22%2C%22percent%22%3A0%2C%22id%22%3A%22zMfhf%22%2C%22card%22%3A%22file%22%7D) 黄龙舟翻译

