---
title: "自动IP拦截工具fail2ban使用教程"
date: "2020-04-28 08:48:11"
draft: false
---

# 简介
如果你的主机在公网上有端口暴露出去，那么总会有一些不怀好意的家伙，会尝试通过各种方式攻击你的机器。常见的服务例如ssh, nginx都会有类似的威胁。

手工将某个ip加入黑名单，这种操作太麻烦，而且效率低。而fail2ban就是一种自动化的解决方案。


# fail2ban工作原理
fail2ban的工作原理是监控某个日志文件，然后根据某些关键词，提取出攻击方的IP地址，然后将其加入到黑名单。



# fail2ban安装

```javascript
yum install fail2ban -y 

# 如果找不到fail2ban包，就执行下面的命令
yum install epel-release

# 安装fail2ban 完成后
systemctl enable fail2ban # 设置fail2ban开机启动
systemctl start fail2ban # 启动fail2ban
systemctl status fail2ban # 查看fail2ban的运行状态
```


# 用fail2ban保护ssh
fail2ban的配置文件位于/etc/fail2ban目录下。

在该目录下建立一个文件 jail.local, 内容如下

- bantime 持续禁止多久
- maxretry 最大多少次尝试
- banaction 拦截后的操作
- findtime 查找时间

看下下面的操作的意思是：监控sshd服务的最近10分钟的日志，如果某个ip在10分钟之内，有2次登录失败，就把这个ip加入黑名单, 24小时之后，这个ip才会被从黑名单中移除。
```javascript
[DEFAULT]
bantime = 24h
banaction = iptables-multiport
maxretry = 2
findtime = 10m

[sshd]
enabled = true
```

然后重启fail2ban, `systemctl restart fail2ban` 

fail2ban提供管理工具fail2ban-client

- **fail2ban-client status **显示fail2ban的状态
- **fail2ban-client status sshd **显示某个监狱的配置。从下文的输出来看可以看出来fail2ban已经拦截了一些IP地址了

```bash
> fail2ban-client status
Status
|- Number of jail:	1
`- Jail list:	sshd
> fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed:	2
|  |- Total failed:	23289
|  `- Journal matches:	_SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned:	9
   |- Total banned:	1270
   `- Banned IP list:	93.174.93.10 165.22.238.92 23.231.25.234 134.255.219.207 77.202.192.113 120.224.47.86 144.91.70.139 90.3.194.84 217.182.89.87
