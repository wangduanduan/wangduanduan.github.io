---
title: "avp_db_query数值null值比较"
date: "2021-09-29 19:13:26"
draft: false
---
[avp_db_query](https://opensips.org/docs/modules/2.4.x/avpops.html#func_avp_db_query)是用来做数据库查询的，如果查到某列的值是NULL, 那么对应到脚本里应该如何比较呢？

可以用avp的值与"<null>"， 进行比较

```
if ($avp(status) == "<null>")
```


# 参考

- [https://stackoverflow.com/questions/52675803/opensips-avp-db-query-cant-compare-null-value](https://stackoverflow.com/questions/52675803/opensips-avp-db-query-cant-compare-null-value)

