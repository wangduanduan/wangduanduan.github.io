---
title: "ModuleNotFoundError: No module named 'SocketServer'"
date: "2020-07-02 15:54:42"
draft: false
---
python Flask框架报错。刚开始我只关注了这个报错，没有看到这个报错上上面还有一个报错

```
ModuleNotFoundError: No module named 'http.client'; 'http' is not a package
```

实际上问题的关键其实是 `'http' is not a package` , 为什么会有这个报错呢？

其实因为我自己在项目目录里新建一个叫做http.py的文件，这个文件名和python的标准库重名了，就导致了后续的一系列的问题。



# 问题总结

- 文件名一定不要和某些标准库的文件名相同
- 排查问题的时候，一定要首先排查最先出现问题的点

