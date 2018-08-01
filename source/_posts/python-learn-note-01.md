---
title: python学习笔记 星号的作用
date: 2018-07-31 22:35:51
tags:
- python
---

# 一个*的作用：打散或者聚合可迭代序列

代码如下：

```
def showArgs(*args):
  print(args)

showArgs()
showArgs('A')
showArgs('A', 'B', 'C')

mylist = ['D','E','F']
mytuple = ('H', 'G')
myset = {'X', 'Y', 'Z'}

showArgs(*mylist)
showArgs(*mytuple)
showArgs(*myset)

showArgs(mylist)
showArgs(mytuple)
showArgs(myset)

```

代码输出

```
()
('A',)
('A', 'B', 'C')
('D', 'E', 'F')
('H', 'G')
('Y', 'X', 'Z')
(['D', 'E', 'F'],)
(('H', 'G'),)
({'Y', 'X', 'Z'},)
```

`结论`

- `*作为函数形参时，可以将传入的实参收集到一个元组中`
- `*作为函数实参时，可以将单个的列表，元组，集合打散成多个参数传入函数`

效用：如果某个函数需要的参数是不定数量的参数，那么可以使用一个*号，将可迭代对象打散后传入，这样就可以避免循环了。

# 两个*的作用：打散或者聚合字典

代码如下：

```
def showArgs(**args):
  print(args)

showArgs(name='wdd')

myDict = {'name':'wdd'}

showArgs(**myDict)
showArgs(myDict='1')
showArgs(myDict)
```

代码输出：

```
{'name': 'wdd'}
{'name': 'wdd'}
{'myDict': '1'}
Traceback (most recent call last):
  File "test3.py", line 10, in <module>
    showArgs(myDict)
TypeError: showArgs() takes 0 positional arguments but 1 was given
```

`结论：`

- 传入关键字参数`k1=v1,k2=v2`和传入`**{'k1':'v1','k2':'v2'}`的效果是相同的
- 函数签名如果是位置参数，则必须按照`key=value`的形式传参，只穿一个`key`会报错

# 总结 * 和 ** 都是一种很简介的写法

这个函数需要传不定数量的参数，如果你本身就是有一个数组的情况下，可以不使用循环。直接打散。

```
myArr = [1,2,3]
myDict = {'name':'wdd', 'age': 11}

# 方法1
for i in myArr:
  someFunc1(i)

someFunc2(name=myDict['name'], age=myDict['age'])

# 方法2
someFunc1(*myArr) 
someFunc2(**myDict)
```

