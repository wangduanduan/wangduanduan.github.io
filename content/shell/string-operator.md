---
title: '字符串操作'
date: '2019-10-26 14:16:28'
draft: false
---

# 获取字符串长度

需要在变量前加个**#**

```
name=wdd
echo ${#name}
```

# 首尾去空格

```bash
echo " abcd " | xargs
```

# 字符串包含

```bash
# $var是否包含字符串A
if [[ $var =~ "A" ]]; then
    echo
fi

# $var是否以字符串A开头
if [[ $var =~ "^A" ]]; then
    echo
fi

# $var是否以字符串A结尾
if [[ $var =~ "A$" ]]; then
    echo
fi
```

# 字符串提取

```bash
#!/bin/bash
num1=${test#*_}
num2=${num1#*_}
surname=${num2%_*}
num4=${test##*_}
profession=${num4%.*}

#*_ 从左边开始，去第一个符号“_”左边的所有字符
% _* 从右边开始，去掉第一个符号“_”右边的所有字符
##*_ 从右边开始，去掉第一个符号“_”左边的所有字符
%%_* 从左边开始，去掉第一个符号“_”右边的所有字符
```

# 判断某个字符串是否以特定字符开头

```shell
if [[ $TAG =~ ABC* ]]; then
	echo $TAG is begin with ABC
fi
```
