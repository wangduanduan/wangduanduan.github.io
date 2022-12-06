---
title: "deepin 大写锁定键映射为左边的shift"
date: "2022-01-12 13:36:24"
draft: false
---
对vim重度用户来说，大写锁定键，百害而无一利。

有三种可能选择

1. 禁用大写锁定键:`gsettings set com.deepin.dde.keyboard layout-options '["caps:none"]'`
2. 将大写锁定键映射为ESC: `gsettings set com.deepin.dde.keyboard layout-options '["caps:swapescape"]'`
3. 将大写锁定映射为Crtl 或者 shift

还有一种设置的方式：直接修改xkbmap
```
➜  ~ setxkbmap -print
xkb_keymap {
	xkb_keycodes  { include "evdev+aliases(qwerty)"	};
	xkb_types     { include "complete+caps(shift)"	};
	xkb_compat    { include "complete"	};
	xkb_symbols   { include "pc+us+cn:2+inet(evdev)"	};
	xkb_geometry  { include "pc(pc105)"	};
};

sudo vim /usr/share/X11/xkb/symbols/pc
```
修改key <CAPS> 行，其中 Shift_L, 是将caps键映射为左边的shift, 也可以设置为RCTL, 表示右边的ctrl键。
```
 key <CAPS> { [ Shift_L ] };
```

> 参考
> [修改键盘映射](https://wiki.deepin.org/index.php?title=%E4%BF%AE%E6%94%B9%E9%94%AE%E7%9B%98%E6%98%A0%E5%B0%84&language=zh)


