---
title: "函数特点"
date: "2019-06-16 10:48:57"
draft: false
---
opensips脚本中没有类似function这样的关键字来定义函数，它的函数主要有两个来源。

1. opensips核心提供的函数: 
2. 模块提供的函数: lb_is_destination(), consume_credentials()

# 函数特点

opensips函数的特点

1. 最多支持6个参数
2. 所有的参数都是字符串，即使写成数字，解析时也按照字符串解析
3. 函数的返回值只能是整数
4. 所有函数不能返回0，返回0会导致路由停止执行，return(0)相当于exit()
5. 函数返回的正数可以翻译成true
6. 函数返回的负数会翻译成false
7. 使用return(9)返回结果
8. 使用$rc获取上个函数的返回值

虽然opensips脚本中无法自定义函数，但是可以把route关键字作为函数来使用。

可以给

```bash
# 定义enter_log函数

route[enter_log]{
	xlog("$ci $fu $tu $param(1)") # $param(1) 是指调用enter_log函数的第一个参数，即wangdd
  return(1)
}

route{
	# 调用enter_log函数
	route(enter_log, "wangdd")
  # 获取enter_log的返回值 $rc
  xlog("$rc")
}
```



# 如何传参
某个函数可以支持6个参数，全部都是的可选的，但是我只想传第一个和第6个，应该怎么传？

不想传参的话，需要使用逗号隔开

```bash
siprec_start_recording(srs,,,,,media_ip)
```


