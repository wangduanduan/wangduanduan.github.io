---
title: "opensips崩溃分析"
date: "2021-08-19 19:30:14"
draft: false
---

# core dump文件在哪里？

一般情况下，opensips在崩溃的时候，会产生core dump文件。这个文件一般位于跟目录下，名字如core.xxxx等的。

core dump文件一般大约有1G左右，所以当产生core dump的时候，要保证系统的磁盘空间是否足够。


# 如何开启core dump？

第一，opensips脚本中有个参数叫做disable_core_dump， 这个参数默认为no, 也就是启用core dump, 可以将这个参数设置为no, 来禁用core dump。但是生产环境一般建议还是开启core dump, 否则服务崩溃了，就只能看日志，无法定位到具体的崩溃代码的位置。

```javascript
disable_core_dump=yes
```

第二，还需要在opensips启动之前，运行：`ulimit -c unlimited`, 这个命令会让opensips core dump的时候，不会限制core dump文件的大小。一般来说core dump文件的大小是共享内存 + 私有内存。

第三，opensips进程的用户如果不是root, 那么可能没有权限将core dump文件写到/目录下。有两个解决办法，

1. 用root用户启动opensips进程
2. 使用-w 参数配置opensips的工作目录，core dump文件将会写到对应的目录中。例如：opensips -w /var/log

如果core dump失败是因为权限的问题， opensips的日志文件中将会打印：

```systemverilog
Can't open 'core.xxxx' at '/': Permission denied
```


# 如何分析core dump文件？

使用gdb
```systemverilog
gdb $(which opensips) core.12333
# 进入gdb调试之后, 输入bt full, 会打印详细的错误栈信息
bt full
```


# 没有产生core dump文件，如何分析崩溃原因？
使用objdump。

一般来说opensips崩溃后，日志文件中一般会出现下面的信息

```systemverilog
kernel: opensips[8954]: segfault at 1ea72b5 ip 00000000004be532 sp 00007ffe9e1e6df0 error 4 in opensips[400000+203000]

```

我们从中取出几个关键词

1. at 1ea72b5 尝试访问的内存地址偏移
2. error 4  错误的类型 fault was an instruction fetch
3. ip 0000000000**4be532** 指令指针的位置， 注意这个**4be532**
4. sp 00007ffe9e1e6df0   栈指针的位置
5. 400000+203000

```systemverilog
x86架构
/*
 * Page fault error code bits
 *      bit 0 == 0 means no page found, 1 means protection fault
 *      bit 1 == 0 means read, 1 means write
 *      bit 2 == 0 means kernel, 1 means user-mode
 *      bit 3 == 1 means use of reserved bit detected
 *      bit 4 == 1 means fault was an instruction fetch
 */
#define PF_PROT         (1<<0)
#define PF_WRITE        (1<<1)
#define PF_USER         (1<<2)
#define PF_RSVD         (1<<3)
#define PF_INSTR        (1<<4)
```

使用objdump, 可以将二进制文件，反汇编找到对应代码的位置。比如说我们可以在反汇编的输出中搜索**4be532，就可以找到对应代码的位置。**

```systemverilog
objdump -j .text -ld -C -S $(which opensips) > op.txt
```

然后我们在op.txt中搜索4be523,  就能找到对饮的源码或者函数的位置。然后根据源码分析问题。



# 参考

- [https://www.opensips.org/Documentation/TroubleShooting-Crash](https://www.opensips.org/Documentation/TroubleShooting-Crash)
- [https://stackoverflow.com/questions/2549214/interpreting-segfault-messages](https://stackoverflow.com/questions/2549214/interpreting-segfault-messages)
- [https://stackoverflow.com/questions/2179403/how-do-you-read-a-segfault-kernel-log-message/2179464#2179464](https://stackoverflow.com/questions/2179403/how-do-you-read-a-segfault-kernel-log-message/2179464#2179464)
- [https://rgeissert.blogspot.com/p/segmentation-fault-error.html](https://rgeissert.blogspot.com/p/segmentation-fault-error.html)

