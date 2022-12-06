---
title: "核心MI命令"
date: "2019-07-18 13:54:58"
draft: false
---
在所有的fifo命令中，which命令比较重要，因为它可以列出所有的其他命令。

有些mi命令是存在于各个模块之中，所以加载的模块不通。opensipsctl fifo which输出的命令也不通。

| 获取执行参数 | opensipsctl fifo arg |
| --- | --- |
| 列出TCP连接数量 | opensipsctl fifo list_tcp_conns |
| 查看进程信息 | opensipsctl fifo ps |
| 查看opensips运行时长 | opensipsctl fifo uptime |
| 查看所有支持的指令 | opensipsctl fifo which |
| 获取统计数据 | opensipsctl fifo get_statistics rcv_requests |
| 重置统计数据 | opensipsctl fifo get_statistics received_replies |
|  |  |

```bash
get_statistics
reset_statistics
uptime
version
pwd
arg
which
ps
kill
debug
cache_store
cache_fetch
cache_remove
event_subscribe
events_list
subscribers_list
list_tcp_conns
help
list_blacklists
regex_reload
t_uac_dlg
t_uac_cancel
t_hash
t_reply
ul_rm
ul_rm_contact
ul_dump
ul_flush
ul_add
ul_show_contact
ul_sync
domain_reload
domain_dump
dlg_list
dlg_list_ctx
dlg_end_dlg
dlg_db_sync
dlg_restore_db
profile_get_size
profile_list_dlgs
profile_get_values
list_all_profiles
nh_enable_ping
cr_reload_routes
cr_dump_routes
cr_replace_host
cr_deactivate_host
cr_activate_host
cr_add_host
cr_delete_host
dp_reload
dp_translate
address_reload
address_dump
subnet_dump
allow_uri
dr_reload
dr_gw_status
dr_carrier_status
lb_reload
lb_resize
lb_list
lb_status
httpd_list_root_path
sip_trace
rtpengine_enable
rtpengine_show
rtpengine_reload
teardown
```


