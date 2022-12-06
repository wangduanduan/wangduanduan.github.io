---
title: "配置文件"
date: "2019-06-13 22:10:45"
draft: false
---


# 脚本预处理

如果你的opensips.cfg文件不大，可以写成一个文件。否则建议使用include_file引入配置文件。

```bash
include_file "global.cfg"
```

有些配置，建议使用m4宏处理。


# 脚本结构

```bash
####### Global Parameters #########
   debug=3
   log_stderror=no
   fork=yes
   children=4
   listen=udp:127.0.0.1:5060
####### Modules Section ########
   mpath="/usr/local/lib/opensips/modules/"
   loadmodule "signaling.so"
   loadmodule "sl.so"
   loadmodule "tm.so"
   loadmodule "rr.so"
   loadmodule "uri.so"
   loadmodule "sipmsgops.so"
   modparam("rr", "append_fromtag", 0)
####### Routing Logic ########
route{
     if ( has_totag() ) {
       loose_route();
       route(relay);
		}
     if ( from_uri!=myself && uri!=myself ) {
       send_reply("403","Rely forbidden");
       exit;
		}
     record_route();
     route(relay);
}
   
route[relay] {
     if (is_method("INVITE"))
       t_on_failure("missed_call");
		t_relay();
		exit; 
}
failure_route[missed_call] {
     if (t_check_status("486")) {
       $rd = "127.0.0.10";
		t_relay(); }
}
```

脚本一般由三个部分组成：

1. 全局参数配置
2. 模块加载与参数配置
3. 路由逻辑


# 全局参数配置

```bash
debug=2 # log level 2 (NOTICE) debug值越大，日志越详细
log_stderror=0 #log to syslog
log_facility=LOG_LOCAL0
log_name="sbc"

listen=udp:127.0.0.1:5060
listen=tcp:192.168.1.5:5060 as 10.10.1.10:5060
listen=tls:192.168.1.5:5061
advertised_address=7.7.7.7 #global option, for all listeners

```


# 模块加载与参数配置

按照绝对路径加载模块

```bash
loadmodules "/lib/opensips/modules/rr.so"
loadmodules "/lib/opensips/modules/tm.so"
```


统一前缀加载模块

```bash
mpath="/lib/opensips/modules/"
loadmodules "rr.so"
loadmodules "tm.so"
```


