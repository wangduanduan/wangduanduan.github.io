---
title: "简单实用的M4教程"
date: "2021-09-25 12:22:19"
draft: false
---

# 文本处理的难点
有一个文本文件，内容如下，摘抄其中两行内容如下，里面有两个配置db_addr, local_ip这两个配置，需要在不同环境要修改的。

```
db_addr=1.2.3.4:3306
local_ip=192.168.2.4
```
但是哪些地方要修改呢？为了提醒后续的维护者，我们给要修改的地方加个备注吧。

```
db_addr=1.2.3.4:3306 # 这里要修改
local_ip=192.168.2.4 # 这里要修改
....
...
if len(a) = 1024 {  # 这里要修改1024
   ...
}
...
```


# 用sed替换？
让别人一个一个地方去修改，也太麻烦了，有没有可能用脚本去处理呢？例如我们用DB_ADDR和LOCAL_IP这种字符串作为占位符，然后我们就可以用sed之类的命令去做替换了。

```
db_addr=DB_ADDR
local_ip=LOCAL_IP
```
```
sed -i 's/DB_ADDR/1.2.3.4:3306/g;s/LOCAL_IP/192.168.0.1/g' 1.cfg
```

这样做是有点方便了，但是也有以下几个问题

1. 如果定义的占位符太多，sed会变得越来越长
2. 如果某些占位符里本身就含有/或者一些特殊含义的字符，就需要做特殊处理了


# 用M4吧，专业的人做专业的事情

```
apt-get install m4
```


## 通过命令行定义宏

1.m4
```
db_addr=DB_ADDR
local_ip=LOCAL_IP
....
...
if len(a) = MAX_LEN {
   ...
}
...
```

M4可以使用-D来定义宏和宏对应的值，默认输出到标准输出，我们可以用>将输出写到文件中

```
m4 -D DB_ADDR=1.2.3.4:3306 -D LOCAL_IP=192.168.2.2 -D MAX_LEN=2048 1.m4

db_addr=1.2.3.4:3306
local_ip=192.168.2.2
....
...
if 1 = 2048 {
   ...
}
...
```


## 用define语句定义宏

- 用define()语句来定义宏
- 用`'来作为字符串引用，避免被展开
```
define(`DB_ADDR', `1.2.3.4:3306')
define(`LOCAL_IP', `192.168.2.2')
define(`MAX_LEN', `2048')

db_addr=DB_ADDR
local_ip=LOCAL_IP
....
...
if len(a) = MAX_LEN {
   ...
}
...
```


执行命令`m4 1.m4`, 可以看到宏展开，但是有很多空行。

```




db_addr=1.2.3.4:3306
local_ip=192.168.2.2
....
...
if 1 = 2048 {
   ...
}
...%   
```


## 用dnl避免产生空行

在define语句的末尾，加上dnl

```
define(`DB_ADDR', `1.2.3.4:3306')dnl
define(`LOCAL_IP', `192.168.2.2')dnl
define(`MAX_LEN', `2048')dnl

db_addr=DB_ADDR
local_ip=LOCAL_IP
....
...
if len(a) = MAX_LEN {
   ...
}
...
```

执行`m4 1.m4` 可以看到，空行没了

```

db_addr=1.2.3.4:3306
local_ip=192.168.2.2
....
...
if 1 = 2048 {
   ...
}
...
```


## 抽离出宏配置文件
将1.m4分成两个文件1.m4, 1.conf

1.conf
```
divert(-1)
define(`DB_ADDR', `1.2.3.4:3306')
define(`LOCAL_IP', `192.168.2.2')
define(`MAX_LEN', `2048')
divert(0)
```
1.m4
```
db_addr=DB_ADDR
local_ip=LOCAL_IP
....
...
if len(a) = MAX_LEN {
   ...
}
...
```

执行：m4 1.conf 1.m4

```

db_addr=1.2.3.4:3306
local_ip=192.168.2.2
....
...
if 1 = 2048 {
   ...
}
...
```


## 读取环境变量

```
define(`MY_NAME', `esyscmd(`printf "${MY_NAME:-wdd}"')')dnl


```

