---
title: "[todo]锋利的linux日志分析命令"
date: "2020-10-04 10:13:10"
draft: false
---

# 预处理

## 从一个文件中过滤

- `grep key file` 
```bash
➜ grep ERROR a.log 
12:12 ERROR:core bad message
```

## 从多个文件中过滤

- `grep key file1 fil2` 多文件搜索，指定多个文件
- `grep key *.log`  使用正则的方式，匹配多个文件
- `grep -h key *.log` 可以使用-h, 让结果中不出现文件名。默认文件名会出现在匹配行的前面。
```bash
➜ grep ERROR a.log b.log 
a.log:12:12 ERROR:core bad message
b.log:13:12 ERROR:core bad message

➜ grep ERROR *.log
a.log:12:12 ERROR:core bad message
b.log:13:12 ERROR:core bad message
```


## 多个关键词过滤

- `grep -e key1 -e key2 file` 使用-e参数，可以制定多个关键词
```bash
➜ grep -e ERROR -e INFO a.log 
12:12 ERROR:core bad message
12:12 INFO:parse bad message1
```

## 正则过滤

- `grep -E REG file`  下面例子是匹配db:后跟数字部分
```bash
➜ grep -E "db:\d+ " a.log
12:14 WARNING:db:1 bad message
12:14 WARNING:db:21 bad message
12:14 WARNING:db:2 bad message1
12:14 WARNING:db:4 bad message
```

## 仅输出匹配字段

- `grep -o args` 使用-o参数，可以仅仅输出匹配项，而不是整个匹配的行
```bash
➜  go-tour grep -o -E "db:\d+ " a.log
db:1 
db:21 
db:2 
db:4 
```


## 统计关键词出现的行数
例如一个nginx的access.log, 我们想统计其中的POST的个数，和OPTIONS的个数。

先写一个脚本，名为method.ack
```bash
BEGIN{
  post_lines = 0
  options_lines = 0
  printf "start\n"
}

/POST/ {
  post_lines++
}
/OPTIONS/ {
  options_lines++
}

END {
  printf "post_lines: %s, \noptions_lines: %s \n",post_lines,options_lines
}
```
然后执行
```bash
ack -f method.ack access.log
```


# 时间处理
比如给你一个nginx的access.log, 让你按照每秒，每分钟统计下请求量的大小，如何做呢？

1. 首先取出日志行中的时间，然后从事件中取出秒 `awk '{print $4}'` 
```bash
10.32.104.47 - - [29/Sep/2020:06:43:53 +0800] "OPTIONS url HTTP/1.1" 200 0 "" "Mozi Safari/537.36" "-"
```

```bash
awk '{print $4}' access.log
[29/Sep/2020:05:15:27
[29/Sep/2020:05:15:27
[29/Sep/2020:05:15:27
[29/Sep/2020:05:15:27
[29/Sep/2020:05:15:27
[29/Sep/2020:05:15:27
```
那如何取出分钟呢？使用ack的字符串函数， `substr(str, startIndex, len)` 

```bash
awk '{print substr($4,0,18)}' access.log
[29/Sep/2020:05:23
[29/Sep/2020:05:23
```

对输出结果进行 `uniq -c` 统计出现重复行的次数。即单位事件内时间重复的次数，也就是单位事件内的请求数。
```bash
 625 [29/Sep/2020:06:36
 625 [29/Sep/2020:06:37
 624 [29/Sep/2020:06:38
 624 [29/Sep/2020:06:39
 651 [29/Sep/2020:06:40
 626 [29/Sep/2020:06:41
 624 [29/Sep/2020:06:42
 560 [29/Sep/2020:06:43
```



# 排序与去重 sort

- 按照某一列去重
- 按照多列去重


# vim专项练习

- `:set nowrap`  取消自动换行
- `:set nu` 显示行号
- `:%!awk '{$2="";print $0}'` 删除指定的列
- `:%!awk '{print $3,$4}'`  挑选指定的列
- `:g/key/d`  删除匹配的行
- `:v/key/d` 删除不匹配的行
- `:g/key/p`  仅仅显示匹配的行
- `:v/key/p` 仅仅显示不匹配的行
- `/key1\|key2` 查找多个关键词
- `:nohl` 移除高亮



# 核武器 lnav

- 过滤
- 统计图

```bash
select cs_method , count( cs_method ) FROM access_log group by cs_method
```


# 

