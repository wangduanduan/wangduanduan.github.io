---
title: "cachedb的相关问题"
date: "2021-04-21 18:08:05"
draft: false
---

# 底层可用
- local 缓存存在本地，速度快，但是多实例无法共享，重启后消失
- redis 缓存存在redis, 多实例可以共享，重启后不消失



# 接口

- store -[cache_store()](https://www.opensips.org/Documentation/Script-CoreFunctions#toc101) 存储
- fetch -[cache_fetch()](https://www.opensips.org/Documentation/Script-CoreFunctions#toc102) 获取
- remove -[cache_remove()](https://www.opensips.org/Documentation/Script-CoreFunctions#toc103) 删除
- add -[cache_add()](https://www.opensips.org/Documentation/Script-CoreFunctions#toc104) 递增
- sub -[cache_sub()](https://www.opensips.org/Documentation/Script-CoreFunctions#toc105) 递减
- cache_counter_fetch 获取某个key的值


# 关于过期的单位
虽然文档上没有明说，但是过期的单位都是秒。


# cachedb_local过期
```bash
loadmodule "cachedb_local.so"
modparam("cachedb_local", "cachedb_url", "local://")
modparam("cachedb_local", "cache_clean_period", 600)

route[xxx]{
		cache_add("local", "$fu", 100, 5);
}
```

假如说：在5秒之内，同一个$fu来了多个请求，在设置这个$fu值的时候，计时器是不会重置的。过期的计时器还是第一次的设置的那个时间点开始计时。


# 参考

- [https://www.opensips.org/Documentation/Tutorials-KeyValueInterface](https://www.opensips.org/Documentation/Tutorials-KeyValueInterface)

