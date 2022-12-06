---
title: JavaScript动态下载文件
date: 2018-06-27 09:09:01
tags:
---

# 需求描述

- 可以把字符串下载成txt文件
- 可以把对象序列化后下载json文件
- 下载由ajax请求返回的Excel, Word, pdf 等等其他文件

# 基本思想

```
downloadJsonIVR () {
  var data = {name: 'age'}
  data = JSON.stringify(data)
  data = new Blob([data])
  var a = document.createElement('a')
  var url = window.URL.createObjectURL(data)
  a.href = url
  a.download = 'what-you-want.json'
  a.click()
},
```

# 从字符串下载文件

# 从ajax请求中下载文件