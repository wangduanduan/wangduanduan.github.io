---
title: "vscode 终端重复输出命令名"
date: "2021-09-14 08:37:51"
draft: false
---

# 问题现象与解决方案

```bash
➜ ✗ date
dateTue Sep 14 08:37:29 CST 2021
```

问题现象描述：在vscode输出执行某个命令，但是命令的输出会带有命令的名字。<br />期望：命令输出不带有命令的名字

引起这个问题的很大原因可能是：

1. 你用了zsh、并且你用了tmux, 并且你在.zshrc中设置了环境变量`export TERM=screen-256color`

在vscode终端中输入下面的命令：
```bash
echo $TERM
screen-256color
```
如果输出$TERM是screen-256color，那必然是你设置了TERM的环境变量引起的，只只需要注释掉zshrc中TERM的设置就可以。

1. 注释掉TERM的值
2. source ~/.zshrc
3. 重新打开一个新的vscode终端

输入命令: 可以看到问题已经解决。TERM的值被设置成xterm-256color
```bash
✗ date
Tue Sep 14 08:46:38 CST 2021

✗ echo $TERM
xterm-256color
```



# 参考链接

- [https://github.com/microsoft/vscode/issues/102107](https://github.com/microsoft/vscode/issues/102107)

