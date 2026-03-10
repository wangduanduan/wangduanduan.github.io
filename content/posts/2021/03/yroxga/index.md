---
title: "oh my tmux tmux的高级定制"
date: "2021-03-11 17:50:30"
draft: false
---
参考： [https://github.com/gpakosz/.tmux](https://github.com/gpakosz/.tmux)

优点：

- 界面非常漂亮，有很多指示图标，能够实时的查看系统状态，session和window信息
- 快捷键非常合理，非常好用


```sql
cd
git clone https://gitee.com/wangduanduan/tmux.git
mv tmux .tmux
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
```


# 微调配置

## 启用ctrl+a光标定位到行首
默认情况下，ctrl+a被配置成和ctrl+b的功能相同，但是大多数场景下，ctrl+a是readline的光标回到行首的快捷键，

所以我们需要恢复ctrl+a的原有功能。

只需要把下面的两行取消注释
```bash
set -gu prefix2      
unbind C-a  
```


## 复制模式支持jk上下移动
```bash
set -g mode-keys vi
```


## 在相同的目录打开新的窗口或者标签页
```bash
tmux_conf_new_window_retain_current_path=true
tmux_conf_new_pane_retain_current_path=true
```


## 隐藏系统运行时间信息
状态栏的系统运行时长似乎没什么用，可以隐藏

```bash
tmux_conf_theme_status_left=" ❐ #S "
```

