---
title: "设置独立日志文件"
date: "2019-06-16 10:33:15"
draft: false
---

# 设置独立日志

默认情况下，opensips的日志会写在系统日志文件`/var/log/message`中，为了避免难以查阅日志，我们可以将opensips的日志写到单独的日志文件中。

环境说明

> debian buster


这个需要做两步。

**第一步，配置opensips.cfg文件**

```bash
log_facility=LOG_LOCAL0
```

**第二步, 创建日志配置文件**

```bash
echo "local0.* -/var/log/opensips.log" > /etc/rsyslog.d/opensips.conf
```

**第三步，创建日志文件**

```bash
touch /var/log/opensips.log
```

**第四步，重启rsyslog和opensips**

```bash
service rsyslog restart
opensipsctl restart
```

**第五步，验证结果**

```bash
tail /var/log/opensips.log
```



# 日志回滚
为了避免日志文件占用过多磁盘空间，需要做日志回滚。

```systemverilog
安装logrotate
apt install logrotate -y
```
日志回滚配置文件 /etc/logrotate.d/opensips
```systemverilog
 /var/log/opensips.log {
     noolddir
     size 10M
     rotate 100
     copytruncate
     compress
     sharedscripts
     postrotate
     /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
     /bin/kill -HUP `cat /var/run/rsyslogd.pid 2> /dev/null` 2> /dev/null || true
     endscript
 }
```
配置定时任务

```systemverilog
*/10 * * * * /usr/sbin/logrotate /etc/logrotate.d/opensips
```

