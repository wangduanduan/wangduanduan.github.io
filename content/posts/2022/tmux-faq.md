---
title: "Tmux 常见问题以及解决方案"
date: 2022-05-28T12:30:58+08:00
draft: false
tags:
- tmux
---

# oh my tmux 关闭第二键ctrl-a

ctrl-a可以用来移动光标到行首的，不要作为tmux的第二键

```
set -gu prefix2
unbind C-a
```

# Tmux reload config

```
:source-file ～/.tmux.conf
```

# tmux 显示时间

```
ctrl b + t
```

# tmux从当前目录打开新的窗口

```
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
```


