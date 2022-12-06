---
title: "iterm2 光标消失了"
date: "2021-04-02 21:09:46"
draft: false
---
终端用着用着，光标消失了。

iterm2 仓库issues给出提示，要在设置》高级里面，Use system cursor icons when possile 为 yes.

![](2022-10-29-19-56-39.png)

然而上面的设置并没有用。

然后看了superuser上的question, 给出提示, 直接在终端输入 `reset` , 光标就会出现。解决了问题。

```bash
reset
```


# 参考

- [https://gitlab.com/gnachman/iterm2/-/issues/6623](https://gitlab.com/gnachman/iterm2/-/issues/6623)
- [https://superuser.com/questions/177377/os-x-terminal-cursor-problem](https://superuser.com/questions/177377/os-x-terminal-cursor-problem)