```


# fail2ban保护sshd的原理
fail2ban的配置文件目录下有个filter.d目录，该目录下有个sshd.conf的文件，这个文件就是对于sshd日志的过滤规则，里面有些正常时用来提取出恶意家伙的IP地址。

配置配置文件很长，我们只看其中一段， 其中**<****HOST>**是个非常重要的关键词，是用来提取出远程的IP地址的。
```bash
cmnfailre = ^[aA]uthentication (?:failure|error|failed) for <F-USER>.*</F-USER> from <HOST>( via \S+)?%(__suff)s$
            ^User not known to the underlying authentication module for <F-USER>.*</F-USER> from <HOST>%(__suff)s$
            ^Failed publickey for invalid user <F-USER>(?P<cond_user>\S+)|(?:(?! from ).)*?</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?(?(cond_us
```


# 实战：如何自定义一个过滤规则

我的nginx服务器，几乎每隔2-3秒就会收到下面的一个请求。

下面我就写个过滤规则，将类似请求的IP加入黑名单。
```bash
165.22.225.238 - - [28/Apr/2020:08:19:38 +0800] "POST /ws/v1/cluster/apps/new-application HTTP/1.1" 502 11 "-" "python-requests/2.6.0 CPython/2.7.5 Linux/3.10.0-957.27.2.el7.x86_64" "-"
165.22.225.238 - - [28/Apr/2020:08:22:48 +0800] "POST /ws/v1/cluster/apps/new-application HTTP/1.1" 502 11 "-" "python-requests/2.6.0 CPython/2.7.5 Linux/3.10.0-957.27.2.el7.x86_64" "-"
165.22.225.238 - - [28/Apr/2020:08:24:08 +0800] "POST /ws/v1/cluster/apps/new-application HTTP/1.1" 502 11 "-" "python-requests/2.6.0 CPython/2.7.5 Linux/3.10.0-957.27.2.el7.x86_64" "-"
165.22.225.238 - - [28/Apr/2020:08:25:45 +0800] "POST /ws/v1/cluster/apps/new-application HTTP/1.1" 502 11 "-" "python-requests/2.6.0 CPython/2.7.5 Linux/3.10.0-957.27.2.el7.x86_64" "-"
165.22.225.238 - - [28/Apr/2020:08:28:01 +0800] "POST /ws/v1/cluster/apps/new-application HTTP/1.1" 502 11 "-" "python-requests/2.6.0 CPython/2.7.5 Linux/3.10.0-957.27.2.el7.x86_64" "-"
```


## step1: 分析日志规则

```bash
165.22.225.238 - - [28/Apr/2020:08:19:38 +0800] "POST /ws/v1/cluster/apps/new-application HTTP/1.1" 502 11 "-" "python-requests/2.6.0 CPython/2.7.5 Linux/3.10.0-957.27.2.el7.x86_64" "-"
```

```bash
HOST - - .*" 502 .*
```


## step2: 写规则文件
在filter.d目录下新建文件 banit.conf

```bash
[INCLUDES]

[Definition]

failregex = <HOST> - - .*" 502 .*

ignoreregex =
```


## step3: 修改jail.local

```bash
[DEFAULT]
bantime = 24h
banaction = iptables-multiport
maxretry = 2
findtime = 10m

[sshd]
enabled = true

[banit]
enabled = true
action   = iptables-allports[name=banit, protocol=all]
logpath = /var/log/nginx/access.log
```


## step4: 重启fail2ban

**fail2ban-client restart**<br />**

## step5: 查看效果
可以看出banit的这个监狱，已经加入了一个**165.22.225.238**这个ip，这个流氓不会在骚扰我们的主机了。
```bash
> fail2ban fail2ban-client status banit
Status for the jail: banit
|- Filter
|  |- Currently failed:	1
|  |- Total failed:	5
|  `- File list:	/var/log/nginx/access.log
`- Actions
   |- Currently banned:	1
   |- Total banned:	1
   `- Banned IP list:	165.22.225.238
```
**

# fail2ban-client 常用操作

- **重启**: **fail2ban systemctl restart fail2ban **
- **查看fail2ban opensips运行状态**: **fail2ban-client status opensips **
- **黑名单操作** (**注意，黑名单测试时，不要把自己的IP加到黑名单里做测试，否则就连不上机器了**)
   - IP加入黑名单：**fail2ban-client set opensips banip 192.168.1.8 **
   - IP解锁：**fail2ban-client set opensips unbanip 192.168.1.8**
- **白名单操作**
   - IP加入白名单：**fail2ban-client set opensips addignoreip 192.168.1.8**
   - IP从白名单中移除：**fail2ban-client set opensips delignoreip 192.168.1.8**
   - 在所有监狱中加入IP白名单：**fail2ban-clien unban 192.168.1.8**

**<br />**fail2ban的拦截是基于jail, 如果一个ip在某个jail中，但是不在其他jail中，那么这个ip也是无法访问主机。**<br />**<br />**如果想在所有jail中加入一个白名单，需要fail2ban-client unban ip。**

**

# fail2ban-client帮助文档

```bash
Usage: fail2ban-client [OPTIONS] <COMMAND>

Fail2Ban v0.10.5 reads log file that contains password failure report
and bans the corresponding IP addresses using firewall rules.

Options:
    -c <DIR>                configuration directory
    -s <FILE>               socket path
    -p <FILE>               pidfile path
    --loglevel <LEVEL>      logging level
    --logtarget <TARGET>    logging target, use file-name or stdout, stderr, syslog or sysout.
    --syslogsocket auto|<FILE>
    -d                      dump configuration. For debugging
    --dp, --dump-pretty     dump the configuration using more human readable representation
    -t, --test              test configuration (can be also specified with start parameters)
    -i                      interactive mode
    -v                      increase verbosity
    -q                      decrease verbosity
    -x                      force execution of the server (remove socket file)
    -b                      start server in background (default)
    -f                      start server in foreground
    --async                 start server in async mode (for internal usage only, don't read configuration)
    --timeout               timeout to wait for the server (for internal usage only, don't read configuration)
    --str2sec <STRING>      convert time abbreviation format to seconds
    -h, --help              display this help message
    -V, --version           print the version (-V returns machine-readable short format)

Command:
                                             BASIC
    start                                    starts the server and the jails
    restart                                  restarts the server
    restart [--unban] [--if-exists] <JAIL>   restarts the jail <JAIL> (alias
                                             for 'reload --restart ... <JAIL>')
    reload [--restart] [--unban] [--all]     reloads the configuration without
                                             restarting of the server, the
                                             option '--restart' activates
                                             completely restarting of affected
                                             jails, thereby can unban IP
                                             addresses (if option '--unban'
                                             specified)
    reload [--restart] [--unban] [--if-exists] <JAIL>
                                             reloads the jail <JAIL>, or
                                             restarts it (if option '--restart'
                                             specified)
    stop                                     stops all jails and terminate the
                                             server
    unban --all                              unbans all IP addresses (in all
                                             jails and database)
    unban <IP> ... <IP>                      unbans <IP> (in all jails and
                                             database)
    status                                   gets the current status of the
                                             server
    ping                                     tests if the server is alive
    echo                                     for internal usage, returns back
                                             and outputs a given string
    help                                     return this output
    version                                  return the server version

                                             LOGGING
    set loglevel <LEVEL>                     sets logging level to <LEVEL>.
                                             Levels: CRITICAL, ERROR, WARNING,
                                             NOTICE, INFO, DEBUG, TRACEDEBUG,
                                             HEAVYDEBUG or corresponding
                                             numeric value (50-5)
    get loglevel                             gets the logging level
    set logtarget <TARGET>                   sets logging target to <TARGET>.
                                             Can be STDOUT, STDERR, SYSLOG or a
                                             file
    get logtarget                            gets logging target
    set syslogsocket auto|<SOCKET>           sets the syslog socket path to
                                             auto or <SOCKET>. Only used if
                                             logtarget is SYSLOG
    get syslogsocket                         gets syslog socket path
    flushlogs                                flushes the logtarget if a file
                                             and reopens it. For log rotation.

                                             DATABASE
    set dbfile <FILE>                        set the location of fail2ban
                                             persistent datastore. Set to
                                             "None" to disable
    get dbfile                               get the location of fail2ban
                                             persistent datastore
    set dbmaxmatches <INT>                   sets the max number of matches
                                             stored in database per ticket
    get dbmaxmatches                         gets the max number of matches
                                             stored in database per ticket
    set dbpurgeage <SECONDS>                 sets the max age in <SECONDS> that
                                             history of bans will be kept
    get dbpurgeage                           gets the max age in seconds that
                                             history of bans will be kept

                                             JAIL CONTROL
    add <JAIL> <BACKEND>                     creates <JAIL> using <BACKEND>
    start <JAIL>                             starts the jail <JAIL>
    stop <JAIL>                              stops the jail <JAIL>. The jail is
                                             removed
    status <JAIL> [FLAVOR]                   gets the current status of <JAIL>,
                                             with optional flavor or extended
                                             info

                                             JAIL CONFIGURATION
    set <JAIL> idle on|off                   sets the idle state of <JAIL>
    set <JAIL> ignoreself true|false         allows the ignoring of own IP
                                             addresses
    set <JAIL> addignoreip <IP>              adds <IP> to the ignore list of
                                             <JAIL>
    set <JAIL> delignoreip <IP>              removes <IP> from the ignore list
                                             of <JAIL>
    set <JAIL> ignorecommand <VALUE>         sets ignorecommand of <JAIL>
    set <JAIL> ignorecache <VALUE>           sets ignorecache of <JAIL>
    set <JAIL> addlogpath <FILE> ['tail']    adds <FILE> to the monitoring list
                                             of <JAIL>, optionally starting at
                                             the 'tail' of the file (default
                                             'head').
    set <JAIL> dellogpath <FILE>             removes <FILE> from the monitoring
                                             list of <JAIL>
    set <JAIL> logencoding <ENCODING>        sets the <ENCODING> of the log
                                             files for <JAIL>
    set <JAIL> addjournalmatch <MATCH>       adds <MATCH> to the journal filter
                                             of <JAIL>
    set <JAIL> deljournalmatch <MATCH>       removes <MATCH> from the journal
                                             filter of <JAIL>
    set <JAIL> addfailregex <REGEX>          adds the regular expression
                                             <REGEX> which must match failures
                                             for <JAIL>
    set <JAIL> delfailregex <INDEX>          removes the regular expression at
                                             <INDEX> for failregex
    set <JAIL> addignoreregex <REGEX>        adds the regular expression
                                             <REGEX> which should match pattern
                                             to exclude for <JAIL>
    set <JAIL> delignoreregex <INDEX>        removes the regular expression at
                                             <INDEX> for ignoreregex
    set <JAIL> findtime <TIME>               sets the number of seconds <TIME>
                                             for which the filter will look
                                             back for <JAIL>
    set <JAIL> bantime <TIME>                sets the number of seconds <TIME>
                                             a host will be banned for <JAIL>
    set <JAIL> datepattern <PATTERN>         sets the <PATTERN> used to match
                                             date/times for <JAIL>
    set <JAIL> usedns <VALUE>                sets the usedns mode for <JAIL>
    set <JAIL> attempt <IP> [<failure1> ... <failureN>]
                                             manually notify about <IP> failure
    set <JAIL> banip <IP> ... <IP>           manually Ban <IP> for <JAIL>
    set <JAIL> unbanip [--report-absent] <IP> ... <IP>
                                             manually Unban <IP> in <JAIL>
    set <JAIL> maxretry <RETRY>              sets the number of failures
                                             <RETRY> before banning the host
                                             for <JAIL>
    set <JAIL> maxmatches <INT>              sets the max number of matches
                                             stored in memory per ticket in
                                             <JAIL>
    set <JAIL> maxlines <LINES>              sets the number of <LINES> to
                                             buffer for regex search for <JAIL>
    set <JAIL> addaction <ACT>[ <PYTHONFILE> <JSONKWARGS>]
                                             adds a new action named <ACT> for
                                             <JAIL>. Optionally for a Python
                                             based action, a <PYTHONFILE> and
                                             <JSONKWARGS> can be specified,
                                             else will be a Command Action
    set <JAIL> delaction <ACT>               removes the action <ACT> from
                                             <JAIL>

                                             COMMAND ACTION CONFIGURATION
    set <JAIL> action <ACT> actionstart <CMD>
                                             sets the start command <CMD> of
                                             the action <ACT> for <JAIL>
    set <JAIL> action <ACT> actionstop <CMD> sets the stop command <CMD> of the
                                             action <ACT> for <JAIL>
    set <JAIL> action <ACT> actioncheck <CMD>
                                             sets the check command <CMD> of
                                             the action <ACT> for <JAIL>
    set <JAIL> action <ACT> actionban <CMD>  sets the ban command <CMD> of the
                                             action <ACT> for <JAIL>
    set <JAIL> action <ACT> actionunban <CMD>
                                             sets the unban command <CMD> of
                                             the action <ACT> for <JAIL>
    set <JAIL> action <ACT> timeout <TIMEOUT>
                                             sets <TIMEOUT> as the command
                                             timeout in seconds for the action
                                             <ACT> for <JAIL>

                                             GENERAL ACTION CONFIGURATION
    set <JAIL> action <ACT> <PROPERTY> <VALUE>
                                             sets the <VALUE> of <PROPERTY> for
                                             the action <ACT> for <JAIL>
    set <JAIL> action <ACT> <METHOD>[ <JSONKWARGS>]
                                             calls the <METHOD> with
                                             <JSONKWARGS> for the action <ACT>
                                             for <JAIL>

                                             JAIL INFORMATION
    get <JAIL> logpath                       gets the list of the monitored
                                             files for <JAIL>
    get <JAIL> logencoding                   gets the encoding of the log files
                                             for <JAIL>
    get <JAIL> journalmatch                  gets the journal filter match for
                                             <JAIL>
    get <JAIL> ignoreself                    gets the current value of the
                                             ignoring the own IP addresses
    get <JAIL> ignoreip                      gets the list of ignored IP
                                             addresses for <JAIL>
    get <JAIL> ignorecommand                 gets ignorecommand of <JAIL>
    get <JAIL> failregex                     gets the list of regular
                                             expressions which matches the
                                             failures for <JAIL>
    get <JAIL> ignoreregex                   gets the list of regular
                                             expressions which matches patterns
                                             to ignore for <JAIL>
    get <JAIL> findtime                      gets the time for which the filter
                                             will look back for failures for
                                             <JAIL>
    get <JAIL> bantime                       gets the time a host is banned for
                                             <JAIL>
    get <JAIL> datepattern                   gets the patern used to match
                                             date/times for <JAIL>
    get <JAIL> usedns                        gets the usedns setting for <JAIL>
    get <JAIL> maxretry                      gets the number of failures
                                             allowed for <JAIL>
    get <JAIL> maxmatches                    gets the max number of matches
                                             stored in memory per ticket in
                                             <JAIL>
    get <JAIL> maxlines                      gets the number of lines to buffer
                                             for <JAIL>
    get <JAIL> actions                       gets a list of actions for <JAIL>

                                             COMMAND ACTION INFORMATION
    get <JAIL> action <ACT> actionstart      gets the start command for the
                                             action <ACT> for <JAIL>
    get <JAIL> action <ACT> actionstop       gets the stop command for the
                                             action <ACT> for <JAIL>
    get <JAIL> action <ACT> actioncheck      gets the check command for the
                                             action <ACT> for <JAIL>
    get <JAIL> action <ACT> actionban        gets the ban command for the
                                             action <ACT> for <JAIL>
    get <JAIL> action <ACT> actionunban      gets the unban command for the
                                             action <ACT> for <JAIL>
    get <JAIL> action <ACT> timeout          gets the command timeout in
                                             seconds for the action <ACT> for
                                             <JAIL>

                                             GENERAL ACTION INFORMATION
    get <JAIL> actionproperties <ACT>        gets a list of properties for the
                                             action <ACT> for <JAIL>
    get <JAIL> actionmethods <ACT>           gets a list of methods for the
                                             action <ACT> for <JAIL>
    get <JAIL> action <ACT> <PROPERTY>       gets the value of <PROPERTY> for
                                             the action <ACT> for <JAIL>

Report bugs to https://github.com/fail2ban/fail2ban/issues
```

Report bugs to [https://github.com/fail2ban/fail2ban/issues](https://github.com/fail2ban/fail2ban/issues)

