---
title: "变量的使用"
date: "2019-06-16 17:18:55"
draft: false
---

# 变量的使用方式

```bash
$(<context>type(name)[index]{transformation})
```

1. 变量都以$符号开头
2. type表示变量的类型：核心变量，自定义变量，键值对变量
3. name表示变量名：如$var(name), $avp(age)
4. index表示需要，有些变量类似于数组，可以使用需要来指定。需要可以用正数和负数，如-1表示最后一个元素
5. transformations表示类型转换，如获取一个字符串值的长度，大小写转换等操作
6. context表示变量存在的作用域，opensips有请求的作用域和响应的作用域

```bash
# by type
$ru

# type type and name
$hdr(Contact)

# bye type and index
$(ct[0])

# by type name and index
$(avp(gw_ip)[2])

# by context
$(<request>ru)
$(<reply>hdr(Contact))
```



# 引用变量

所有的引用变量都是可读的，但是只有部分变量可以修改。引用变量一般都是英文含义的首字母缩写，刚开始接触opensips的同学可能很不习惯。实际上通过首字母大概是可以猜出变量的含义的。

必须记住变量的用黄色标记。

| 变量名 | 英文含义 | 中文解释 | 是否可修改 |
| --- | --- | --- | --- |
| $ru | request url | 请求url | 是 |
| $rU | Username in SIP Request's URI |  | 是 |
| $ci | call id | callId |  |
| $hdr(from) | request headers from  | 请求头中的from字段 | 是 |
| $Ts | current time unix Timestamp | 当前时间的unix时间戳 |  |
| $branch | Branch |  |  |
| $cl | Content-Length |  |  |
| $cs | CSeq number |  |  |
| $cT | Content-Type |  |  |
| $dd | Domain of destination URI | 目标地址的域名 | 是 |
| $di | Diversion header URI |  |  |
| $dp | Port of destination URI | 目标地址的端口 | 是 |
| $dP | Transport protocol of destination URI | 传输协议 |  |
| $du | Destination URI | 目标地址 | 是 |
| $fd | From URI domain |  |  |
| $fn | From display name |  |  |
| $ft | From tag |  |  |
| $fu | From URI |  |  |
| $fU | From URI username |  |  |
| $mb | SIP message buffer |  |  |
| $mf | Message Flags |  |  |
| $mi | SIP message ID |  |  |
| $ml | SIP message length |  |  |
| $od | Domain in SIP Request's original URI |  |  |
| $op | Port of SIP request's original URI |  |  |
| $oP | Transport protocol of SIP request original URI |  |  |
| $ou | SIP Request's original URI |  |  |
| $oU | Username in SIP Request's original URI |  |  |
| $param(idx)  | Route parameter |  |  |
| $pp | Process id |  |  |
| $rd |  Domain in SIP Request's URI |  |  |
| $rb | Body of request/reply |  | 是 |
| $rc | Returned code |  |  |
| $re | Remote-Party-ID header URI |  |  |
| $rm | SIP request's method |  |  |
| $rp | SIP request's port |  | 是 |
| $rP |  Transport protocol of SIP request URI |  |  |
| $rr |  SIP reply's reason |  |  |
| $rs | SIP reply's status |  |  |
| $rt | reference to URI of refer-to header |  |  |
| $Ri  | Received IP address |  |  |
| $Rp |  Received port |  |  |
| $sf |  Script flags |  |  |
| $si |  IP source address |  |  |
| $sp | Source port |  |  |
| $td | To URI Domain |  |  |
| $tn | To display name |  |  |
| $tt | To tag |  |  |
| $tu | To URI |  |  |
| $tU | To URI Username |  |  |
| $TF |  String formatted time |  |  |
| $TS |  Startup unix time stamp |  |  |
| $ua | User agent header |  |  |


更多变量可以参考：[https://www.opensips.org/Documentation/Script-CoreVar-2-4](https://www.opensips.org/Documentation/Script-CoreVar-2-4)



# 键值对变量

1. 键值对变量是按需创建的
2. 键值对只能用于有状态的路由处理中
3. 键值对会绑定到指定的消息或者事务上
4. 键值对初始化时是空值
5. 键值对可以在所有的路由中读写
6. 在响应路由中使用键值对，需要加载tm模块，并且设置onreply_avp_ mode参数
7. 键值对可以读写，也可以删除
8. 可以把键值对理解为key为hash, 值为堆栈的数据结构

```bash
$avp(my_name) = "wang"
$avp(my_name) = "duan"

xlog("$avp(my_name)") # duan
xlog("$avp(my_name)[0]") # wang
xlog("$avp(my_name)[*]") # wang duanduan

```


# 脚本变量

1. 脚本变量只存在于当前主路由及其子路由中。路由结束，脚本变量将回收。
2. 脚本变量需要指定初始化值，否则变量的值将不确定。
3. 脚本变量只能有一个值
4. 脚本变量读取要比键值对变量快，脚本变量直接引用内存的位置
5. 如果需要变量，可以优先考虑使用脚本变量

```bash
$var(my_name) = "wangduanduan"
$var(log_msg) = $var(my_name) + $ci + $fu
xlog("$var(log_msg)")
```



# 脚本翻译
脚本翻译可以理解为一种工具函数，可以用来获取字符串长度，获取字符串的子字符等等操作。


| 获取字符串长度 | $(fu{s.len}) |  |
| --- | --- | --- |
| 字符串截取子串 | $(var(x){s.substr,5,2}) |  |
| 获取字符串的某部分 | $(avp(my_uri){uri.user}) |  |
| 将字符串值转为整数 | $(var(x){s.int}) |  |
| 翻译也可以链式调用 | $(hdr(Test){s.escape.common}{s.len}) |  |





