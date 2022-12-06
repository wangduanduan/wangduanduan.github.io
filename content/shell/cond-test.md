---
title: '比较与测试'
date: '2020-05-11 13:01:07'
draft: false
---

# if

```bash
# if
if condition; then
	commands;
fi

# if else if
if condition; then
	commands;
elif condition; then
	commands;
else
	commands;
fi
```

简单版本的 if 测试

```bash
[ condtion ] && action;
[ conditio ] || action;
```

# 算数比较

```bash
[ $var -eq 0 ] #当var等于0
[ $var -ne 0 ] #当var不等于0
```

-   -gt 大于
-   -lt 小于
-   -ge 大于或等于
-   -le 小于或等于

使用-a, -o 可以组合复杂的测试。

```bash
[ $var -ne 0 -a $var -gt 2 ] # -a相当于并且
[ $var -ne 0 -o $var -gt 2 ] # -o相当于或
```

# 文件比较

```bash
[ -f $file ] # 如果file是存在的文件路径或者文件名，则返回真
```

-   -f 测试文件路径或者文件是否存在
-   -x 测试文件是否可执行
-   -e 测试文件是否存在
-   -c 测试文件是否是字符设备
-   -b 测试文件是否是块设备
-   -w 测试文件是否可写
-   -r 测试文件是否可读
-   -L 测试文件是否是一个符号链接

# 字符串比较

**字符串比较一定要用双中括号。**

```bash
[[ $str1 == $str2 ]] # 测试字符串是否相等
[[ $str1 != $str2 ]] # 测试字符串是否不相等
[[ $str1 > $str2 ]] # 测试str1字符序号比str2大
[[ $str1 < $str2 ]] # 测试str1字符序号比str2小
[[ -z $str ]] # 测试str是否是空字符串
[[ -n $str ]] # 测试str是否是非空字符串
```

# if 和[之间必须包含有一个空格

```bash
# ok
if [[ $1 == $2 ]]; then
	echo hello
fi

# error
if[[ $1 == $2 ]]; then
	echo hello
fi
```
