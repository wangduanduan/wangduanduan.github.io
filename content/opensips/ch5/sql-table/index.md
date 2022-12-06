---
title: "mysql建表语句"
date: "2022-02-24 10:47:23"
draft: false
---
OpenSIPS需要用数据库持久化数据，常用的是mysql。

可以参考这个官方的教程去初始化数据库的数据 [https://www.opensips.org/Documentation/Install-DBDeployment-2-4](https://www.opensips.org/Documentation/Install-DBDeployment-2-4)

如果你想自己创建语句，也是可以的，实际上建表语句在OpenSIPS安装之后，已经被保存在你的电脑上。

一般位于  /usr/local/share/opensips/mysql 目录中
```bash
cd /usr/local/share/opensips/mysql
ls
acc-create.sql          call_center-create.sql   dispatcher-create.sql            group-create.sql          rls-create.sql        uri_db-create.sql
alias_db-create.sql     carrierroute-create.sql  domain-create.sql                imc-create.sql            rtpengine-create.sql  userblacklist-create.sql
auth_db-create.sql      closeddial-create.sql    domainpolicy-create.sql          load_balancer-create.sql  rtpproxy-create.sql   usrloc-create.sql
avpops-create.sql       clusterer-create.sql     drouting-create.sql              msilo-create.sql          siptrace-create.sql
b2b-create.sql          cpl-create.sql           emergency-create.sql             permissions-create.sql    speeddial-create.sql
b2b_sca-create.sql      dialog-create.sql        fraud_detection-create.sql       presence-create.sql       standard-create.sql
cachedb_sql-create.sql  dialplan-create.sql      freeswitch_scripting-create.sql  registrant-create.sql     tls_mgm-create.sql
```

