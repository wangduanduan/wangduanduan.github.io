---
title: "在不打开文件，将全文复制到剪贴板"
date: "2019-08-16 09:25:37"
draft: false
---
一般拷贝全文分为以下几步

1. 使用编辑器打开文件
2. 全文选择文件
3. 执行拷贝命令

实际上操作系统提供了一些命令，可以在不打开文件的情况下，将文件内容复制到剪贴板。


# mac pbcopy
```javascript
cat aaa.txt | pbcopy
```


# linux xsel

```javascript
cat aaa.txt | xsel
```


# windows clip

```javascript
cat aaa.txt | clip
```


