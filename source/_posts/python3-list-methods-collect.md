---
title: Python3笔记 列表方法详解
date: 2018-02-09 13:15:13
tags:
- python3
---

# 1. 使用`[]`或者`list()`创建列表
```
user = []
user = list()
```
# 2. 使用`list() `可以将其他类型转换成列表
```
# 将字符串转成列表
>>> list('abcde')
['a', 'b', 'c', 'd', 'e']

# 将元祖转成列表
>>> list(('a','b','c'))
['a', 'b', 'c']
```
# 3. 使用`[offset]`获取元素 或 修改元素
```
>>> users = ['a','b','c','d','e']
# 可以使用整数来获取某个元素
>>> users[0]
'a'
# 可以使用负整数来表示从尾部获取某个元素
>>> users[-1]
'e'

# 数组越界会报错
>>> users[100]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: list index out of range
>>> users[-100]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: list index out of range

# 修改某个元素
>>> users[0] = 'wdd'
>>> users
['wdd', 'b', 'c', 'd', 'e']
>>> 
```
# 4. 列表切片与提取元素
列表的切片或者提取之后仍然是一个列表
形式如：`list[start:end:step]`
```
>>> users
['wdd', 'b', 'c', 'd', 'e']
# 正常截取 注意这里并不会截取到users[2]
>>> users[0:2]
['wdd', 'b']
# 也可从尾部截取
>>> users[0:-2]
['wdd', 'b', 'c']
# 这样可以获取所有的元素
>>> users[:]
['wdd', 'b', 'c', 'd', 'e']
# 也可以加上步长参数
>>> users[0:4:2]
['wdd', 'c']
# 也可以通过这种方式去将列表取反
>>> users[::-1]
['e', 'd', 'c', 'b', 'wdd']

# 注意切片时，偏移量可以越界，越界之后不会报错，仍然按照界限来处理 例如开始偏移量如果小于0，那么仍然会按照0去计算。
>>> users
['wdd', 'b', 'c', 'd', 'e']
>>> users[-100:3]
['wdd', 'b', 'c']
>>> users[-100:100]
['wdd', 'b', 'c', 'd', 'e']
>>> 

```

# 5. 使用`append()`添加元素至尾部
形式如：`list.append(item)`
```
>>> users
['wdd', 'b', 'c', 'd', 'e']
>>> users.append('ddw')
>>> users
['wdd', 'b', 'c', 'd', 'e', 'ddw']
```

# 6. 使用`extend()`或`+=`合并列表
形式如：`list1.extend(list2)`
这两个方法都会直接修改原列表
```
>>> users
['wdd', 'b', 'c', 'd', 'e', 'ddw']
>>> names
['heihei', 'haha']
>>> users.extend(names)
>>> users
['wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha']
>>> users += names
>>> users
['wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', 'haha']
```

# 7. 使用`insert()`在指定位置插入元素
形式如：`list.insert(offset, item)`
insert也不存在越界的问题，偏移量正负都行，越界之后会自动伸缩到界限之内，并不会报错
```
>>> users
['wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', 'haha']
>>> users.insert(0,'xiaoxiao')
>>> users
['xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', 'haha']
>>> users.insert(-1,'-xiaoxiao')
>>> users
['xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha']
# 下面-100肯定越界了
>>> users.insert(-100,'-xiaoxiao')
>>> users
['-xiaoxiao', 'xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha']
# 下面100也是越界了
>>> users.insert(100,'-xiaoxiao')
>>> users
['-xiaoxiao', 'xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
```

# 8. 使用`del`删除某个元素
形式如：`del list[offset]`
del是python的语句，而不是列表的方法，del删除不存在的元素时，也会提示越界
```
>>> users
['-xiaoxiao', 'xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
>>> del users[0]
>>> users
['xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
>>> del users[100]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: list assignment index out of range
>>> del users[-100]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: list assignment index out of range
```

# 9. 使用`remove`删除具有指定值的元素
形式如：`list.remove(value)`
```
>>> users
['xiaoxiao', 'wdd', 'b', 'c', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
# 删除指定值'c'
>>> users.remove('c')
>>> users
['xiaoxiao', 'wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'haha', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
# 删除不存在的值会报错
>>> users.remove('alsdkfjalsdf')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: list.remove(x): x not in list
# 如果该值存在多个，那么只能删除到第一个
>>> users.remove('haha')
>>> users
['xiaoxiao', 'wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
```

# 10. 使用`pop()`方式返回某个元素后，并在数组里删除它
形式如：`list.pop(offset=-1)` 偏移量默认等于-1，也就是删除最后的元素
```
>>> users
['xiaoxiao', 'wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha', '-xiaoxiao']
# 删除最后的元素
>>> users.pop()
'-xiaoxiao'
>>> users
['xiaoxiao', 'wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
# 如果列表本身就是空的，那么pop时会报错
>>> user.pop(0)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: pop from empty list
>>> users.pop(0)
'xiaoxiao'
>>> users
['wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
# 越界时也会报错
>>> users.pop(100)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: pop index out of range
```

