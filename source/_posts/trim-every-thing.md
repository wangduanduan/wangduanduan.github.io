---
title: trim-everything trim所有数据类型
date: 2018-02-11 14:28:22
tags:
---

![](http://p3alsaatj.bkt.clouddn.com/20180211142905_ruma02_Screenshot.jpeg)

# trim-everything
trim所有字段，因为底层使用的JSON.stringify作为遍历器，所以如果字段的值是function，那么会被trim掉。

项目地址：[trim-everything](https://github.com/wangduanduan/trim-everything)

# 安装
```
npm i -S trim-everything

yarn add trim-everything
```

# 特点
- trim undefined
- trim null
- trim number
- trim string
- trim object
- trim array
- 零依赖

# 开始

下面使用jest做的测试用例，可以从中看出trim的用法。

```
/* global test, expect */
const trim = require('trim-everything')

test('trim undefined', () => {
  expect(trim()).toBeUndefined()
})

test('trim null', () => {
  expect(trim(null)).toBeNull()
})

test('trim number', () => {
  expect(trim(12.12)).toBe(12.12)
})

test('trim string', () => {
  expect(trim(' 12abcd ')).toBe('12abcd')
})

test('trim object', () => {
  expect(trim({
    userName: ' wangdd ',
    age: 12,
    some: false,
    address: ' shanghai'
  }))
  .toEqual({
    userName: 'wangdd',
    age: 12,
    some: false,
    address: 'shanghai'
  })
})

test('trim array', () => {
  expect(trim([
    {
      userName: ' wangdd ',
      age: 12,
      some: false,
      address: ' shanghai'
    },
    ' abcd ',
    false,
    12.12,
    {
      userName: ' wangdd ',
      age: 12,
      some: false,
      address: ' shanghai',
      child: {
        userName: ' wangdd ',
        age: 12,
        some: false,
        address: ' shanghai'
      }
    }
  ]))
  .toEqual(
    [
      {
        userName: 'wangdd',
        age: 12,
        some: false,
        address: 'shanghai'
      },
      'abcd',
      false,
      12.12,
      {
        userName: 'wangdd',
        age: 12,
        some: false,
        address: 'shanghai',
        child: {
          userName: 'wangdd',
          age: 12,
          some: false,
          address: 'shanghai'
        }
      }
    ]
  )
})

```


  [1]: /img/bV2aMf