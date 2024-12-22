---
title: "kamailio 启动参数控制"
date: "2024-12-22 15:46:13"
draft: false
type: posts
tags:
- all
categories:
- all
---

```sh
    -a mode      Auto aliases mode: enable with yes or on,
                  disable with no or off
                  一般都是关闭

    --alias=val  Add an alias, the value has to be '[proto:]hostname[:port]'
                  (like for 'alias' global parameter)
                  设置对外别名, 在多个对外别名时，相比于在脚本中写死, 更好的方式
                  是在启动时传入, alias一般都是服务的对外域名或者IP
                  如果km有多个对外域名，并且不同的环境都不同，这块配置就合适在脚本里写死

    --atexit=val Control atexit callbacks execution from external libraries
                  which may access destroyed shm memory causing crash on shutdown.
                  Can be y[es] or 1 to enable atexit callbacks, n[o] or 0 to disable,
                  default is no.
                  没用过

    -A define    Add config pre-processor define (e.g., -A WITH_AUTH,
                  -A 'FLT_ACC=1', -A 'DEFVAL="str-val"')
                  预处理的变量定义

    -b nr        Maximum OS UDP receive buffer size which will not be exceeded by
                  auto-probing-and-increase procedure even if OS allows

    -B nr        Maximum OS UDP send buffer size which will not be exceeded by
                  auto-probing-and-increase procedure even if OS allows
                  这和上面的有啥区别呢？

    -c           Check configuration file for syntax errors
                可以检查配置文件的语法错误。如果这个选项开启，就只能做检查语法，而不能启动kama

    --cfg-print  Print configuration file evaluating includes and ifdefs
                 在脚本里有很多预处理指令时，可以用这个参数打印出预处理之后的脚本 

    -d           Debugging level control (multiple -d to increase the level from 0)
                调试界别
    --debug=val  Debugging level value

    -D           Control how daemonize is done:
                  -D..do not fork (almost) anyway;
                  -DD..do not daemonize creator;
                  -DDD..daemonize (default)
                控制是否开启守护进程

    -e           Log messages printed in terminal colors (requires -E)
    -E           Log to stderr

    -f file      Configuration file (default: /usr/local/etc/kamailio/kamailio.cfg)
                设置配置文件的位置, 可以覆盖默认的位置

    -g gid       Change gid (group id)

    -G file      Create a pgid file

    -h           This help message

    --help       Long option for `-h`

    -I           Print more internal compile flags and options

    -K           Turn on "via:" host checking when forwarding replies

    -l address   Listen on the specified address/interface (multiple -l
                  mean listening on more addresses). The address format is
                  [proto:]addr_lst[:port][/advaddr][/socket_name], 
                  where proto=udp|tcp|tls|sctp, 
                  addr_lst= addr|(addr, addr_lst), 
                  addr=host|ip_address|interface_name, 
                  advaddr=addr[:port] (advertised address) and 
                  socket_name=identifying name.
                  E.g: -l localhost, -l udp:127.0.0.1:5080, -l eth0:5062,
                  -l udp:127.0.0.1:5080/1.2.3.4:5060,
                  -l udp:127.0.0.1:5080//local,
                  -l udp:127.0.0.1:5080/1.2.3.4:5060/local,
                  -l "sctp:(eth0)", -l "(eth0, eth1, 127.0.0.1):5065".
                  The default behaviour is to listen on all the interfaces.
                控制listen的地址
    --loadmodule=name load the module specified by name

    --log-engine=log engine name and data

    -L path      Modules search path (default: /usr/local/lib64/kamailio/modules)

    -m nr        Size of shared memory allocated in Megabytes
                共享内存的大小设置

    --modparam=modname:paramname:type:value set the module parameter
                  type has to be 's' for string value and 'i' for int value, 
                  example: --modparam=corex:alias_subdomains:s:kamailio.org
                  设置模块的启动参数
                  对于不方便在脚本里写死的模块参数，这个方式也挺好用

    --all-errors Print details about all config errors that can be detected
                调试模式比较好用，打印详细的日志报错 

    -M nr        Size of private memory allocated, in Megabytes
                控制私有内存的大小

    -n processes Number of child processes to fork per interface
                  (default: 8)

    -N           Number of tcp child processes (default: equal to `-n')

    -O nr        Script optimization level (debugging option)

    -P file      Create a pid file

    -Q           Number of sctp child processes (default: equal to `-n')

    -r           Use dns to check if is necessary to add a "received="
                  field to a via

    -R           Same as `-r` but use reverse dns;
                  (to use both use `-rR`)

    --server-id=num set the value for server_id

    --subst=exp set a subst preprocessor directive
    --substdef=exp set a substdef preprocessor directive
    --substdefs=exp set a substdefs preprocessor directive

    -S           disable sctp

    -t dir       Chroot to "dir"

    -T           Disable tcp

    -u uid       Change uid (user id)

    -v           Version number

    --version    Long option for `-v`

    -V           Alternative for `-v`

    -x name      Specify internal manager for shared memory (shm)
                  - can be: fm, qm or tlsf

    -X name      Specify internal manager for private memory (pkg)
                  - if omitted, the one for shm is used

    -Y dir       Runtime dir path

    -w dir       Change the working directory to "dir" (default: "/")

    -W type      poll method (depending on support in OS, it can be: poll,
                  epoll_lt, epoll_et, sigio_rt, select, kqueue, /dev/poll)
```

