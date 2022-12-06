---
title: "mysql placeholder的错误使用方式"
date: 2021-10-03T21:52:40+08:00
---

{{< notice error >}}

EXTRA *mysql.MySQLError=Error 1064: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '? (

{{< /notice >}}


然而我仔细看了看sql语句，没有看出来究竟哪里有sql报错。

然而当我把作为placeholder的问号去掉，直接用表的名字，sql是可以直接执行的。我意识到这个可能是和placeholder有关。

搜索了一下，看到一个链接 https://github.com/go-sql-driver/mysql/issues/848

> Placeholder can't be used for table name or column name. It's MySQL spec. Not bug of this project.

大意是说，placeholder是不能作为表名或者列名的。

在mysql关于prepared文档介绍中，在允许使用prepared的语句里，没有看到create table可以用placeholder
https://dev.mysql.com/doc/refman/8.0/en/sql-prepared-statements.html 

prepared语句的优点有以下几个
- 优化查询速度
- 防止sql注入

但是也有一些限制
- 不是所有语句都能用prepared语句。常见的用法应该是作为select where之后的条件，或者INSERT语句之后的值
- 不支持一个sql中多条查询语句的形式

