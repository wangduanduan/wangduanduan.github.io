---
title: "大写锁定键映射为escape"
date: "2021-05-24 20:25:34"
draft: false
---
大写锁定键一般都是非常鸡肋的功能。

# 仅仅一次生效
```
 setxkbmap -option caps:escape  大写锁定键改为esc
 
 setxkbmap -option ctrl:nocaps  大写锁定键改为ctrl
```

# 永久生效

- /etc/X11/xorg.conf.d/90-custom-kbd.conf
```
Section "InputClass"
    Identifier "keyboard defaults"
    MatchIsKeyboard "on"

    Option "XKbOptions" "caps:escape"
EndSection
```
注销或者重启后生效

[https://superuser.com/questions/566871/how-to-map-the-caps-lock-key-to-escape-key-in-arch-linux](https://superuser.com/questions/566871/how-to-map-the-caps-lock-key-to-escape-key-in-arch-linux)<br />[https://wiki.archlinux.org/title/X_keyboard_extension](https://wiki.archlinux.org/title/X_keyboard_extension)


