---
title: "优雅的使用xlog输出日志行"
date: "2019-06-16 11:16:32"
draft: false
---
在opensips 2.2中加入新的全局配置cfg_line, 用来返回当前日志在整个文件中的行数。

注意，低于2.2的版本不能使用cfg_line。

使用方法如下：

```bash
...
xlog("$cfg_line enter_ack_deal")
...
xlog("$cfg_line enter_ack_deal")
...
```

如果没有cfg_line这个参数，你在日志中看到enter_ack_deal后，根本无法区分是哪一行打印了这个关键词。

使用了cfg_line后，可以在日志中看到类似如下的日志输出方式，很容易区分哪一行日志执行了。

```bash
23 enter_ack_deal
823 enter_ack_deal
```


