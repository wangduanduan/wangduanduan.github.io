---
title: "Vim 常见问题以及解决方案"
date: 2022-05-28T12:21:47+08:00
draft: false
tags:
- vim
---

# 修改coc-vim的错误提示

coc-vim的错误提示窗口背景色是粉红，前景色是深红。这样的掩饰搭配，很难看到具体的文字颜色。

所以我们需要把前景色改成白色。

```
:highlight CocErrorFloat ctermfg=White
```

参考 https://stackoverflow.com/questions/64180454/how-to-change-coc-nvim-floating-window-colors

# vim go一直卡在初始化

有可能没有安装二进制工具

```
:GoInstallBinaries
```

# neovim 光标变成细线解决方案

```
:set guicursor=
```

