---
title: "和系统剪贴板进行交互"
date: 2022-05-28T10:59:03+08:00
draft: false
---

# neovim如何与系统剪贴板交互？
neovim和系统剪贴板的交互方式和vim的机制是不同的，所以不要先入为主的用vim的方式使用neovim。

neovim需要外部的程序与系统剪贴板进行交互，参考:help clipboard

neovim按照如下的优先级级方式选择交互程序：

```
  - |g:clipboard|
  - pbcopy, pbpaste (macOS)
  - wl-copy, wl-paste (if $WAYLAND_DISPLAY is set)
  - xclip (if $DISPLAY is set)
  - xsel (if $DISPLAY is set)
  - lemonade (for SSH) https://github.com/pocke/lemonade
  - doitclient (for SSH) http://www.chiark.greenend.org.uk/~sgtatham/doit/
  - win32yank (Windows)
  - termux (via termux-clipboard-set, termux-clipboard-set)
  - tmux (if $TMUX is set)
```

因为我的操作系统是linux, 所以方便的方式是直接安装xclip。

```
sudo pacman -Syu xclip
```

# 两个系统剪贴板有何不同？

对于windows和mac来说，只有有一个系统剪贴板，对于linux有两个。

- * 剪贴板，鼠标选择剪贴板
- + 剪贴板，选择之后复制剪贴板

如下图，我用鼠标选择了12345, 但是没有按ctrl + c,  这时候你打开nvim， 执行:reg, 可以看到注册器

```
"* 12345
```

如果按了ctrl + c

```
"* 12345
"+ 12345
```

所以，在vim中如果想粘贴系统剪贴板中的内容，可以是用 C-R * 或者 C-R +

# 如何把vim buffer中的全部内容复制到系统剪贴板?

```
:%y+
```