# 11. 使用`index()`查询具有特定值的元素位置
形式如：`list.index(value)`
```
# index只会返回第一遇到该值得位置
>>> users
['wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
>>> users.index('heihei')
5

# 如果该值不存在，也会报错
>>> users.index('laksdf')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: 'laksdf' is not in list
```

# 12. 使用`in`判断值是否存在列表
形式如：`value in list`
```
>>> users
['wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
>>> 'wdd' in users
True
```

# 13. 使用`count()`记录特定值出现的次数
形式如：`list.count(value)`
```
>>> users
['wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
>>> users.count('heihei')
2
>>> users.count('h')
0
```

# 14. 使用`join()`将列表转为字符串
形式如：`string.join(list)`
```
>>> users
['wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
>>> ','.join(users)
'wdd,b,d,e,ddw,heihei,heihei,-xiaoxiao,haha'
>>> user
[]
>>> ','.join(user)
''
```

# 15. 使用`sort()`重新排列列表元素
形式如：list.sort()
```
>>> users
['wdd', 'b', 'd', 'e', 'ddw', 'heihei', 'heihei', '-xiaoxiao', 'haha']
# 默认是升序排序
>>> users.sort()
>>> users
['-xiaoxiao', 'b', 'd', 'ddw', 'e', 'haha', 'heihei', 'heihei', 'wdd']
# 加入reverse=True, 可以降序排序
>>> users.sort(reverse=True)
>>> users
['wdd', 'heihei', 'heihei', 'haha', 'e', 'ddw', 'd', 'b', '-xiaoxiao']

# 通过匿名函数，传入函数进行自定义排序
>>> students
[{'name': 'wdd', 'age': 343}, {'name': 'ddw', 'age': 43}, {'name': 'jik', 'age': 90}]
>>> students.sort(key=lambda item: item['age'])
>>> students
[{'name': 'ddw', 'age': 43}, {'name': 'jik', 'age': 90}, {'name': 'wdd', 'age': 343}]
>>> students.sort(key=lambda item: item['age'], reverse=True)
>>> students
[{'name': 'wdd', 'age': 343}, {'name': 'jik', 'age': 90}, {'name': 'ddw', 'age': 43}]
>>> 

```

# 16. 使用`reverse()`将列表翻转
形式如：list.reverse()
```
>>> users
['wdd', 'heihei', 'heihei', 'haha', 'e', 'ddw', 'd', 'b', '-xiaoxiao']
>>> users.reverse()
>>> users
['-xiaoxiao', 'b', 'd', 'ddw', 'e', 'haha', 'heihei', 'heihei', 'wdd']
```

# 17. 使用`copy()`复制列表
形式如：`list2 = list1.copy()`
list2 = list1 这种并不是列表的复制，只是给列表起了别名。实际上还是指向同一个值。
```
>>> users
['-xiaoxiao', 'b', 'd', 'ddw', 'e', 'haha', 'heihei', 'heihei', 'wdd']
>>> users2 = users.copy()
>>> users2
['-xiaoxiao', 'b', 'd', 'ddw', 'e', 'haha', 'heihei', 'heihei', 'wdd']
>>> 

```
# 18. 使用`clear()`清空列表
形式如： `list.clear()`
```
>>> users2
['-xiaoxiao', 'b', 'd', 'ddw', 'e', 'haha', 'heihei', 'heihei', 'wdd']
>>> users2.clear()
>>> users2
[]
```
# 19. 使用`len()`获取列表长度
形式如：`len(list)`
```
>>> users
['-xiaoxiao', 'b', 'd', 'ddw', 'e', 'haha', 'heihei', 'heihei', 'wdd']
>>> len(users)
9
```


# 20. 关于列表越界的深入思考
写了这些方法后，我有一些疑问，为什么有些操作会提示越界，有些则不会呢？

会提示偏移量越界的操作有
- list[offset] 读取或者修改某个元素
- del list[offset] 删除指定位置的元素
- list.remove(value) 删除指定值的元素
- list.pop(offset) 删除指定位置的元素

如果偏移量越界，这些方法会报错的。我的个人理解是:
`假如我想读取偏移量为10的元素，但是该元素并不存在，如果系统自动给你读取了列表的最后一个元素，而且不报错，这是无法容忍的bug。 如果我想删除第10个元素，但是第10个元素并不存在，而系统帮你删除了列表的最后一个元素，我觉得这也是无法容忍的。`

所以在使用这些方法时，务必确认该偏移量的元素是否存，否则可能会报错。















