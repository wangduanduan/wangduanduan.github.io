---
title: "opensips管理命令"
date: "2019-06-13 22:03:19"
draft: false
---
可以使用一下命令查找opensips的相关文件夹

```bash
find / -name opensips -type d
```

一般来说，重要的是opensips.cfg文件，这个文件一般位于`/usr/local/etc/opensips/`或者`/usr/etc/opensips`中。主要还是要看安装时选择的默认路径。

其中1.x版本的配置文件一般位于`/usr/etc/opensips`目录中，2.x版本的配置一般位于`/usr/local/etc/opensips`目录中。

下面主要讲解几个命令。


# 配置文件校验

校验opensips.cfg脚本是否合法, 如果有问题，会提示那行代码有问题，但是报错位置好像一直不准确。很多时候可能是忘记写分好了。

```bash
opensips -C opensips.cfg
```



# 启动关闭与重启

使用opensipsctl命令做数据库操作前，需要先配置opensipsctlrc文件

```bash
opensips start|stop|restart

opensipsctl start|stop|restart




```


# 资源创建

```bash
opensipsdbctl create # 创建数据库
opensipsctl domain add abc.cc #创建域名
opensipsctl add 1001@test.cc 12346 # 新增用户
opensipsctl rm 1001@test.cc # 删除用户
opensipsctl passwdd 1001@test.cc 09879 # 修改密码
```

opensipsctl -h 显示所有可用命令

