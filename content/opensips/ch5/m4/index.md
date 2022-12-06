---
title: "使用m4增强opensips.cfg脚本预处理能力"
date: "2020-07-22 14:16:17"
draft: false
---
相比于kamailo的脚本的预处理能力，opensips的脚本略显单薄。OpenSIPS官方也认识到了这一点，但是也并未准备如何提高这部分能力。因为OpenSIPS是想将预处理交给这方面的专家，也就是大名鼎鼎的m4(当然，你可能根本不知道m4是啥)。<br /> 

# 举例来说

我们看一下opensips自带脚本的中的一小块。 里面就有三个要配置的地方

1. 这个listen的地址： listen=udp:127.0.0.1:5060  
2. 数据库地址的配置：modparam("usrloc", "db_url", "dbdriver://username:password@dbhost/dbname")
3. 数据库地址的配置：modparam("acc", "db_url", "mysql://user:password@localhost/opensips")


```
auto_aliases=no

listen=udp:127.0.0.1:5060   # CUSTOMIZE ME

mpath="/usr/local//lib/opensips/modules/"
loadmodule "usrloc.so"
modparam("usrloc", "db_url", "dbdriver://username:password@dbhost/dbname")


modparam("acc", "early_media", 0)
modparam("acc", "report_cancels", 0)
modparam("acc", "detect_direction", 0)
modparam("acc", "db_url", "mysql://user:password@localhost/opensips")

```

随着脚本代码的增多，各种配置往往越来越多。真是脚本里，配置的地方远远不止三处！

你开发了OpenSIPS的脚本，但是真正部署的服务的可能是其他人。那么其他拿到你的脚本的时候，他们怎么知道要改哪些地方呢，难道要搜索一下，所有出现`#CUSTOMIZE ME`的地方就是需要配置的？ 难道他们每次部署一个服务，就要改一遍脚本的内容？ 改错了谁负责？

**如果你不想被运维人员在背后骂娘，就不要把配置性的数据写死到脚本里！**

**如果你不想在打游戏的时候被运维人员点电话问这个配置出错应该怎么解决，就不要把配置型数据写死到脚本里！**

** 那么，你就需要用到M4**



# 什么是M4？

M4是一种宏语言，如果你不清楚什么是宏，你就可以把M4想想成一种字符串替换的工具。



# 如何安装M4?

大部分Linux上都已经默认安装了m4,  你可以用`m4 --version`检查一下m4是否已经存在。

```
m4 --version
Copyright © 2021 Free Software Foundation, Inc.
GPLv3+ 许可证: GNU 通用公共许可证第三版或更高版本 <https://gnu.org/licenses/gpl.html>。
这是自由软件: 您可自由更改并重新分发它。
在法律所允许的范围内，不附带任何担保条款。
```

如果不存在的话，可以用对应常用的包管理工具来安装，例如

```
apt-get install m4
```


# 能否举个m4例子？

hello-world.m4
```
define(`hello_world', `你好，世界')

小王说: hello_world
```

然后执行:  `m4 hello-world.m4`

```
小王说: 你好，世界
```

效果就是 hello_world这个字符，被我们定义的字符串给替换了。<br /> 

# 为什么要做预处理？

我管理过的OpenSIPS脚本，最长的大概有1500行左右。刚开始接手的时候，我花了很长时间才理清脚本的功能。

这个脚本的存在的问题是：

1. 大段的逻辑都集中在请求路由中，功能比较缠绕，很容易改动一个地方，导致不可预测的问题
2. 配置性的变量和脚本融合在一起，脚本迁移时，要改动的地方比较多，容易出错
3. 某些环境需要某些功能，某些环境有不需要某些功能，很难做到兼容，结果就导致脚本的版本太多，难以维护

处理的目标

1.  将比较大的请求路由，按照功能划分多个子路由，专注处理功能内部的事情，做到高内聚，低耦合。可以使用m4的include指令，将多个文件引入到一个文件中。其实OpenSIPS本身也有类似的指令，include_file，但是这个指令并不是会在运行前生成一个统一的目标文件，有时候出错，不好排查问题出现的代码行。另外Include的文件太多，也不好维护。
2. 将配置性变量，定义成m4的宏，有m4负责统一的宏展开。配置文件可以单独拿出来，也可以由m4的命令行参数传入。
3. 关于不同环境的差异化编译，可以使用m4的条件语句。例如当某个宏的定义时展开某个语句，或者某个宏的值等于某个值后，再include某个文件。这样就可以做到条件展开和条件引入。



