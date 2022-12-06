---
title: "sudo !!的妙用"
date: "2021-04-08 13:27:44"
draft: false
---
在ubuntu上执行命令，经常会出现下面的报错：

```bash
tcpdump: eno1: You don't have permission to capture on that device
(socket: Operation not permitted)
```

这种报错一般是执行命令时，没有加上sudo

快速的解决方案是：

1. 按向上箭头键
2. ctrl+a 贯标定位到行首
3. 输入sudo 
4. 按回车

上面的步骤是比较快的补救方案，但是因为向上的箭头一般布局在键盘的右下角，不移动手掌就够不着。一般输入向上的箭头时，右手会离开键盘的本位，会低头看下键盘，找下向上的箭头的位置。

有没有右手不离开键盘本位，不需要低头看键盘的解决方案呢？

答案就是： `sudo !!`  !!会被解释成为上一条执行的命令。sudo !!就会变成使用sudo执行上一条命令。

快试试看吧 sudo bang bang