```bash
/usr/local/sbin/opensipsctl $Revision: 4448 $

Existing commands:

 -- command 'start|stop|restart|trap'

 trap ............................... trap with gdb OpenSIPS processes
 restart ............................ restart OpenSIPS
 start .............................. start OpenSIPS
 stop ............................... stop OpenSIPS

 -- command 'acl' - manage access control lists (acl)

 acl show [<username>] .............. show user membership
 acl grant <username> <group> ....... grant user membership (*)
 acl revoke <username> [<group>] .... grant user membership(s) (*)

 -- command 'cr' - manage carrierroute tables

 cr show ....................................................... show tables
 cr reload ..................................................... reload tables
 cr dump ....................................................... show in memory tables
 cr addrt <routing_tree_id> <routing_tree> ..................... add a tree
 cr rmrt  <routing_tree> ....................................... rm a tree
 cr addcarrier <carrier> <scan_prefix> <domain> <rewrite_host> ................
               <prob> <strip> <rewrite_prefix> <rewrite_suffix> ...............
               <flags> <mask> <comment> .........................add a carrier
               (prob, strip, rewrite_prefix, rewrite_suffix,...................
                flags, mask and comment are optional arguments) ...............
 cr rmcarrier  <carrier> <scan_prefix> <domain> ................ rm a carrier

 -- command 'rpid' - manage Remote-Party-ID (RPID)

 rpid add <username> <rpid> ......... add rpid for a user (*)
 rpid rm <username> ................. set rpid to NULL for a user (*)
 rpid show <username> ............... show rpid of a user

 -- command 'add|passwd|rm' - manage subscribers

 add <username> <password> .......... add a new subscriber (*)
 passwd <username> <passwd> ......... change user's password (*)
 rm <username> ...................... delete a user (*)

 -- command 'add|dump|reload|rm|show' - manage address

 address show ...................... show db content
 address dump ...................... show cache content
 address reload .................... reload db table into cache
 address add <grp> <ip> <mask> <port> <proto> [<context_info>] [<pattern>]
             ....................... add a new entry
	     ....................... (from_pattern and tag are optional arguments)
 address rm <grp> <ip> <mask> <port> ............... remove all entries
	     ....................... for the given grp ip mask port

 -- command 'dr' - manage dynamic routing

   * Examples: dr addgw '1' 10 '192.168.2.2' 0 '' 'GW001' 0 'first_gw'
   *           dr addgw '2' 20 '192.168.2.3' 0 '' 'GW002' 0 'second_gw'
   *           dr rmgw 2
   *           dr addgrp 'alice' 'example.com' 10 'first group'
   *           dr rmgrp 1
   *           dr addcr 'cr_1' '10' 0 'CARRIER_1' 'first_carrier'
   *           dr rmcr 1
   *           dr addrule '10,20' '+1' '20040101T083000' 0 0 '1,2' 'NA_RULE' 'NA routing'
   *           dr rmrule 1
 dr show ............................ show dr tables
 dr addgw <gwid> <type> <address> <strip> <pri_prefix>
          <attrs> <probe_mode> <description>
    ................................. add gateway
 dr rmgw <id> ....................... delete gateway
 dr addgrp <username> <domain> <groupid> <description>
    ................................. add gateway group
 dr rmgrp <id> ...................... delete gateway group
 dr addcr <carrierid> <gwlist> <flags> <attrs> <description>
          ........................... add carrier
 dr rmcr <id> ....................... delete carrier
 dr addrule <groupid> <prefix> <timerec> <priority> <routeid>
            <gwlist> <attrs> <description>
    ................................. add rule
 dr rmrule <ruleid> ................. delete rule
 dr reload .......................... reload dr tables
 dr gw_status ....................... show gateway status
 dr carrier_status .................. show carrier status

 -- command 'dispatcher' - manage dispatcher

   * Examples:  dispatcher addgw 1 sip:1.2.3.1:5050 '' 0 50 'og1' 'Outbound Gateway1'
   *            dispatcher addgw 2 sip:1.2.3.4:5050 '' 0 50 'og2' 'Outbound Gateway2'
   *            dispatcher rmgw 4
 dispatcher show ..................... show dispatcher gateways
 dispatcher reload ................... reload dispatcher gateways
 dispatcher dump ..................... show in memory dispatcher gateways
 dispatcher addgw <setid> <destination> <socket> <state> <weight> <attrs> [description]
            .......................... add gateway
 dispatcher rmgw <id> ................ delete gateway

 -- command 'registrant' - manage registrants

   * Examples:  registrant add sip:opensips.org '' sip:user@opensips.org '' user password sip:user@localhost '' 3600 ''
 registrant show ......................... show registrant table
 registrant dump ......................... show registrant status
 registrant add <registrar> <proxy> <aor> <third_party_registrant>
                <username> <password> <binding_URI> <binding_params>
                <expiry> <forced_socket> . add a registrant
 registrant rm ........................... removes the entire registrant table
 registrant rmaor <id> ................... removes the gived aor id

 -- command 'db' - database operations

 db exec <query> ..................... execute SQL query
 db roexec <roquery> ................. execute read-only SQL query
 db run <id> ......................... execute SQL query from $id variable
 db rorun <id> ....................... execute read-only SQL query from
                                       $id variable
 db show <table> ..................... display table content

 -- command 'speeddial' - manage speed dials (short numbers)

 speeddial show <speeddial-id> ....... show speeddial details
 speeddial list <sip-id> ............. list speeddial for uri
 speeddial add <sip-id> <sd-id> <new-uri> [<desc>] ...
           ........................... add a speedial (*)
 speeddial rm <sip-id> <sd-id> ....... remove a speeddial (*)
 speeddial help ...................... help message
    - <speeddial-id>, <sd-id> must be an AoR (username@domain)
    - <sip-id> must be an AoR (username@domain)
    - <new-uri> must be a SIP AoR (sip:username@domain)
    - <desc> a description for speeddial

 -- command 'avp' - manage AVPs

 avp list [-T table] [-u <sip-id|uuid>]
     [-a attribute] [-v value] [-t type] ... list AVPs
 avp add [-T table] <sip-id|uuid>
     <attribute> <type> <value> ............ add AVP (*)
 avp rm [-T table]  [-u <sip-id|uuid>]
     [-a attribute] [-v value] [-t type] ... remove AVP (*)
 avp help .................................. help message
    - -T - table name
    - -u - SIP id or unique id
    - -a - AVP name
    - -v - AVP value
    - -t - AVP name and type (0 (str:str), 1 (str:int),
                              2 (int:str), 3 (int:int))
    - <sip-id> must be an AoR (username@domain)
    - <uuid> must be a string but not AoR

 -- command 'alias_db' - manage database aliases

 alias_db show <alias> .............. show alias details
 alias_db list <sip-id> ............. list aliases for uri
 alias_db add <alias> <sip-id> ...... add an alias (*)
 alias_db rm <alias> ................ remove an alias (*)
 alias_db help ...................... help message
    - <alias> must be an AoR (username@domain)"
    - <sip-id> must be an AoR (username@domain)"

 -- command 'domain' - manage local domains

 domain reload ....................... reload domains from disk
 domain show ......................... show current domains in memory
 domain showdb ....................... show domains in the database
 domain add <domain> ................. add the domain to the database
 domain rm <domain> .................. delete the domain from the database

 -- command 'cisco_restart' - restart CISCO phone (NOTIFY)

 cisco_restart <uri> ................ restart phone configured for <uri>

 -- command 'online' - dump online users from memory

 online ............................. display online users

 -- command 'monitor' - show internal status

 monitor ............................ show server's internal status

 -- command 'ping' - ping a SIP URI (OPTIONS)

 ping <uri> ......................... ping <uri> with SIP OPTIONS

 -- command 'ul' - manage user location records

 ul show [<username>]................ show in-RAM online users
 ul show --brief..................... show in-RAM online users in short format
 ul rm <username> [<contact URI>].... delete user's usrloc entries
 ul add <username> <uri> ............ introduce a permanent usrloc entry
 ul add <username> <uri> <expires> .. introduce a temporary usrloc entry

 -- command 'fifo'

 fifo ............................... send raw FIFO command

➜  ~ opopensipsctl ul
/bin/bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
ERROR: usrloc - too few parameters

 -- command 'ul' - manage user location records

 ul show [<username>]................ show in-RAM online users
 ul show --brief..................... show in-RAM online users in short format
 ul rm <username> [<contact URI>].... delete user's usrloc entries
 ul add <username> <uri> ............ introduce a permanent usrloc entry
 ul add <username> <uri> <expires> .. introduce a temporary usrloc entry
```



