---
title: "opensips监控"
date: "2019-07-02 22:09:10"
draft: false
---
**opensipsctl fifo get_statistics all **命令可以获取所有统计数据，在所有统计数据中，我们只关心内存，事务和回话的数量。然后将数据使用curl工具写入到influxdb中。

**opensipsctl fifo reset_statistics all 重置统计数据**


# 常用指令

| 命令 | 描述 |
| --- | --- |
| opensipsctl fifo which | 显示所有可用命令 |
| opensipsctl fifo ps | 显示所有进程 |
| opensipsctl fifo get_statistics all | 获取所有统计信息 |
| opensipsctl fifo get_statistics core: | 获取内核统计信息 |
| opensipsctl fifo get_statistics net: | 获取网路统计信息 |
| opensipsctl fifo get_statistics pkmem: | 获取私有内存相关信息 |
| opensipsctl fifo get_statistics tm: | 获取事务模块统计信息 |
| opensipsctl fifo get_statistics sl: | 获取sl模块统计信息 |
| opensipsctl fifo get statistics shmem: | 获取共享内存相关信息 |
| opensipsctl fifo get statistics usrloc: | 获取 |
| opensipsctl fifo get statistics registrar: | 获取注册统计信息 |
| opensipsctl fifo get statistics uri: | 获取uri统计信息 |
| opensipsctl fifo get statistics load: | 获取负载信息 |
| opensipsctl fifo reset_statistics all | 重置所有统计信息 |




```sql
shmem:total_size:: 6467616768
shmem:used_size:: 4578374040
shmem:real_used_size:: 4728909408
shmem:max_used_size:: 4728909408
shmem:free_size:: 1738707360
shmem:fragments:: 1

# 事务
tm:UAS_transactions:: 296337
tm:UAC_transactions:: 30
tm:2xx_transactions:: 174737
tm:3xx_transactions:: 0
tm:4xx_transactions:: 110571
tm:5xx_transactions:: 2170
tm:6xx_transactions:: 0
tm:inuse_transactions:: 289651


dialog:active_dialogs:: 156
dialog:early_dialogs:: 680
dialog:processed_dialogs:: 104061
dialog:expired_dialogs:: 964
dialog:failed_dialogs:: 78457
dialog:create_sent:: 0
dialog:update_sent:: 0
dialog:delete_sent:: 0
dialog:create_recv:: 0
dialog:update_recv:: 0
dialog:delete_recv:: 0
```



```bash
CONF_DB_URL="ip:port" # influxdb地址
CONF_DB_NAME="dbname" # influxdb数据库名
CONF_OPENSIPS_ROLE="a" # 角色，随便写个字符串

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"

LOCAL_IP=`ip route get 8.8.8.8 | head -n +1 | tr -s " " | cut -d " " -f 7`

MSG=`opensipsctl fifo get_statistics all | grep -E "tm:|shmem:|dialog" | awk -F ':: ' 'BEGIN{OFS="=";ORS=","} {print $1,$2}' | sed 's/[-:.]/_/g'`
MSG=${MSG:0:${#MSG}-1}
echo $MSG
influxdb="http://$CONF_DB_URL/write?db=$CONF_DB_NAME"

curl -i -XPOST $influxdb  --data-binary "opensips,type=$CONF_OPENSIPS_ROLE,ip=$LOCAL_IP $MSG"
```

shmem:total_size:: 33554432<br />shmem:used_size:: 2910624<br />**shmem:real_used_size:: 3722856**<br />shmem:max_used_size:: 21963544<br />shmem:free_size:: 29831576<br />shmem:fragments:: 30761<br />**core:rcv_requests:: 1625972**<br />core:rcv_replies:: 580098<br />core:fwd_requests:: 26146<br />core:fwd_replies:: 0<br />core:drop_requests:: 27<br />core:drop_replies:: 0<br />core:err_requests:: 0<br />core:err_replies:: 0<br />core:bad_URIs_rcvd:: 0<br />core:unsupported_methods:: 0<br />core:bad_msg_hdr:: 0<br />core:timestamp:: 179429<br />net:waiting_udp:: 0<br />net:waiting_tcp:: 0<br />sl:1xx_replies:: 0<br />sl:2xx_replies:: 930643<br />sl:3xx_replies:: 0<br />sl:4xx_replies:: 265459<br />sl:5xx_replies:: 168472<br />sl:6xx_replies:: 0<br />sl:sent_replies:: 1364574<br />sl:sent_err_replies:: 0<br />sl:received_ACKs:: 27<br />tm:received_replies:: 570374<br />tm:relayed_replies:: 402332<br />tm:local_replies:: 155868<br />tm:UAS_transactions:: 181106<br />tm:UAC_transactions:: 71770<br />tm:2xx_transactions:: 117167<br />tm:3xx_transactions:: 0<br />tm:4xx_transactions:: 138052<br />tm:5xx_transactions:: 29<br />tm:6xx_transactions:: 0<br />**tm:inuse_transactions:: 2**<br />uri:positive checks:: 195024<br />uri:negative_checks:: 0<br />usrloc:registered_users:: 0<br />usrloc:location-users:: 0<br />usrloc:location-contacts:: 0<br />usrloc:location-expires:: 0<br />registrar:max_expires:: 180<br />registrar:max_contacts:: 1<br />registrar:default_expire:: 150<br />**registrar:accepted_regs:: 110781**<br />**registrar:rejected_regs:: 84236**<br />**dialog:active_dialogs:: 0**<br />dialog:early_dialogs:: 0<br />dialog:processed_dialogs:: 150397<br />dialog:expired_dialogs:: 0<br />**dialog:failed_dialogs:: 137297**<br />dialog:create_sent:: 0<br />dialog:update_sent:: 0<br />dialog:delete_sent:: 0<br />dialog:create_recv:: 0<br />dialog:update_recv:: 0<br />dialog:delete_recv:: 0


