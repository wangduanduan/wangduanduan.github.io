---
title: grep awk 搜索日志常用命令
date: 2018-02-09 10:45:31
tags:
- grep
- awk
---

# 1. grep 常用参数
参考： [GNU Grep 3.0](https://www.gnu.org/software/grep/manual/grep.html)
```
--color:高亮显示匹配到的字符串
-v：显示不能被pattern匹配到的
-i：忽略字符大小写
-o：仅显示匹配到的字符串
-q：静默模式，不输出任何信息
-A#：after，匹配到的后#行
-B#：before，匹配到的前#行
-C#：context，匹配到的前后各#行
-E：使用ERE，支持使用扩展的正则表达式

－c：只输出匹配行的计数。
－I：不区分大 小写(只适用于单字符)。
－h：查询多文件时不显示文件名。
－l：查询多文件时只输出包含匹配字符的文件名。
－n：显示匹配行及 行号。
- m: 匹配多少个关键词之后就停止搜索
－s：不显示不存在或无匹配文本的错误信息。
－v：显示不包含匹配文本的所有行。
```

# 2. 普通：搜索trace.log 中含有ERROR字段的日志
`grep ERROR trace.log `

# 3. 输出文件：可以将日志输出文件中
`grep ERROR trace.log > error.log`

# 4. 反向：搜索不包含ERROR字段的日志
`grep -v ERROR trace.log`

# 5. 向前：搜索包含ERROR,并且显示ERROR前10行的日志
`grep -B 10 ERROR trace.log`

# 6. 向后：搜索包含ERROR字段，并且显示ERROR后10行的日志
`grep -A 10 ERROR trace.log`

# 7. 上下文：搜索包含ERROR字段，并且显示ERROR字段前后10行的日志
`grep -C 10 ERROR trace.log`

# 8. 多字段：搜索包含ERROR和DEBUG字段的日志
`gerp -E 'ERROR|DEBUG' trace.log`

# 9. 多文件：从多个.log文件中搜索含有ERROR的日志
`grep ERROR *.log`

# 10. 省略文件名：从多个.log文件中搜索ERROR字段日志，并不显示日志文件名
从多个文件中搜索的日志默认每行会带有日志文件名

`grep -h ERROR *.log`

# 11. 时间范围： 按照时间范围搜索日志
`awk '$2>"17:30:00" && $2<"18:00:00"' trace.log`
日志形式如下, $2代表第二列即11:44:58, awk需要指定列
```
11-21 16:44:58 /user/info/
```

# 12. 有没有：搜索到第一个匹配行后就停止搜索
`grep -m 1 ERROR trace.log`

# 13. 使用正则提取字符串

`grep -Eo 'cause":"(.*?)"' test.log`

```
cause":"A"
cause":"B"
cause":"A"
cause":"A"
cause":"A"
```

如果相对提取字符串的结果进行按照出现的次数进行排序，可以使用sort, uniq命令

```
grep -Eo 'cause":"(.*?)"' test.log | sort | uniq -c | sort -k1,1 -n
```

步骤分解

- sort 对结果进行排序
- uniq -c 对结果进行去重并统计出现次数
- sort -k1,1 -n 按照第一列的结果，进行数值大小排序
