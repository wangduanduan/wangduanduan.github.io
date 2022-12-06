---
title: "matplotlib图片弹窗没有弹出"
date: "2021-03-31 21:04:53"
draft: false
---
学习matplotlib绘图时，代码如下，执行过后，图片弹窗没有弹出。

```bash
import matplotlib.pyplot as plt
import matplotlib
plt.plot([1.6, 2.7])
plt.show()
```

并且有下面的报错

> cannot load backend 'qt5agg' which requires the 'qt5' interactive framework, as 'headless' is currently running



看起来似乎是backend没有设置有关。查了些资料，设置了还是不行。

最后偶然发现，我执行python 都是在tmux里面执行的，如果不再tmux会话里面执行，图片就能正常显示。

问题从设置backend, 切换到tmux的会话。

查到sf上正好有相关的问题，可能是在tmux里面PATH环境变量引起的问题。

问题给的建议是把下面的代码写入.bashrc中，

> If you're on a Mac and have been wondering why `/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin` keeps getting prepended to PATH when you run tmux, it's because of a utility called path_helper that's run from your `/etc/profile` file.

> You can't easily persuade tmux (or rather, bash) not to source `/etc/profile` (for some reason tmux always runs as a login shell, which means /etc/profile will be read), but you can make sure that the effects of path_helper don't screw with your PATH.

> The trick is to make sure that PATH is empty before path_helper runs. In my `~/.bash_profile` file I have this:

> ```
if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi
```

> Clearing PATH before path_helper executes will prevent it from prepending the default PATH to your (previously) chosen PATH, and will allow the rest of your personal bash setup scripts (commands further down `.bash_profile`, or in `.bashrc` if you've sourced it from `.bash_profile`) to setup your PATH accordingly.

> 

```bash
if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi
```

```bash
cat /etc/profile # 我有这个文件
PATH=""
source /etc/profile
```


总是，按照sf上的操作，我的问题解决了，图片弹出了。


# 参考

- [https://stackoverflow.com/questions/62423342/python-plot-in-tmux-session-not-showing](https://stackoverflow.com/questions/62423342/python-plot-in-tmux-session-not-showing)
- [https://blog.csdn.net/Meditator_hkx/article/details/59106752](https://blog.csdn.net/Meditator_hkx/article/details/59106752)
- [https://superuser.com/questions/544989/does-tmux-sort-the-path-variable](https://superuser.com/questions/544989/does-tmux-sort-the-path-variable)

