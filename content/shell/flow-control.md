---
title: '流程控制'
date: '2019-10-18 13:06:58'
draft: false
---

# if then

```bash
// good
if [ -d public ]
then
	echo "public exist"
if

// good
if [ -d public ]; then
	echo "public exist"
if

// error: if和then写成一行时，条件后必须加上分号
if [ -d public ] then
	echo "public exist"
if

// error: shell对空格比较敏感，多个空格和少个空格，执行的含义完全不同
// 在[]中，内侧前后都需要加上空格
if [-d public] then
	echo "public exist"
if
```

# if elif then

```bash
if [ -d public ]
then
	echo "public exist"
elif
then
```

# 循环

# switch

# 常用例子

## 判断目录是否存在

```bash
if [ -d public ]
then
	echo "public exist"
if
```

## 判断文件是否存在
