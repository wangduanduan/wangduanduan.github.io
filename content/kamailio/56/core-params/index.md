---
title: "1.6 核心参数"
date: "2025-03-29 00:30:55"
draft: false
type: posts
tags:
- all
categories:
- all
---

kamailio和核心参数有106个，控制了kamailio的运行方式。
- [1. advertised\_address](#1-advertised_address)
- [2. advertised\_port](#2-advertised_port)
- [3. alias ⭐️](#3-alias-️)
- [4. async\_workers](#4-async_workers)
- [5. async\_nonblock](#5-async_nonblock)
- [6. async\_usleep](#6-async_usleep)
- [7. async\_workers\_group](#7-async_workers_group)
- [8. auto\_aliases](#8-auto_aliases)
- [9. auto\_bind\_ipv6](#9-auto_bind_ipv6)
- [10. bind\_ipv6\_link\_local](#10-bind_ipv6_link_local)
- [11. check\_via ⭐️](#11-check_via-️)
- [12. children](#12-children)
- [13. chroot](#13-chroot)
- [14. corelog](#14-corelog)
- [15. debug ⭐️](#15-debug-️)
- [16. description](#16-description)
- [17. disable\_core\_dump](#17-disable_core_dump)
- [18. disable\_tls](#18-disable_tls)
- [19. enable\_tls](#19-enable_tls)
- [20. exit\_timeout](#20-exit_timeout)
- [21. flags](#21-flags)
- [22. force\_rport ⭐️](#22-force_rport-️)
- [23. fork](#23-fork)
- [24. fork\_delay](#24-fork_delay)
- [25. group](#25-group)
- [26. http\_reply\_parse](#26-http_reply_parse)
- [27. ip\_free\_bind](#27-ip_free_bind)
- [28. ipv6\_hex\_style](#28-ipv6_hex_style)
- [29. kemi.onsend\_route\_callback](#29-kemionsend_route_callback)
- [30. kemi.received\_route\_callback](#30-kemireceived_route_callback)
- [31. kemi.reply\_route\_callback](#31-kemireply_route_callback)
- [32. kemi.pre\_routing\_callback](#32-kemipre_routing_callback)
- [33. latency\_cfg\_log ⭐️](#33-latency_cfg_log-️)
- [34. latency\_limit\_action ⭐️](#34-latency_limit_action-️)
- [35. latency\_limit\_db ⭐️](#35-latency_limit_db-️)
- [36. latency\_log ⭐️](#36-latency_log-️)
- [37. listen ⭐️](#37-listen-️)
- [38. loadmodule](#38-loadmodule)
- [39. loadmodulex](#39-loadmodulex)
- [40. loadpath](#40-loadpath)
- [41. local\_rport ⭐️](#41-local_rport-️)
- [42. log\_engine\_data](#42-log_engine_data)
- [43. log\_engine\_type](#43-log_engine_type)
- [44. log\_facility ⭐️](#44-log_facility-️)
- [45. log\_name ⭐️](#45-log_name-️)
- [46. log\_prefix ⭐️](#46-log_prefix-️)
- [47. log\_prefix\_mode ⭐️](#47-log_prefix_mode-️)
- [48. log\_stderror](#48-log_stderror)
- [49. cfgengine](#49-cfgengine)
- [50. maxbuffer ⭐️](#50-maxbuffer-️)
- [51. max\_branches](#51-max_branches)
- [52. max\_recursive\_level](#52-max_recursive_level)
- [53. max\_while\_loops ⭐️](#53-max_while_loops-️)
- [54. mcast](#54-mcast)
- [55. mcast\_loopback](#55-mcast_loopback)
- [56. mcast\_ttl](#56-mcast_ttl)
- [57. memdbg](#57-memdbg)
- [58. memlog ⭐️](#58-memlog-️)
- [59. mem\_join](#59-mem_join)
- [60. mem\_safety](#60-mem_safety)
- [61. mem\_status\_mode](#61-mem_status_mode)
- [62. mem\_summary](#62-mem_summary)
- [63. mhomed](#63-mhomed)
- [64. mlock\_pages](#64-mlock_pages)
- [65. modinit\_delay](#65-modinit_delay)
- [66. modparam](#66-modparam)
- [67. modparamx](#67-modparamx)
- [68. onsend\_route\_reply](#68-onsend_route_reply)
- [69. open\_files\_limit](#69-open_files_limit)
- [70. phone2tel](#70-phone2tel)
- [71. pmtu\_discovery](#71-pmtu_discovery)
- [72. port](#72-port)
- [73. pv\_buffer\_size](#73-pv_buffer_size)
- [74. pv\_buffer\_slots](#74-pv_buffer_slots)
- [75. pv\_cache\_limit](#75-pv_cache_limit)
- [76. pv\_cache\_action](#76-pv_cache_action)
- [77. rundir](#77-rundir)
- [78. received\_route\_mode](#78-received_route_mode)
- [79. reply\_to\_via](#79-reply_to_via)
- [80. route\_locks\_size](#80-route_locks_size)
- [81. server\_id](#81-server_id)
- [82. server\_header ⭐️](#82-server_header-️)
- [83. server\_signature ⭐️](#83-server_signature-️)
- [84. shm\_force\_alloc](#84-shm_force_alloc)
- [85. shm\_mem\_size](#85-shm_mem_size)
- [86. sip\_parser\_log](#86-sip_parser_log)
- [87. sip\_parser\_mode ⭐️](#87-sip_parser_mode-️)
- [88. sip\_warning (noisy feedback)](#88-sip_warning-noisy-feedback)
- [89. socket\_workers](#89-socket_workers)
- [90. sql\_buffer\_size ⭐️](#90-sql_buffer_size-️)
- [91. statistics ⭐️](#91-statistics-️)
- [92. stats\_name\_separator](#92-stats_name_separator)
- [93. tos](#93-tos)
- [94. udp\_mtu ⭐️](#94-udp_mtu-️)
- [95. udp\_mtu\_try\_proto](#95-udp_mtu_try_proto)
- [96. uri\_host\_extra\_chars](#96-uri_host_extra_chars)
- [97. user ⭐️](#97-user-️)
- [98. user\_agent\_header ⭐️](#98-user_agent_header-️)
- [99. verbose\_startup ⭐️](#99-verbose_startup-️)
- [100. version\_table ⭐️](#100-version_table-️)
- [101. wait\_worker1\_mode](#101-wait_worker1_mode)
- [102. wait\_worker1\_time](#102-wait_worker1_time)
- [103. wait\_worker1\_usleep](#103-wait_worker1_usleep)
- [104. workdir ⭐️](#104-workdir-️)
- [105. xavp\_via\_params](#105-xavp_via_params)
- [106. xavp\_via\_fields](#106-xavp_via_fields)


# 1. advertised_address

> 用处不大，将会废弃

It can be an IP address or string and represents the address advertised
in Via header. If empty or not set (default value) the socket address
from where the request will be sent is used.

    WARNING:
    - don't set it unless you know what you are doing (e.g. nat traversal)
    - you can set anything here, no check is made (e.g. foo.bar will be accepted even if foo.bar doesn't exist)

Example of usage:

      advertised_address="​1.2.3.4"​
      advertised_address="kamailio.org"

Note: this option may be deprecated and removed in the near future, it
is recommended to set **advertise** option for **listen** parameter.

# 2. advertised_port

> 用处不大，将会废弃

The port advertised in Via header. If empty or not set (default value)
the port from where the message will be sent is used. Same warnings as
for 'advertised_address'.

Example of usage:

      advertised_port=5080

Note: this option may be deprecated and removed in the near future, it
is recommended to set **advertise** option for **listen** parameter.

# 3. alias ⭐️

> 主要的使用场景是一个sip有一个或者多个域名的情况下，让km知道这些域名是他自己管理的。无论是is_self()或者loose_route()函数都需要用到。

Parameter to set alias hostnames for the server. It can be set many
times, each value being added in a list to match the hostname when
'myself' is checked.

It is necessary to include the port (the port value used in the "port="
or "listen=" defintions) in the alias definition otherwise the
loose_route() function will not work as expected for local forwards.
Even if you do not use 'myself' explicitly (for example if you use the
domain module), it is often necessary to set the alias as these aliases
are used by the loose_routing function and might be needed to handle
requests with pre-loaded route set correctly.

Example of usage:

        alias=other.domain.com:5060
        alias=another.domain.com:5060

Note: the hostname has to be enclosed in between quotes if it has
reserved tokens such as **forward**, **drop** ... or operators such as
**-** (minus) ...

# 4. async_workers

Specify how many child processes (workers) to create for asynchronous
execution in the group "default". These are processes that can receive
tasks from various components (e.g, modules such as async, acc, sqlops)
and execute them locally, which is different process than the task
sender.

Default: 0 (asynchronous framework is disabled).

Example:

        async_workers=4

# 5. async_nonblock

Set the non-block mode for the internal sockets used by default group of
async workers.

Default: 0

Example:

        async_nonblock=1

# 6. async_usleep

Set the number of microseconds to sleep before trying to receive next
task (can be useful when async_nonblock=1).

Default: 0

Example:

        async_usleep=100

# 7. async_workers_group

Define groups of asynchronous worker processes.

Prototype:

    async_workers_group="name=X;workers=N;nonblock=[0|1];usleep=M"

The attributes are:

- **name** - the group name (used by functions such as
    **sworker_task(name)**)
- **workers** - the number of processes to create for this group
- **nonblock** - set or not set the non-block flag for internal
    communication socket
- **usleep** - the number of microseconds to sleep before trying to
    receive next task (can be useful if nonblock=1)

Default: "".

Example:

        async_workers_group="name=reg;workers=4;nonblock=0;usleep=0"

If the **name** is default, then it overwrites the value set by
**async_workers**.

See also **event_route\[core:pre-routing\]** and **sworker** module.

# 8. auto_aliases

> 一般我都关闭

Kamailio by default discovers all IPv4 addresses on all interfaces and
does a reverse DNS lookup on these addresses to find host names.
Discovered host names are added to aliases list, matching the **myself**
condition. To disable host names auto-discovery, turn off auto_aliases.

Example:

        auto_aliases=no

# 9. auto_bind_ipv6

When turned on, Kamailio will automatically bind to all IPv6 addresses
(much like the default behaviour for IPv4). Default is 0.

Example:

        auto_bind_ipv6=1

# 10. bind_ipv6_link_local

If set to 1, try to bind also IPv6 link local addresses by discovering
the scope of the interface. This apply for UDP socket for now, to be
added for the other protocols. Default is 0.

Example:

        bind_ipv6_link_local=1

# 11. check_via ⭐️

> 这个建议开启，防止伪造请求

Check if the address in top most via of replies is local. Default value
is 0 (check disabled).

Example of usage:

      check_via=1

# 12. children

Number of children to fork for the UDP interfaces (one set for each
interface - ip:port). Default value is 8. For example if you configure
the proxy to listen on 3 UDP ports, it will create 3xchildren processes
which handle the incoming UDP messages.

For configuration of the TCP/TLS worker threads see the option
"tcp_children".

Example of usage:

      children=16

# 13. chroot

> 这个值可能影响coredump文件产生的目录

The value must be a valid path in the system. If set, Kamailio will
chroot (change root directory) to its value.

Example of usage:

      chroot=/other/fakeroot

# 14. corelog

Set the debug level used to print some log messages from core, which
might become annoying and don't represent critical errors. For example,
such case is failure to parse incoming traffic from the network as SIP
message, due to someone sending invalid content.

Default value is -1 (L_ERR).

Example of usage:

    corelog=1

# 15. debug ⭐️

> 生产环境要配置至少INFO级别, DEBUG级别磁盘会很快被写满

Set the debug level. Higher values make Kamailio to print more debug
messages. Log messages are usually sent to syslog, except if logging to
stderr was activated (see [#log_stderror](#log_stderror) parameter).

The following log levels are defined:

     L_ALERT     -5
     L_BUG       -4
     L_CRIT2     -3
     L_CRIT      -2
     L_ERR       -1
     L_WARN       0
     L_NOTICE     1
     L_INFO       2
     L_DBG        3

A log message will be logged if its log-level is lower than the defined
debug level. Log messages are either produced by the the code, or
manually in the configuration script using log() or xlog() functions.
For a production server you usually use a log value between -1 and 2.

Default value: L_WARN (debug=0)

Examples of usage:

- debug=3: print all log messages. This is only useful for debugging
    of problems. Note: this produces a lot of data and therefore should
    not be used on production servers (on a busy server this can easily
    fill up your hard disk with log messages)
- debug=0: This will only log warning, errors and more critical
    messages.
- debug=-6: This will disable all log messages.

> 日志级别可以在运行时动态调整，无需重启服务

Value of 'debug' parameter can also be obtained and set dynamically using the
'debug' Core MI function or the RPC function, e.g.:

    kamcmd cfg.get core debug
    kamcmd cfg.set_now_int core debug 2
    kamcmd cfg.set_now_int core debug -- -1

Note: There is a difference in log-levels between Kamailio 3.x and
Kamailio\<=1.5: Up to Kamailio 1.5 the log level started with 4, whereas
in Kamailio>=3 the log level starts with 3. Thus, if you were using
debug=3 in older Kamailio, now use debug=2.

For configuration of logging of the memory manager see the parameters
[#memlog](#memlog) and [#memdbg](#memdbg).

Further information can also be found at:
<https://www.kamailio.org/wiki/tutorials/3.2.x/syslog>

# 16. description

**Alias name:** **descr desc**

# 17. disable_core_dump

Can be 'yes' or 'no'. By default core dump limits are set to unlimited
or a high enough value. Set this config variable to 'yes' to disable
core dump-ing (will set core limits to 0).

Default value is 'no'.

Example of usage:

      disable_core_dump=yes

# 18. disable_tls

**Alias name:** **tls_disable**

Global parameter to disable TLS support in the SIP server. Default value
is 'yes'.

Note: Make sure to load the "tls" module to get tls functionality.

Example of usage:

      disable_tls=yes

In Kamailio TLS is implemented as a module. Thus, the TLS configuration
is done as module configuration. For more details see the README of the
TLS module: <http://kamailio.org/docs/modules/devel/modules/tls.html>

# 19. enable_tls

**Alias name:** **tls_enable**

Reverse Meaning of the disable_tls parameter. See disable_tls parameter.

    enable_tls=yes # enable tls support in core

# 20. exit_timeout

**Alias name:** **ser_kill_timeout**

How much time Kamailio will wait for all the shutdown procedures to
complete. If this time is exceeded, all the remaining processes are
immediately killed and Kamailio exits immediately (it might also
generate a core dump if the cleanup part takes too long).

Default: 60 s. Use 0 to disable.

     exit_timeout = seconds

# 21. flags

SIP message (transaction) flags can have string names. The *name* for
flags cannot be used for **branch** or **script flags**(\*)

``` c
...
flags
  FLAG_ONE   : 1,
  FLAG_TWO   : 2;
...
```

(\*) The named flags feature was propagated from the source code merge
back in 2008 and is not extensively tested. The recommended way of
defining flags is using [#!define](core.md#define) (which
is also valid for branch/script flags):

``` c
#!define FLAG_NAME FLAG_BIT
```

# 22. force_rport ⭐️

> 建议开启

yes/no: Similar to the force_rport() function, but activates symmetric
response routing globally.

# 23. fork

If set to 'yes' the proxy will fork and run in daemon mode - one process
will be created for each network interface the proxy listens to and for
each protocol (TCP/UDP), multiplied with the value of 'children'
parameter.

When set to 'no', the proxy will stay bound to the terminal and runs as
single process. First interface is used for listening to. This is
equivalent to setting the server option "-F".

Default value is 'yes'.

Example of usage:

      fork=no

# 24. fork_delay

Number of usecs to wait before forking a process.

Default is 0 (don't wait).

Example of usage:

``` c
fork_delay=5000
```

# 25. group

**Alias name:** **gid**

The group id to run Kamailio.

Example of usage:

    group="siprouter"

# 26. http_reply_parse

Alias: http_reply_hack

When enabled, Kamailio can parse HTTP replies, but does so by treating
them as SIP replies. When not enabled HTTP replies cannot be parsed.
This was previously a compile-time option, now it is run-time.

Default value is 'no'.

Example of usage:

    http_reply_parse=yes

# 27. ip_free_bind

> 在VIP环境中，需要开启

Alias: ipfreebind, ip_nonlocal_bind

Control if Kamailio should attempt to bind to non local ip. This option
is the per-socket equivalent of the system **ip_nonlocal_bind**.

Default is 0 (do not bind to non local ip).

Example of usage:

``` c
  ip_free_bind = 1
```

# 28. ipv6_hex_style

Can be set to "a", "A" or "c" to specify if locally computed string
representation of IPv6 addresses should be expanded lowercase, expanded
uppercase or compacted lowercase hexa digits.

Default is "c" (compacted lower hexa digits, conforming better with RFC
5952).

"A" is preserving the behaviour before this global parameter was
introduced, while "a" enables the ability to follow some of the
recommendations of RFC 5952, section 4.3.

Example of usage:

``` c
  ipv6_hex_style = "a"
```

# 29. kemi.onsend_route_callback

Set the name of callback function in the KEMI script to be executed as
the equivalent of \`onsend_route\` block (from the native configuration
file).

Default value: ksr_onsend_route

Set it to empty string or "none" to skip execution of this callback
function.

Example:

``` c
kemi.onsend_route_callback="ksr_my_onsend_route"
```

# 30. kemi.received_route_callback

Set the name of callback function in the KEMI script to be executed as
the equivalent of \`event_route\[core:msg-received\]\` block (from the
native configuration file). For execution, it also require to have the
received_route_mode global parameter set to 1.

Default value: none

Set it to empty string or "none" to skip execution of this callback
function.

Example:

``` c
kemi.received_route_callback="ksr_my_receieved_route"
```

# 31. kemi.reply_route_callback

Set the name of callback function in the KEMI script to be executed as
the equivalent of \`reply_route\` block (from the native configuration
file).

Default value: ksr_reply_route

Set it to empty string or "none" to skip execution of this callback
function.

Example:

``` c
kemi.reply_route_callback="ksr_my_reply_route"
```

# 32. kemi.pre_routing_callback

Set the name of callback function in the KEMI script to be executed as
the equivalent of \`event_route\[core:pre-routing\]\` block (from the
native configuration file).

Default value: none

Set it to empty string or "none" to skip execution of this callback
function.

Example:

``` c
kemi.pre_routing_callback="ksr_pre_routing"
```

# 33. latency_cfg_log ⭐️

If set to a log level less or equal than debug parameter, a log message
with the duration in microseconds of executing request route or reply
route is printed to syslog.

Default value is 3 (L_DBG).

Example:

``` c
latency_cfg_log=2
```

# 34. latency_limit_action ⭐️

Limit of latency in us (micro-seconds) for config actions. If a config
action executed by cfg interpreter takes longer than its value, a
message is printed in the logs, showing config path, line and action
name when it is a module function, as well as internal action id.

Default value is 0 (disabled).

``` c
latency_limit_action=500
```

# 35. latency_limit_db ⭐️

Limit of latency in us (micro-seconds) for db operations. If a db
operation executed via DB API v1 takes longer that its value, a message
is printed in the logs, showing the first 50 characters of the db query.

Default value is 0 (disabled).

``` c
latency_limit_db=500
```

# 36. latency_log ⭐️

Log level to print the messages related to latency.

Default value is -1 (L_ERR).

``` c
latency_log=3
```

# 37. listen ⭐️

Set the network addresses the SIP server should listen to. It can be an
IP address, hostname or network interface id or combination of
protocol:address:port (e.g., <udp:10.10.10.10:5060>). This parameter can
be set multiple times in same configuration file, the server listening
on all addresses specified.

Example of usage:

``` c
    listen=10.10.10.10
    listen=eth1:5062
    listen=udp:10.10.10.10:5064
```

If you omit this directive then the SIP server will listen on all
interfaces. On start the SIP server reports all the interfaces that it
is listening on. Even if you specify only UDP interfaces here, the
server will start the TCP engine too. If you don't want this, you need
to disable the TCP support completely with the core parameter
disable_tcp.

If you specify IPv6 addresses, you should put them into square brackets,
e.g.:

``` c
    listen=udp:[2a02:1850:1:1::18]:5060
```

You can specify an advertise address (like ip:port) per listening socket
- it will be used to build headers such as Via and Record-Route:

``` c
    listen=udp:10.10.10.10:5060 advertise 11.11.11.11:5060
```

The advertise address must be in the format 'address:port', the protocol is
taken from the bind socket. The advertise address is a convenient
alternative to advertised_address / advertised_port cfg parameters or
set_advertised_address() / set_advertised_port() cfg functions.

A typical use case for advertise address is when running SIP server
behind a NAT/Firewall, when the local IP address (to be used for bind)
is different than the public IP address (to be used for advertising).

A unique name can be set for sockets to simplify the selection of the
socket for sending out. For example, the rr and path modules can use the
socket name to advertise it in header URI parameter and use it as a
shortcut to select the corresponding socket for routing subsequent
requests.

The name has to be provided as a string enclosed in between quotes after
the **name** identifier.

``` c
    listen=udp:10.0.0.10:5060 name "s1"
    listen=udp:10.10.10.10:5060 advertise 11.11.11.11:5060 name "s2"
    listen=udp:10.10.10.20:5060 advertise "mysipdomain.com" name "s3"
    listen=udp:10.10.10.30:5060 advertise "mysipdomain.com" name "s4"
    ...
    $fsn = "s4";
    t_relay();
```

Note that there is no internal check for uniqueness of the socket names,
the admin has to ensure it in order to be sure the desired socket is
selected, otherwise the first socket with a matching name is used.

As of 5.6, there is now a **virtual** identifier which can be added to
the end of each listen directive. This can be used in combination with
any other identifier, but must be added at the end of the line.

``` c
    listen=udp:10.1.1.1:5060 virtual
    listen=udp:10.0.0.10:5060 name "s1" virtual
    listen=udp:10.10.10.10:5060 advertise 11.11.11.11:5060 virtual
    listen=udp:10.10.10.20:5060 advertise "mysipdomain.com" name "s3" virtual
```

The **virtual** identifier is meant for use in situations where you have
a floating/virtual IP address on your system that may not always be
active on the system. It is particularly useful for active/active
virtual IP situations, where otherwise things like usrloc PATH support
can break due to incorrect "check_self" results.

This identifier will change the behaviour of how "myself", "is_myself"
or "check_self" matches against traffic destined to this IP address. By
default, Kamailio always considers traffic destined to a listen IP as
"local" regardless of if the IP is currently locally active. With this
flag set, Kamailio will do an extra check to make sure the IP is
currently a local IP address before considering the traffic as local.

This means that if Kamailio is listening on an IP that is not currently
local, it will recognise that, and can relay the traffic to another
Kamailio node as needed, instead of thinking it always needs to handle
the traffic.

# 38. loadmodule

Loads a module for later usage in the configuration script. The modules
is searched in the path specified by **loadpath**.

Prototype: **loadmodule "modulepath"**

If modulepath is only modulename or modulename.so, then Kamailio will
try to search also for **modulename/modulename.so**, very useful when
using directly the version compiled in the source tree.

Example of usage:

``` c
    loadpath "/usr/local/lib/kamailio/:usr/local/lib/kamailio/modules/"

    loadmodule "/usr/local/lib/kamailio/modules/db_mysql.so"
    loadmodule "modules/usrloc.so"
    loadmodule "tm"
    loadmodule "dialplan.so"
```

# 39. loadmodulex

Similar to **loadmodule** with the ability to evaluate variables in its
parameter.

# 40. loadpath

**Alias name:** **mpath**

Set the module search path. loadpath takes a list of directories
separated by ':'. The list is searched in-order. For each directory d,
$d/${module_name}.so and $d/${module_name}/${module_name}.so are tried.

This can be used to simplify the loadmodule parameter and can include
many paths separated by colon. First module found is used.

Example of usage:

``` c
    loadpath "/usr/local/lib/kamailio/modules:/usr/local/lib/kamailio/mymodules"

    loadmodule "mysql"
    loadmodule "uri"
    loadmodule "uri_db"
    loadmodule "sl"
    loadmodule "tm"
```

The proxy tries to find the modules in a smart way, e.g: loadmodule
"uri" tries to find uri.so in the loadpath, but also uri/uri.so.

# 41. local_rport ⭐️

Similar to **add_local_rport()** function, but done in a global scope,
so the function does not have to be executed for each request.

Default: off

Example:

``` c
local_rport = on
```

# 42. log_engine_data

Set specific data required by the log engine. See also the
**log_engine_type**.

``` c
log_engine_type="udp"
log_engine_data="127.0.0.1:9"
```

# 43. log_engine_type

Specify what logging engine to be used and its initialization data. A
logging engine is implemented as a module. Supported values are a matter
of the module.

For example, see the readme of **log_custom** module for more details.

``` c
log_engine_type="udp"
log_engine_data="127.0.0.1:9"
```

# 44. log_facility ⭐️

If Kamailio logs to syslog, you can control the facility for logging.
Very useful when you want to divert all Kamailio logs to a different log
file. See the man page syslog(3) for more details.

For more see:
<http://www.kamailio.org/dokuwiki/doku.php/tutorials:debug-syslog-messages>

Default value is LOG_DAEMON.

Example of usage:

      log_facility=LOG_LOCAL0

# 45. log_name ⭐️

Allows to configure a log_name prefix which will be used when printing
to syslog -- it is also known as syslog tag, and the default value is
the application name or full path that printed the log message. This is
useful to filter log messages when running many instances of Kamailio on
same server.

    log_name="kamailio-proxy-5080"

# 46. log_prefix ⭐️

Specify the text to be prefixed to the log messages printed by Kamailio
while processing a SIP message (that is, when executing route blocks).
It can contain script variables that are evaluated at runtime. See
[#log_prefix_mode](#log_prefix_mode) about when/how evaluation is done.

If a log message is printed from a part of the code executed out of
routing blocks actions (e.g., can be timer, evapi worker process, ...),
there is no log prefix set, because this one requires a valid SIP
message structure to work with.

Example - prefix with message type (1 - request, 2 - response), CSeq and
Call-ID:

    log_prefix="{$mt $hdr(CSeq) $ci} "

# 47. log_prefix_mode ⭐️

Control if [log prefix](#log_prefix) is re-evaluated.

If set to 0 (default), then log prefix is evaluated when the sip message
is received and then reused (recommended if the **log_prefix** has only
variables that have same value for same message). This is the current
behaviour of **log_prefix** evaluation.

If set to 1, then the log prefix is evaluated before/after each config
action (needs to be set when the **log_prefix** has variables that are
different based on the context of config execution, e.g., $cfg(line)).

Example:

    log_prefix_mode=1

# 48. log_stderror

With this parameter you can make Kamailio to write log and debug
messages to standard error. Possible values are:

\- "yes" - write the messages to standard error

\- "no" - write the messages to syslog

Default value is "no".

For more see:
<http://www.kamailio.org/dokuwiki/doku.php/tutorials:debug-syslog-messages>

Example of usage:

      log_stderror=yes

# 49. cfgengine

Set the config interpreter engine for execution of the routing logic
inside the configuration file. Default is the native interpreter.

Example of usage:

      cfgengine="name"
      cfgengine "name"

If name is "native" or "default", it expects to have in native config
interpreter for routing logic.

The name can be the identifier of an embedded language interpreter, such
as "lua" which is registered by the app_lua module:

      cfgengine "lua"

# 50. maxbuffer ⭐️

The size in bytes multiplied by 2 not to be exceeded during the auto-probing
procedure of discovering and increasing the maximum OS buffer size for receiving
UDP messages (socket option SO_RCVBUF). Default value is 262144.

Example of usage:

      maxbuffer=65536

Note: it is not the size of the internal SIP message receive buffer.

# 51. max_branches

The maximum number of outgoing branches for each SIP request. It has
impact on the size of destination set created in core (e.g., via
append_branch()) as well as the serial and parallel forking done via tm
module. It replaces the old defined constant MAX_BRANCHES.

The value has to be at least 1 and the upper limit is 30.

Default value: 12

Example of usage:

    max_branches=16

# 52. max_recursive_level

The parameters set the value of maximum recursive calls to blocks of
actions, such as sub-routes or chained IF-ELSE (for the ELSE branches).
Default is 256.

Example of usage:

      max_recursive_level=500

# 53. max_while_loops ⭐️

The parameters set the value of maximum loops that can be done within a
"while". Comes as a protection to avoid infinite loops in config file
execution. Default is 100. Setting to 0 disables the protection (you
will still get a warning when you start Kamailio if you do something
like while(1) {...}).

Example of usage:

      max_while_loops=200

# 54. mcast

This parameter can be used to set the interface that should join the
multicast group. This is useful if you want to **listen** on a multicast
address and don't want to depend on the kernel routing table for
choosing an interface.

The parameter is reset after each **listen** parameter, so you can join
the right multicast group on each interface without having to modify
kernel routing beforehand.

Example of usage:

      mcast="eth1"
      listen=udp:224.0.1.75:5060

# 55. mcast_loopback

It can be 'yes' or 'no'. If set to 'yes', multicast datagram are sent
over loopback. Default value is 'no'.

Example of usage:

      mcast_loopback=yes

# 56. mcast_ttl

Set the value for multicast ttl. Default value is OS specific (usually
1).

Example of usage:

      mcast_ttl=32

# 57. memdbg

**Alias name:** **mem_dbg**

This parameter specifies on which log level the memory debugger messages
will be logged. If memdbg is active, every request (alloc, free) to the
memory manager will be logged. (Note: if compile option NO_DEBUG is
specified, there will never be logging from the memory manager).

Default value: L_DBG (memdbg=3)

For example, memdbg=2 means that memory debugging is activated if the
debug level is 2 or higher.

    debug=3    # no memory debugging as debug level
    memdbg=4   # is lower than memdbg

    debug=3    # memory debugging is active as the debug level
    memdbg=2   # is higher or equal memdbg

Please see also [#memlog](#memlog) and [#debug](#debug).

# 58. memlog ⭐️

**Alias name:** **mem_log**

This parameter specifies on which log level the memory statistics will
be logged. If memlog is active, Kamailio will log memory statistics on
shutdown (or if requested via signal SIGUSR1). This can be useful for
debugging of memory leaks.

Default value: L_DBG (memlog=3)

For example, memlog=2 means that memory statistics dumping is activated
if the debug level is 2 or higher.

    debug=3    # no memory statistics as debug level
    memlog=4   # is lower than memlog

    debug=3    # dumping of memory statistics is active as the
    memlog=2   # debug level is higher or equal memlog

Please see also [#memdbg](#memdbg) and [#debug](#debug).

# 59. mem_join

If set to 1, memory manager (e.g., q_malloc) does join of free fragments.
It is effective if MEM_JOIN_FREE compile option is defined.

It can be set via config reload framework.

Default is 1 (enabled).

``` c
mem_join=1
```

To change its value at runtime, **kamcmd** needs to be used and the
modules **ctl** and **cfg_rpc** loaded. Enabling it can be done with:

    kamcmd cfg.set_now_int core mem_join 1

To disable, set its value to 0.

# 60. mem_safety

If set to 1, memory free operation does not call abort() for double
freeing a pointer or freeing an invalid address. The server still prints
the alerting log messages. If set to 0, the SIP server stops by calling
abort() to generate a core file.

It can be set via config reload framework.

Default is 1 (enabled).

``` c
mem_safety=0
```

# 61. mem_status_mode

If set to 1, memory status dump for qm allocator will print details
about used fragments. If set to 0, the dump contains only free
fragments. It can be set at runtime via cfg param framework (e.g., via
kamcmd).

Default is 0.

``` c
mem_status_mode=1
```

# 62. mem_summary

Parameter to control printing of memory debugging information displayed
on exit or SIGUSR1. The value can be composed by following flags:

- 1 - dump all the pkg used blocks (status)
- 2 - dump all the shm used blocks (status)
- 4 - summary of pkg used blocks
- 8 - summary of shm used blocks
- 16 - short status

If set to 0, nothing is printed.

Default value: 12

Example:

``` c
mem_summary=15
```

# 63. mhomed

Set the server to try to locate outbound interface on multihomed host.
This parameter affects the selection of the outgoing socket for
forwarding requests. By default is off (0) - it is rather time
consuming. When deactivated, the incoming socket will be used or the
first one for a different protocol, disregarding the destination
location. When activated, Kamailio will select a socket that can reach
the destination (to be able to connect to the remote address). (Kamailio
opens a UDP socket to the destination, then it retrieves the local IP
which was assigned by the operating system to the new UDP socket. Then
this socket will be closed and the retrieved IP address will be used as
IP address in the Via/Record-Route headers)

Example of usage:

      mhomed=1

# 64. mlock_pages

Locks all Kamailio pages into memory making it unswappable (in general
one doesn't want his SIP proxy swapped out :-))

    mlock_pages = yes |no (default no)

# 65. modinit_delay

Number of microseconds to wait after initializing a module - useful to
cope with systems where are rate limits on new connections to database
or other systems.

Default value is 0 (no wait).

    modinit_delay=100000

# 66. modparam

The modparam command will be used to set the options (parameters) for the loaded
modules.

Prototypes:

``` c
modparam("modname", "paramname", intval)
modparam("modname", "paramname", "strval")
```

The first pameter is the name of the module or a list of module names separated
by `|` (pipe). Actually, the `modname` is enclosed in beteen `^(` and `)$` and
matched with the names of the loaded modules using POSIX regexp operation. For example,
when `auth` is given, then the module name is matched with `^(auth)$`; when
`acc|auth` is given, then the module name is matched with `^(acc|auth)$`. While
using only `|` between the names of the modules is recommended for clarity, any
value that can construct a valid regular expression can be used. Note also that
`modparam` throws error only when no module name is matched and no parameter is
set. If the list of modules in `modname` includes a wrong name, Kamailio starts.
For example setting `modname` to `msilo|notamodule` does not result in a startup
error if `msilo` module is loaded. Be also careful with expressions than can
match more module names than wanted, for example setting `modname` to `a|b` can
result in matching all module names that include either `a` or `b`.

The second parameter of `modparam` is the name of the module parameter.

The third parameter of `modparam` has to be either an interger or a string value,
a matter of what the module parameter expects, as documented in the README of the
module.

Example:

``` c
modparam("usrloc", "db_mode", 2)
modparam("usrloc", "nat_bflag", 6)
modparam("auth_db|msilo|usrloc", "db_url",
    "mysql://kamailio:kamailiorw@localhost/kamailio")
```

See the documenation of the respective module to find out the available
options.

# 67. modparamx

Similar to **modparam**, with ability to evaluate the variables in its
parameters.

# 68. onsend_route_reply

If set to 1 (yes, on), onsend_route block is executed for received
replies that are sent out. Default is 0.

      onsend_route_reply=yes

# 69. open_files_limit

If set and bigger than the current open file limit, Kamailio will try to
increase its open file limit to this number. Note: Kamailio must be
started as root to be able to increase a limit past the hard limit
(which, for open files, is 1024 on most systems). "Files" include
network sockets, so you need one for every concurrent session
(especially if you use connection-oriented transports, like TCP/TLS).

Example of usage:

      open_files_limit=2048

# 70. phone2tel

By enabling this feature, Kamailio internally treats SIP URIs with
user=phone parameter as TEL URIs. If you do not want this behavior, you
have to turn it off.

Default value: 1 (enabled)

    phone2tel = 0

# 71. pmtu_discovery

If enabled, the Don't Fragment (DF) bit will be set in outbound IP
packets.

    pmtu_discovery = 0 | 1 (default 0)

# 72. port

The port the SIP server listens to. The default value for it is 5060.

Example of usage:

      port=5080

# 73. pv_buffer_size

The size in bytes of internal buffer to print dynamic strings with
pseudo-variables inside. The default value is 8192 (8kB). Please keep in
mind that for xlog messages, there is a dedicated module parameter to
set the internal buffer size.

Example of usage:

    pv_buffer_size=2048

# 74. pv_buffer_slots

The number of internal buffer slots to print dynamic strings with
pseudo-variables inside. The default value is 10.

Example of usage:

    pv_buffer_slots=12

# 75. pv_cache_limit

The limit how many pv declarations in the cache after which an action is
taken. Default value is 2048.

    pv_cache_limit=1024

# 76. pv_cache_action

Specify what action to be done when the size of pv cache is exceeded. If
0, print a warning log message when the limit is exceeded. If 1,
warning log messages is printed and the cache systems tries to drop a
$sht(...) declaration. Default is 0.

    pv_cache_action=1

# 77. rundir

Alias: run_dir

Set the folder for creating runtime files such as MI fifo or CTL
unixsocket.

Default: /var/run/kamailio

Example of usage:

    rundir="/tmp"

# 78. received_route_mode

Enable or disable the execution of event_route\[core:msg-received\]
routing block or its corresponding Kemi callback.

Default value: 0 (disabled)

Example of usage:

``` c
received_route_mode=1
```

# 79. reply_to_via

If it is set to 1, any local reply is sent to the IP address advertised
in top most Via of the request instead of the IP address from which the
request was received. Default value is 0 (off).

Example of usage:

      reply_to_via=0

# 80. route_locks_size

Set the number of mutex locks to be used for synchronizing the execution
of config script for messages sharing the same Call-Id. In other words,
enables Kamailio to execute the config script sequentially for the
requests and replies received within the same dialog -- a new message
received within the same dialog waits until the previous one is routed
out.

For smaller impact on parallel processing, its value it should be at
least twice the number of Kamailio processes (all children processes).

Example:

``` c
route_locks_size = 256
```

Note that ordering of the SIP messages can still be changed by network
transmission (quite likely for UDP, especially on long distance paths)
or CPU allocation for processes when executing pre-config and
post-config tasks (very low chance, but not to be ruled out completely).

# 81. server_id

A configurable unique server id that can be used to discriminate server
instances within a cluster of servers when all other information, such
as IP addresses are the same.

``` c
  server_id = number
```

# 82. server_header ⭐️

Set the value of Server header for replies generated by Kamailio. It
must contain the header name, but not the ending CRLF.

Example of usage:

``` c
server_header="Server: My Super SIP Server"
```

# 83. server_signature ⭐️

This parameter controls the "Server" header in any locally generated
message.

Example of usage:

       server_signature=no

If it is enabled (default=yes) a header is generated as in the following
example:

       Server: Kamailio (<version> (<arch>/<os>))

# 84. shm_force_alloc

Tries to pre-fault all the shared memory, before starting. When "on",
start time will increase, but combined with mlock_pages will guarantee
Kamailio will get all its memory from the beginning (no more kswapd slow
downs)

shm_force_alloc = yes \| no (default no)

# 85. shm_mem_size

Set shared memory size (in Mb).

shm_mem_size = 64 (default 64)

# 86. sip_parser_log

Log level for printing debug messages for some of the SIP parsing
errors.

Default: 0 (L_WARN)

``` c
sip_parser_log = 1
```

# 87. sip_parser_mode ⭐️

Control sip parser behaviour.

If set to 1, the parser is more strict in accepting messages that have
invalid headers (e.g., duplicate To or From). It can make the system
safer, but loses the flexibility to be able to fix invalid messages with
config operations.

If set to 0, the parser is less strict on checking validity of headers.

Default: 1

``` c
sip_parser_mode = 0
```

# 88. sip_warning (noisy feedback)

Can be 0 or 1. If set to 1 (default value is 0) a 'Warning' header is
added to each reply generated by Kamailio. The header contains several
details that help troubleshooting using the network traffic dumps, but
might reveal details of your network infrastructure and internal SIP
routing.

Example of usage:

      sip_warning=0

# 89. socket_workers

Number of workers to process SIP traffic per listen socket - typical use
is before a **listen** global parameter.

- when used before **listen** on UDP or SCTP socket, it overwrites
    **children** or **sctp_children** value for that socket.
- when used before **listen** on TCP or TLS socket, it adds extra tcp
    workers, these handling traffic only on that socket.

The value of **socket_workers** is reset with next **listen** socket
definition that is added, thus use it for each **listen** socket where
you want custom number of workers.

If this parameter is not used at all, the values for **children**,
**tcp_children** and **sctp_children** are used as usually.

Example for udp sockets:

``` c
children=4
socket_workers=2
listen=udp:127.0.0.1:5080
listen=udp:127.0.0.1:5070
listen=udp:127.0.0.1:5060
```

- it will start 2 workers to handle traffic on udp:127.0.0.1:5080
    and 4 for each of udp:127.0.0.1:5070 and udp:127.0.0.1:5060. In
    total there are 10 worker processes

Example for tcp sockets:

``` c
children=4
socket_workers=2
listen=tcp:127.0.0.1:5080
listen=tcp:127.0.0.1:5070
listen=tcp:127.0.0.1:5060
```

- it will start 2 workers to handle traffic on tcp:127.0.0.1:5080 and
    4 to handle traffic on both tcp:127.0.0.1:5070 and
    tcp:127.0.0.1:5060. In total there are 6 worker processes

# 90. sql_buffer_size ⭐️

The size in bytes of the SQL buffer created for data base queries. For
database drivers that use the core db_query library, this will be
maximum size object that can be written or read from a database. Default
value is 65535.

Example of usage:

      sql_buffer_size=131070

# 91. statistics ⭐️

Kamailio has built-in support for statistics counter. This means, these
counters can be increased, decreased, read and cleared. The statistics
counter are defined either by the core (e.g. tcp counters), by modules
(e.g. 2xx_transactions by "tmx" module) or by the script writer using
the "statistics" module.

The statistics counters are read/updated either automatically by
Kamailio internally (e.g. tcp counters), by the script writer via the
module functions of the "statistics" module, by the script writer using
the $stat() pseudo variable (read-only), or via MI commands.

Following are some examples how to access statistics variables:

**script:**

    modparam("statistics", "variable", "NOTIFY")

    (if method == "NOTIFY") {
      update_stat("NOTIFY", "+1");
    }

    xlog("Number of received NOTIFYs: $stat(NOTIFY)");

**MI:**

    # get counter value
    kamctl fifo get_statistics NOTIFY
    # set counter to zero
    kamctl fifo reset_statistics NOTIFY
    # get counter value and then set it to zero
    kamctl fifo clear_statistics NOTIFY

    # or use the kamcmd tool
    kamcmd mi get_statistics 1xx_replies

# 92. stats_name_separator

Specify the character used as a separator for the internal statistics'
names. Default value is "\_".

Example of usage:

      stats_name_separator = "-"

# 93. tos

The TOS (Type Of Service) to be used for the sent IP packages (both TCP
and UDP).

Example of usage:

      tos=IPTOS_LOWDELAY
      tos=0x10
      tos=IPTOS_RELIABILITY

# 94. udp_mtu ⭐️

Fallback to another protocol (udp_mtu_try_proto must be set also either
globally or per packet) if the constructed request size is greater than
udp_mtu.

RFC 3261 specified size: 1300. Default: 0 (off).

    udp_mtu = number

# 95. udp_mtu_try_proto

If udp_mtu !=0 and udp forwarded request size (after adding all the
"local" headers) \> udp_mtu, use this protocol instead of udp. Only the
Via header will be updated (e.g. The Record-Route will be the one built
for udp).

**Warning:** Although RFC3261 mandates automatic transport protocol
changing, enabling this feature can lead to problems with clients which
do not support other protocols or are behind a firewall or NAT. Use this
only when you know what you do!

See also udp_mtu_try_proto(proto) function.

Default: UDP (off). Recommended: TCP.

    udp_mtu_try_proto = TCP|TLS|SCTP|UDP

# 96. uri_host_extra_chars

Specify additional chars that should be allowed in the host part of URI.

``` c
uri_host_extra_chars = "_"
```

# 97. user ⭐️

**Alias name:** **uid**

The user id to run Kamailio (Kamailio will suid to it).

Example of usage:

``` c
    user="kamailio"
```

# 98. user_agent_header ⭐️

Set the value of User-Agent header for requests generated by Kamailio.
It must contain header name as well, but not the ending CRLF.

``` c
user_agent_header="User-Agent: My Super SIP Server"
```

# 99. verbose_startup ⭐️

Control if printing routing tree and udp probing buffer debug messages
should be printed at startup.

Default is 0 (don't print); set to 1 to get those debug messages.

Example of usage:

``` c
   verbose_startup=1
```

# 100. version_table ⭐️

Set the name of the table holding the table version. Useful if the proxy
is sharing a database within a project and during upgrades. Default
value is "version".

Example of usage:

``` c
   version_table="version44"
```

# 101. wait_worker1_mode

Enable waiting for child SIP worker one to complete initialization, then
create the other child worker processes.

Default: 0 (do not wait for child worker one to complete
initialization).

Example:

``` c
wait_worker1_mode = 1
```

# 102. wait_worker1_time

How long to wait for child worker one to complete the initialization. In
micro-seconds.

Default: 4000000 (micro-seconds = 4 seconds).

Example:

``` c
wait_worker1_time = 1000000
```

# 103. wait_worker1_usleep

Waiting for child worker one to complete the initialization is done in
a loop, which loop waits until wait_worker1_time passes.  This parameter
specifies how long after each iteration of that loop to wait in micro-seconds.

Default: 100000 (micro-seconds = 0.1 seconds).

Example:

``` c
wait_worker1_usleep = 50000
```

# 104. workdir ⭐️

> coredump 目录！！

**Alias name:** **wdir**

The working directory used by Kamailio at runtime. You might find it
useful when it comes to generating core files :)

Example of usage:

       wdir="/usr/local/kamailio"
       or
       wdir=/usr/kam_wd

# 105. xavp_via_params

Set the name of the XAVP of which subfields will be added as local *Via*
-header parameters.

If not set, XAVP to Via header parameter manipulation is not applied
(default behaviour).

If set, local Via header gets additional parameters from defined XAVP.
Core flag FL_ADD_XAVP_VIA_PARAMS needs to be set¹.

Example:

       xavp_via_params="via"

\[1\] See function *via_add_xavp_params()* from "corex" module.

# 106. xavp_via_fields

Set the name of xavp from where to take Via header field: address and
port. Use them to build local Via header.

Example:

``` c
xavp_via_fields="customvia"

request_route {
  ...
  $xavp(customvia=>address) = "1.2.3.4";
  $xavp(customvia=>port) = "5080";  # must be string
  via_use_xavp_fields("1");
  t_relay();
}
```

See function *via_use_xavp_fields()* from "corex" module.