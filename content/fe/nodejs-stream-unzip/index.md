---
title: "NodeJS边下载边解压gz文件"
date: "2022-10-29 11:39:37"
draft: false
---

```js
const fs = require('fs')
var request = require('request')
const zlib = require('zlib')
const log = require('./log.js')
const fileType = ''

let endCount = 0

module.exports = (item) => {
  return new Promise((resolve, reject) => {
    request.get(item.url)
    .on('error', (error) => {
      log.error(`下载失败${item.name}`)
      reject(error)
    })
    .pipe(zlib.createGunzip())
    .pipe(fs.createWriteStream(item.name + fileType))
    .on('finish', (res) => {
      log.info(`${++endCount} 完成下载 ${item.name + fileType}`)
      resolve(res)
    })
  })
}
```