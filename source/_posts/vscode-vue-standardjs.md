---
title: 如何在vscode中用standard style 风格去验证 vue文件
date: 2018-01-29 14:02:53
tags:
- vue
- standardjs
- vscode
---


# 1. JavaScript Standard Style简介
本工具通过以下三种方式为你（及你的团队）节省大量时间：

- 无须配置。 史上最便捷的统一代码风格的方式，轻松拥有。
- 自动代码格式化。 只需运行 standard --fix 从此和脏乱差的代码说再见。
- 提前发现风格及程序问题。 减少代码审查过程中反反复复的修改过程，节约时间。
- 无须犹豫。再也不用维护 .eslintrc, .jshintrc, or .jscsrc 。开箱即用。

安装：
```
npm i standard -g
```

关于[JavaScript 代码规范](https://standardjs.com/readme-zhcn.html), 你可以点击链接看一下。

# 2. 如何在vscode中用JavaScript Standard Style风格去验证 vue文件

实际上[JavaScript Standard Style](https://marketplace.visualstudio.com/items?itemName=chenxsan.vscode-standardjs)有一个FAQ, 说明了如何使用。

但是有一点非常重要的作者没有提到，就是`eslint-plugin-html这个插件必须要安装3.x.x版本的`, 现在`eslint-plugin-html`, 已经升级到4.x版本，默认不写版本号安装的就是4.x版本的，所以会出现问题。[参考](https://github.com/BenoitZugmeyer/eslint-plugin-html/issues/60)

> ESLint v4 is only supported by eslint-plugin-html v3, so you can't use eslint-plugin-html v1.5.2 with it (I should add a warning about this when trying to use the plugin with an incompatible version on ESLint).

> If you do not use ESLint v4, please provide more information (package.json, a gist to reproduce, ...)

```
// FAQ
How to lint script tag in vue or html files?

You can lint them with eslint-plugin-html, just install it first, then enable linting for those file types in settings.json with:

 "standard.validate": [
     "javascript",
     "javascriptreact",
     "html"
 ],
 "standard.options": {
     "plugins": ["html"]
 },
 "files.associations": {
     "*.vue": "html"
 },
If you want to enable autoFix for the new languages, you should enable it yourself:

 "standard.validate": [
     "javascript",
     "javascriptreact",
     { "language": "html", "autoFix": true }
 ],
 "standard.options": {
     "plugins": ["html"]
 }
```


# 3. 综上， 整理一下安装思路

## 3.1. 需要安装哪些包？
- `npm i -g standard`
- `npm i -g eslint-plugin-html@3.2.2` 必须是3x版本
- `npm i -g eslint`
以上三个包都是全局安装的，如果你想看看全局安装了哪些包可以用`npm list -g --depth=0`查看

## 3.2. vscode config 如何写？
```
  "standard.validate": [
    "javascript",
    "javascriptreact",
    {
      "language": "html",
      "autoFix": true
    }
  ],
  "standard.options": {
    "plugin": ["html"]
  },
  "files.associations": {
    "*.vue": "html"
  },
```

## 3.3. 如何在保存文件时，自动使用standard格式化vue文件
```
"standard.autoFixOnSave": true
```

## 3.4. 如果还不行怎么办？
1. 重启一下vscode
2. 重启一下电脑
3. 在此文后追加评论


  [1]: /img/bV0tKn