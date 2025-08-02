---
title: "使用m4给opensips脚本增加预处理能力"
date: "2025-08-02 11:17:08"
draft: false
type: posts
tags:
- all
categories:
- all
---

> demo 代码仓库 ： https://cnb.cool/eddie2072/opensips-forum/-/tree/main/how-to-use-m4

# 使用m4给opensips脚本增加预处理能力

## 为什么要预处理？

1. **运维便利**。有预处理，脚本里的IP地址，端口，密码，用户名等信息，可以由运维人员统一配置，脚本只需要引用配置文件，就可以完成脚本的运行。否则，运维人员只能手工去修改每个配置写死的地方。容易出错，且非常麻烦。

所以，我们在写脚本的时候，需要从脚本中抽离配置性质的数据。例如监听的IP地址，端口，数据库的用户名和密码等信息。

这样脚本就变层两个部份，配置文件 + 脚本本身。

运维人员只需要修改配置文件就可以。 以本demo为例子， 运维在线上部署脚本，只需要修改env.prd.m4文件就可以。 


2. **预处理可以增加脚本的复用性**。 不同环境，往往需要的功能不同。A环境需要X功能，B环境不需要X功能，那么怎么维护呢。 不用怕，有了m4条件分支，可以根据不同不配置，渲染出不同的结果。

3. **m4基本在所有linux都已经安装好了**，不用额外在安装依赖。 很多有经验的程序员，往往也不知道什么是m4, 其实大名顶顶的autoconf, 底层就依赖了m4。


## m4难不难学？

m4语法简单，语法强大，但是我们能用到的，基本不超过5个语法。

### 定义宏

下面是定义宏的语法，这样写之后，所有字符串ENV_LISTEN_IP都会被替换为127.0.0.1

```c
define(ENV_LISTEN_IP, 127.0.0.1)
```

### 引用其他文件

有了引用，我们就不需要把所有功能放到一个大文件中。 

```
include(<<src/loadmodule.m4>>)
include(<<src/request.m4>>)
include(<<src/relay.m4>>)
include(<<src/per_branch_ops.m4>>)
include(<<src/handle_nat.m4>>)
include(<<src/missed_call.m4>>)
```

### ifelse(cond1,cond2, yes, no)

如果cond1和cond2相同，则展开第三个参数yes, 否则展开第四个参数no

```
ifelse(ENV_ENABLE_NAT,yes,use nat, not use nat)
```

### 引号

引号，就是用来告诉m4, 引号里的内容应该看作是一个整体。

m4默认的引号是``'',  看起来很怪异，很难从视觉上做配对。 所有有强迫症，或者视觉洁癖的人，会非常讨厌m4。

```c
define(`ENV_LISTEN_IP', `127.0.0.1')
```

但是这个引号是可以修改的，我们用changequote去修改默认的引号, 将引号改为`<<>>`

```c
changequote(<<,>>)
define(<<ENV_LISTEN_IP>>, <<127.0.0.1>>)
```

### 如何调试宏, 使用-dV 参数

```
m4 -dV opensips.m4
```

### 解决宏冲突问题

如果脚本里有个变量和m4的宏名字冲突，那么往往会出现一些怪异的问题。

m4早就想到了解决方案， 在执行m4时候，可以加上-P参数，m4所有内置的宏就会必须写成以m4_开头。 例如

```c
m4_define(<<ENV_LISTEN_IP>>, <<127.0.0.1>>)
```

```sh
m4 -P opensips.m4
```

### m4的劣势

1. m4没有类似foreach的循环，但是可以通过m4的递归实现。
2. m4做简单的字符串替换，但是对于复杂字符串处理，m4的效率会比较低，而且语法比较复杂。 但是对于处理opensips的配置文件，m4则是刚刚好的完美工具。


## 有意思的几个扩展

### 检查宏是否未定义，或者是否为空字符串，空则报错退出

```c
m4_divert(-1)
m4_define(<<ASSERT_NOT_EMPTY>>,<<
    m4_ifelse($1,,<<
        m4_errprint(<<$1 is empty >>)
        m4_m4exit(1)
    >>,)
>>)
m4_divert(0)m4_dnl

ASSERT_NOT_EMPTY(this_is_empty)
```

### foreach 循环

```c
  m4_changequote(<<,>>)m4_dnl
  m4_divert(-1)
  m4_define(<<X_FOREACH>>, <<m4_pushdef(<<$1>>)_foreach($@)m4_popdef(<<$1>>)>>)
  m4_define(<<_arg1>>, <<$1>>)
  m4_define(<<_foreach>>, <<m4_ifelse(<<$2>>, <<()>>, <<>>,
    <<m4_define(<<$1>>, _arg1$2)$3<<>>$0(<<$1>>, (m4_shift$2), <<$3>>)>>)>>)
  m4_divert(0)m4_dnl


  X_FOREACH(x,(a.com,b.com,c.com),
  alias=udp:x
  )
```

上面会输出

```c
alias=udp:a.com
alias=udp:b.com
alias=udp:c.com
```

### 日志前缀

```c
m4_divert(-1)
m4_define(<<X_LOG_PREFIX>>,<<$socket_in $ci $rm/$rs $route.name/$cfg_line $ru $fu>$tu $ua :: >>)
m4_define(<<X_INFO>>,<<xlog("L_INFO", "X_LOG_PREFIX $*")>>)
m4_define(<<X_ERR>>,<<xlog("L_ERR", "X_LOG_PREFIX $*")>>)
m4_define(<<X_WARN>>,<<xlog("L_WARN", "X_LOG_PREFIX $*")>>)
m4_define(<<X_NOTICE>>,<<xlog("L_NOTICE", "X_LOG_PREFIX $*")>>)
m4_divert(0)m4_dnl
```

通过上面的语法，我们只需要在脚本里写

```
X_INFO(ban this ip $si);
```

就会被渲染为

```
xlog("L_INFO", "$socket_in $ci $rm/$rs $route.name/$cfg_line $ru $fu>$tu $ua :: ban this ip $si")
```

# 参考
- https://www.gnu.org/software/m4/manual/m4.html#Quoted-strings