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

# rsyslog进程卡死导致OpenSIPS无法启动

在启动kamailio进程之前，启动脚本会尝试启动rsyslogd,  在启动rsyslogd时，进程卡住

报错语句：

```sh
startup failure, child did not respond within startup timeout
```


## 原因分析

排查相关资料，这个issues最为有用： https://github.com/rsyslog/rsyslog/issues/5158


该issuse里所表达的时： **进程的ulimit 值太大，导致rsyslogd卡在循环**

然后我在启动脚本里打印了机器的ulimit,  确认了ulimit的确是一个非常大的值。

```
root@8ccc77403b06:~# ulimit -n    
1073741816
```


## 解决方案

既然知道原因，就可以通多ulimit去限制， 限制后，进程能成功启动。

```
docker run 
--ulimit nproc=65525 \
--ulimit nofile=20000:40000 \
```


## rsyslogd深入分析


```c
	/* close unnecessary open files */
	const int endClose = getdtablesize();
	close(0);
	for(int i = beginClose ; i <= endClose ; ++i) {
		if((i != dbgGetDbglogFd()) && (i != parentPipeFD)) {
			  aix_close_it(i); /* AIXPORT */
		}
	}
	seedRandomNumberForChild();
```

- `getdtablesize()`  获取当前进程可用的 **最大文件描述符数量**（硬上限）。 用来确定循环关闭 FD 的范围
- 关闭所有不需要的文件描述符（socket、pipe、文件、监听句柄等）。
- 父进程 fork 后，希望子进程不要继承无用 FD，避免资源泄漏


# 参考资料

- https://github.com/rsyslog/rsyslog/issues/5158
- https://github.com/moby/moby/issues/38814
- https://github.com/moby/moby/issues/44547