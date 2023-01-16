---
title: "MySql表复制 与 调整字段"
date: "2019-10-10 21:30:20"
draft: false
---

# 表复制

```python
# 不跨数据库
insert into subscriber_copy(id, username) select id, username from subscriber

# 跨数据库 需要在表名前加上数据库名
insert into wdd.test(id, username) select id, username from opensips.subscriber
```


# 调整表结构

## 增加字段
```python
ALTER TABLE test ADD `username` char(64) not null default ''
```


