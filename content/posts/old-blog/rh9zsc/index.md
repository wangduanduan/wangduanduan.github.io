---
title: "oh-my-zsh 安装 tmux插件"
date: "2020-06-17 13:20:24"
draft: false
---

# .zshrc配置
```bash
vim ~/.zshrc

plugins=(git tmux) # 加入tmux, 然后保存退出

source ~/.zshrc
```


# tmux 快捷键

| Alias | Command | Description |
| --- | --- | --- |
| `ta` | tmux attach -t | Attach new tmux session to already running named session |
| `tad` | tmux attach -d -t | Detach named tmux session |
| `ts` | tmux new-session -s | Create a new named tmux session |
| `tl` | tmux list-sessions | Displays a list of running tmux sessions |
| `tksv` | tmux kill-server | Terminate all running tmux sessions |
| `tkss` | tmux kill-session -t | Terminate named running tmux session |
| `tmux` | `_zsh_tmux_plugin_run` | Start a new tmux session |


