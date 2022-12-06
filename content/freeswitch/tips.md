---
title: "FS常用运维手册"
date: 2022-05-28T14:54:40+08:00
draft: false
tags:
- FreeSWITCH
---

# 安装单个模块

```
make mod_sofia-install
make mod_ilbc-install
```

# fs-cli事件订阅

```
/event plain ALL
/event plain CHANNEL_ANSWER
```

# sofia 帮助文档

```
sofia help


USAGE:
--------------------------------------------------------------------------------
sofia global siptrace <on|off>
sofia        capture  <on|off>
             watchdog <on|off>

sofia profile <name> [start | stop | restart | rescan] [wait]
                     flush_inbound_reg [<call_id> | <[user]@domain>] [reboot]
                     check_sync [<call_id> | <[user]@domain>]
                     [register | unregister] [<gateway name> | all]
                     killgw <gateway name>
                     [stun-auto-disable | stun-enabled] [true | false]]
                     siptrace <on|off>
                     capture  <on|off>
                     watchdog <on|off>

sofia <status|xmlstatus> profile <name> [reg [<contact str>]] | [pres <pres str>] | [user <user@domain>]
sofia <status|xmlstatus> gateway <name>

sofia loglevel <all|default|tport|iptsec|nea|nta|nth_client|nth_server|nua|soa|sresolv|stun> [0-9]
sofia tracelevel <console|alert|crit|err|warning|notice|info|debug>

sofia help
--------------------------------------------------------------------------------
```

# 开启消息头压缩

```
<param name="enable-compact-headers" value="true"/>
```

fs需要重启

# 呼叫相关指令

```
# 显示当前呼叫
show calls

# 显示呼叫数量
show calls count

# 挂断某个呼叫
uuid_kill 58579bd2-db78-4c7e-a666-0f16e19be643

# 挂断所有呼叫
hupall

# sip抓包
sofia profile internal siptrace on
sofia profile external siptrace on

# 拨打某个用户并启用echo回音
originate user/1000 &echo
```

# 正则测试

在fs_cli里面可以用regex快速测试正则是否符合预期结果

```
regex 123123 | \d
regex 123123 | ^\d*
```

# 变量求值

```
eval $${mod_dir}
eval $${recording_dir}
```

# 修改UA信息

- sofia_external.conf.xml
- sofia_internal.conf.xml

```
<param name="user-agent-string" value="wdd"/>
<param name="username" value="wdd"/>
```

修改之后需要rescan profile.

# mod_distributor的两个常用指令

```
# reload
distributor_ctl reload

# 求值
eval ${distributor(distributor_list)}
```

# 自动接听回音测试

```
<extension name="wdd_echo">
       <condition field="destination_number" expression="^8002">
         <action application="info" data=""></action>
         <action application="answer" data=""></action>
         <action application="echo" data=""></action>
       </condition>
</extension>
```

# odbc-dsn配置错误，fs进入假死状态

最近遇到一个奇怪的问题，相同的fs镜像，在一个环境正常运行，但是再进入另一个环境的时候，fs进程运行起来了，但是所有的功能都异常，仿佛进入了假死状态。并且控制台的日志输出也没有什么有用的信息。

后来，我想起来以前曾经遇到过这个问题。

这个fs的镜像中没有编译odbc相关的依赖，但是看sofia_external.conf.xml和sofia_internal.conf.xml, 却有odbc相关的配置。

```
<param name="odbc-dsn" value="....">
```

所以只要把这个odbc-dsn的配置注释掉，fs就正常运行了。

# 取消session-timer

某些情况下fs会对呼入的电话，在通过时长达到1分钟的时候，向对端发送一个re-invite, 实际上这还是一个invite请求，只是to字段有了tag参数。这个机制叫做session-timer, 具体定义在RFC4028中。

但是某些SIP终端可能不支持re-invite, 然后不对这个re-invite做回应，或者回应了一个错误的状态码，都会导致这通呼叫异常挂断。

在internal.xml中修改如下行：

```
<param name="enable-timer" value="false"/>
```

# RTP失活超时检测

某个时刻开始，客户端无法再向FS发送流媒体了。例如客户端Web页面关闭，或者浏览器关闭。

但是在这种场景下，FS还是会向客户端发送一段时间的媒体流，然后再发送BYE消息。那么，我们如何控制这个RTP失活的检测时间呢？

在internal.xml或者external.xml中，有以下参数，可以控制检测RTP超时时间。

- rtp-timeout-sec  rtp超时秒数
- rtp-hold-timeout-sec rtphold超时秒数

```
<param name="rtp-timeout-sec" value="10"/>
<param name="rtp-hold-timeout-sec" value="10"/>
```

sofia profile internal restart

# fs 配置多租户分机

分机的相关配置都是位于conf/directory目录中,  我的directory目录中只有一个default.xml文件

```
<include>
     <domain name="123.cc">
         <user id="1000">
             <params>
                 <param name="password" value="1234"/>
             </params>
         </user>
         <user id="1001">
             <params>
                 <param name="password" value="1234"/>
             </params>
         </user>
     </domain>
 
     <domain name="abc.cc">
         <user id="1000">
             <params>
                 <param name="password" value="1234"/>                                                                                                                                        
             </params>
         </user>
         <user id="1001">
             <params>
                 <param name="password" value="1234"/>
             </params>
         </user>
     </domain>
 </include>
```

# fs状态转移图

![](/images/fs-channel-state.png)

