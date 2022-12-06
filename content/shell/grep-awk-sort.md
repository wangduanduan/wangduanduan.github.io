---
title: 'awk、grep、cut、sort、uniq简单命令玩转日志分析与统计'
date: '2019-10-15 21:35:15'
draft: false
---

test.log

```
2019-1010-1920 192.345.23.3 cause:"AAA" type:"A" loginIn
2019-1010-1920 192.345.23.1 cause:"BBB" type:"A" loginIn
2019-1010-1920 192.345.23.3 cause:"AAA" type:"S" loginIn
2019-1010-1920 192.345.23.1 cause:"BBJ" type:"A" loginIn
```

# 按列分割

**提取第三列**

日志列数比较少或则要提取的字段比较靠前时，优先使用 awk。当然 cut 也可以做到。

比如输出日志的第三列

```
awk '{print $3}' test.log // $3表示第三列
cut -d " " -f3 test.log // -f3指定第三列, -d用来指定分割符
```

# 正则提取

**提取 cause 字段的原因值？**

```
2019-1010-1920 192.345.23.3 cause:"AAA" type:"A" loginIn
2019-1010-1920 192.345.23.1 type:"A" loginIn cause:"BBB"
2019-1010-1920 192.345.23.3 cause:"AAA" type:"S" loginIn
2019-1010-1920 192.345.23.1 type:"A" cause:"BBJ" loginIn
```

`当要提取的内容不在同一列时，往往就无法用cut或者awk就按列提取`。最好用的方式是用 grep 的正则提取。

好像 grep 不支持捕获分组，所以只能提取出出 cause:"AAA"，而无法直接提取出 AAA

-   E 表示使用正则
-   o 表示只显示匹配到的内容

```
> grep -Eo 'cause:".*?"' test.log
cause:"AAA"
cause:"BBB"
cause:"AAA"
cause:"BBJ"
```

# 统计

对输出的关键词进行统计，并按照升序或者降序排列。

将关键词按照列或者按照正则提取出来之后，首先要进行`sort`排序, 然后再进行`uniq`去重。

不进行排序就直接去重，统计的值就不准确。因为 uniq 去重只能去除连续的相同字符串。不是连续的字符串，则会统计多次。

下面例子：非连续的 cause:"AAA"，没有被合并在一起计数

```
// bad
grep -Eo 'cause:".*?"' test.log | uniq -c
   1 cause:"AAA"
   1 cause:"BBB"
   1 cause:"AAA"
   1 cause:"BBJ"

// good AAA 被正确统计了
grep -Eo 'cause:".*?"' test.log | sort | uniq -c
   2 cause:"AAA"
   1 cause:"BBB"
   1 cause:"BBJ"
```

# 对统计值排序

sort 默认的排序是按照字典排序, 可以使用-n 参数让其按照数值大小排序。

-   n 按照数值排序
-   r 取反。sort 按照数值排序是，默认是升序，如果想要结果降序，那么需要`-r`
-   -k -k 可以指定按照某列的数值顺序排序，如-k1,1(指定第一列)， -k2,2(指定第二列)。如果不指定-k 参数，那么一般默认第一列。

```
// 升序排序
grep -Eo 'cause:".*?"' test.log | sort |uniq -c | sort -n
   1 cause:"BBB"
   1 cause:"BBJ"
   2 cause:"AAA"

// 降序排序
grep -Eo 'cause:".*?"' test.log | sort |uniq -c | sort -nr
   2 cause:"AAA"
   1 cause:"BBJ"
   1 cause:"BBB"
```
