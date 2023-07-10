---
title: "VIM typescript 跳转到定义"
date: "2023-07-10 09:30:46"
draft: false
type: posts
tags:
- typescript
categories:
- all
---

在VScode中，可以使用右键来跳转到typescript类型对应的定义，但是用vim的`gd`命令却无法正常跳转。

因为无法正常跳转的这个问题，我差点放弃了vim。

然而我想别人应该也遇到类似的问题。

我的neovim本身使用的是coc插件，然后我就再次到看看官方文档，来确定最终有没有解决这个问题的方案。

功夫不负有心人。

我发现官方给的例子中，就包括了如何配置跳换的配置。

首先说明一下，我本身就安装了`coc-json coc-tsserver`这两个插件，所以只需要将如下的配置写入init.vim

```
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
```

这样的话，在普通模式，按`gy`这个快捷键，就能跳转到对应的类型定义，包括某个npm包的里面的类型定义，非常好用。

亲测有效。