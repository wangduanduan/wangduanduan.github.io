---
title: "MySql索引"
date: "2019-10-22 10:36:24"
draft: false
---
prd是表名，agent是表中的一个字段，index_agent是索引名

```sql
create index index_agent on prd(agent) # 创建索引
show index from prd # 显示表上有哪些索引
drop index index_agent on prd # 删除索引
```

创建索引的好处是查询速度有极大的提成，坏处是更新记录时，有可能也会更新索引，从而降低性能。

所以索引比较适合那种只写入，或者查询，但是一般不会更新的数据。

