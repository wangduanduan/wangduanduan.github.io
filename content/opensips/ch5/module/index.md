---
title: "脚本路由模块化"
date: "2019-06-16 11:22:56"
draft: false
---
当你的代码一个屏幕无法展示完时，你就需要考虑模块化的事情了。

维护一个上千行的代码，是很辛苦，也是很恐怖的事情。

我们应当把自己的关注点放在某个具体的点上。


# 方法1 include_file

具体方法是使用include_file参数。

如果你的opensips.cfg文件到达上千行，你可以考虑使用一下include_file指令。

```bash
include_file "global.cfg"
include_file "moudule.cfg"
include_file "routing.cfg"
```



# 方法2 m4 宏编译

参考：[https://github.com/wangduanduan/m4-opensips.cfg](https://github.com/wangduanduan/m4-opensips.cfg)

