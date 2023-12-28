---
title: "使用bun加速开发环境的ts编写"
date: "2023-12-23 15:04:44"
draft: false
type: posts
tags:
- typescript
categories:
- all
---

# 前言

最近我在开发一个demo程序，为了加速开发，我觉得直接用js要比用typescript更快，而且这只是一个demo程序，杀鸡焉用牛刀。

而且一旦我要用typescript开发，避免不了要各种配置，例如typescript, ts-node, nodemon之类的，很是繁琐。而且ts也必须要经过编译后才能运行。

然而，直到遇到一个bug,  我排查了半天，才发现是一个对象的属性写错了。本身这个对象是没有这个属性的，js没有任何错误提示。我只能一步一步缩小代码的范围，最终才定位到是属性拼写的错误。

这个拼写的错误，应该是vscode的智能补全，给出的提示词，我直接回车确认了。

这件事给我一个教训：**以后所有代码都要用ts去编写。**

直接用js去编写虽然看起来写的快，但是代码调试太痛苦了。 这种拼写错误，ts的智能提示会直接告诉你错误的地方，但是如果去排查js文件，花费的时间是无法估量的。

但是我又不太想去配置各种ts的执行环境，就想起来之前曾经用的[bun](https://bun.sh/)这个ts执行工具。

虽然bun这个工具才刚刚发布1.0版本，但是在开发环境使用也是足够了。

我的设想是在开发环境用bun, 在生产环境用nodejs执行bun编译后的js代码。

这个demo程序用bun去运行的时候，没发现任何兼容问题。 这也让我有了继续研究下去的信心。


# bun的开发环境

我之前看过deno, 但是看多deno的官方文档后，发现并不符合我的胃口。 但是bun的文档写的很好。

任何工具的第一步都是安装，但是bun似乎在windows上执行并不太好，所以我是用windows的linux子系统，或者在mac上安装的bun。

具体的安装步骤可以参考，https://bun.sh/docs/installation

# 项目初始化

```
bun init

bun init helps you get started with a minimal project and tries to
guess sensible defaults. Press ^C anytime to quit.

package name (quickstart):
entry point (index.ts):

Done! A package.json file was saved in the current directory.
 + index.ts
 + .gitignore
 + tsconfig.json (for editor auto-complete)
 + README.md

To get started, run:
  bun run index.ts
```

使用bun运行index.ts

```
bun run index.ts 
Hello via Bun!
```

安装npm包

```
bun add figlet
bun add -d @types/figlet
```

修改index.ts

```ts
import figlet from "figlet";
const body = figlet.textSync("Bun!");
console.log(body);
```

执行index.ts, 输出

```
  ____              _ 
 | __ ) _   _ _ __ | |
 |  _ \| | | | '_ \| |
 | |_) | |_| | | | |_|
 |____/ \__,_|_| |_(_)
```

然后我们尝试把index.ts编译js文件。

编写一个build.ts编译文件

```ts
```



# 参考资料

- https://bun.sh/docs/bundler
