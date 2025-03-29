---
title: "1.18 命令行参数"
draft: false
tags:
- all
categories:
- all
---


# Command Line Parameters

Kamailio can be started with a set of command line parameters, providing
more flexibility to control what is doing at runtime. Some of them can
be quite useful when running on containerised environments.

To see the the available command line parameters, run **kamailio -h**:

    # kamailio -h

    version: kamailio 5.4.0-dev4 (x86_64/darwin) 8c1864
    Usage: kamailio [options]
    Options:
        -a mode      Auto aliases mode: enable with yes or on,
                      disable with no or off
        --alias=val  Add an alias, the value has to be '[proto:]hostname[:port]'
                      (like for 'alias' global parameter)
        -A define    Add config pre-processor define (e.g., -A WITH_AUTH,
                      -A 'FLT_ACC=1', -A 'DEFVAL="str-val"')
        -b nr        Maximum receive buffer size which will not be exceeded by
                      auto-probing procedure even if  OS allows
        -c           Check configuration file for syntax errors
        -d           Debugging mode (multiple -d increase the level)
        -D           Control how daemonize is done:
                      -D..do not fork (almost) anyway;
                      -DD..do not daemonize creator;
                      -DDD..daemonize (default)
        -e           Log messages printed in terminal colors (requires -E)
        -E           Log to stderr
        -f file      Configuration file (default: /usr/local/etc/kamailio/kamailio.cfg)
        -g gid       Change gid (group id)
        -G file      Create a pgid file
        -h           This help message
        --help       Long option for `-h`
        -I           Print more internal compile flags and options
        -K           Turn on "via:" host checking when forwarding replies
        -l address   Listen on the specified address/interface (multiple -l
                      mean listening on more addresses). The address format is
                      [proto:]addr_lst[:port][/advaddr],
                      where proto=udp|tcp|tls|sctp,
                      addr_lst= addr|(addr, addr_lst),
                      addr=host|ip_address|interface_name and
                      advaddr=addr[:port] (advertised address).
                      E.g: -l localhost, -l udp:127.0.0.1:5080, -l eth0:5062,
                      -l udp:127.0.0.1:5080/1.2.3.4:5060,
                      -l "sctp:(eth0)", -l "(eth0, eth1, 127.0.0.1):5065".
                      The default behaviour is to listen on all the interfaces.
        --loadmodule=name load the module specified by name
        --log-engine=log engine name and data
        -L path      Modules search path (default: /usr/local/lib64/kamailio/modules)
        -m nr        Size of shared memory allocated in Megabytes
        --modparam=modname:paramname:type:value set the module parameter
                      type has to be 's' for string value and 'i' for int value,
                      example: --modparam=corex:alias_subdomains:s:kamailio.org
        -M nr        Size of private memory allocated, in Megabytes
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