---
title: "JS运行时构建独立二进制程序比较"
date: "2023-06-01 13:48:00"
draft: false
type: posts
tags:
- all
categories:
- all
---

很早以前，要运行js，则必须安装nodejs，且没什么办法可以把js直接构建成一个可执行的文件。

后来出现一个[pkg](https://www.npmjs.com/package/pkg)的npm包，可以用来将js打包成可执行的文件。

我好像用过这个包，但是似乎中间出过一些问题。

现在是2023年，前端有了新的气象。

除了nodejs外，还有其他的后来新秀，如[deno](https://deno.com/)， 还有最近表火的[bun](https://bun.sh/)

另外nodejs本身也开始支持打包独立二进制文件了，但是需要最新的20.x版本，而且我看了它的使用介绍文档，[single-executable-applications](https://nodejs.org/api/single-executable-applications.html), 看起来是有有点复杂，光一个构建就写了七八步。


所以今天只比较一些deno和bun的构建出的文件大小。

准备的js文件内容

```js
// app.js
console.log("hello world")
```

deno构建指令: `deno compile --output h1 app.js`,  构建产物为h1
bun构建指令: `bun build ./app.js --compile --outfile h2`, 构建产物为h2

```
-rw-r--r--@ 1 wangduanduan  staff    26B Jun  1 13:34 app.js
-rwxrwxrwx@ 1 wangduanduan  staff    78M Jun  1 13:59 h1
-rwxrwxrwx@ 1 wangduanduan  staff    45M Jun  1 14:01 h2
```

源代码为26b字节

- deno构建相比于源码的倍数: 3152838
- bun构建相比于源码的翻倍: 1804415
- deno构建的可执行文件相比bun翻倍：1.7


# 参考
- https://bun.sh/docs/bundler/executables
- https://deno.com/manual@v1.34.1/tools/compiler
- https://nodejs.org/api/single-executable-applications.html