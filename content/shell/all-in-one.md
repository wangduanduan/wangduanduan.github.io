---
title: "常用shell技巧"
date: 2020-01-07
draft: false
---

# 命令行编辑
- 向左移动光标	ctrl + b
- 向右移动光标	ctrl + f
- 移动光标到行尾	ctrl + e
- 移动光标到行首	ctrl + a
- 清除前面一个词	ctrl + w
- 清除光标到行首	ctrl + u
- 清除光标到行尾	ctrl + k
- 命令行搜索	ctrl + r

# 解压与压缩
1、压缩命令：
命令格式：

```
tar -zcvf 压缩文件名 .tar.gz 被压缩文件名
```
可先切换到当前目录下，压缩文件名和被压缩文件名都可加入路径。

2、解压缩命令：
命令格式：

```
tar -zxvf 压缩文件名.tar.gz
```
解压缩后的文件只能放在当前的目录。

# crontab 每隔x秒执行一次

每隔5秒
```
* * * * * for i in {1..12}; do /bin/cmd -arg1 ; sleep 5; done
```

每隔15秒

```
* * * * * /bin/cmd -arg1
* * * * * sleep 15; /bin/cmd -arg1
* * * * * sleep 30; /bin/cmd -arg1
* * * * * sleep 45; /bin/cmd -arg1
```

# awk从第二行开始读取

```
awk 'NR>2{print $1}'
```

# 查找大文件，并清空文件内容

```
find /var/log -type f -size +1M -exec truncate --size 0 '{}' ';'
```

# switch case 语句

```
echo 'Input a number between 1 to 4'
echo 'Your number is:\c'
read aNum
case $aNum in
    1)  echo 'You select 1'
    ;;
    2)  echo 'You select 2'
    ;;
    3)  echo 'You select 3'
    ;;
    4)  echo 'You select 4'
    ;;
    *)  echo 'You do not select a number between 1 to 4'
    ;;
esac
```

# 以$开头的特殊变量

```
echo $$ # 进程pid
echo $# # 收到的参数个数
echo $@ # 列表方式的参数 $1 $2 $3
echo $? # 上个进程的退出码
echo $* # 类似列表方式，但是参数被当做一个实体, "$1c$2c$3" c是IFS的第一个字符
echo $0 # 脚本名
echo $1 $2 $3 # 第一、第二、第三个参数

for i in $@
do
  echo $i
done

for j in $@
do
  echo $j
done
```

# 判断git仓库是否clean

```
check_is_repo_clean () {
       if [ -n "$(git status --porcelain)" ]; then
           echo "Working directory is not clean"
           exit 1
       fi
}
```

# 文件批处理 for in循环

```
for f in *.txt; do mv $f $f.gz; done
for d in *.gz; do gunzip $d; done
```

# shell 重定向到/dev/null

```
ls &>/dev/null; #标准错误和标准输出都不想看
ls 1>/dev/null; #不想看标准输出
ls 2>/dev/null; 标准错误不想看
```

# sed: -e expression #1, char 21: unknown option to `s'

出现这个问题，一般是要替换的字符串中也有/符号，所以要把分隔符改成 ! 或者 |

```
sed -i "s!WJ_CONF_URL!$WJ_CONF_URL!g" file.txt
```

# 发送UDP消息
在shell是bash的时候， 可以使用 echo 或者 cat将内容重定向到 /dev/udp/ip/port中，来发送udp消息

```
echo "hello" > /dev/udp/192.168.1.1/8000
```

# grep排除自身
下面查找名称包括rtpproxy的进程，grep出来找到这个进程外，还找到了grep这条语句的进程，一般来说，这个进程是多余的。

```
➜  ~ ps aux | grep rtpproxy
root      3353  0.3  0.0 186080   968 ?        Sl    2019 250:05 rtpproxy -f -l
root     31440  0.0  0.0 112672   980 pts/0    S+   10:12   0:00 grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn rtpproxy
```

但是，如果我们用中括号，将搜索关键词的第一个字符包裹起来，就可以排除grep自身。

```
[root@localhost ~]# ps aux | grep '[r]tpproxy'
root      3353  0.3  0.0 186080   968 ?        Sl    2019 250:06 rtpproxy -f -l
```