# opensips命令

opensips -h

有时候，你用opensipsctl start 启动opensips时，你可能会想，opensips是从哪个目录读取opensips.cfg文件的，那你可以输入opensips -h。输出的结果，第一行就包括了默认的配置文件的位置。

```bash
 -f file      Configuration file (default /usr/local//etc/opensips/opensips.cfg)
    -c           Check configuration file for errors
    -C           Similar to '-c' but in addition checks the flags of exported
                  functions from included route blocks
    -l address   Listen on the specified address/interface (multiple -l
                  mean listening on more addresses).  The address format is
                  [proto:]addr[:port], where proto=udp|tcp and
                  addr= host|ip_address|interface_name. E.g: -l locahost,
                  -l udp:127.0.0.1:5080, -l eth0:5062 The default behavior
                  is to listen on all the interfaces.
    -n processes Number of worker processes to fork per UDP interface
                  (default: 8)
    -r           Use dns to check if is necessary to add a "received="
                  field to a via
    -R           Same as `-r` but use reverse dns;
                  (to use both use `-rR`)
    -v           Turn on "via:" host checking when forwarding replies
    -d           Debugging mode (multiple -d increase the level)
    -D           Run in debug mode
    -F           Daemon mode, but leave main process foreground
    -E           Log to stderr
    -N processes Number of TCP worker processes (default: equal to `-n`)
    -W method    poll method
    -V           Version number
    -h           This help message
    -b nr        Maximum receive buffer size which will not be exceeded by
                  auto-probing procedure even if  OS allows
    -m nr        Size of shared memory allocated in Megabytes 默认32MB
    -M nr        Size of pkg memory allocated in Megabytes    默认2MB
    -w dir       Change the working directory to "dir" (default "/")
    -t dir       Chroot to "dir"
    -u uid       Change uid
    -g gid       Change gid
    -P file      Create a pid file
    -G file      Create a pgid file
```


