---
title: "ch4-2 flag获取"
date: "2021-04-24 11:26:21"
draft: false
---

# flag的类型
```bash
enum flag_type {
    FLAG_TYPE_MSG=0,
    FLAG_TYPE_BRANCH,
    FLAG_LIST_COUNT,
};
```


# flag实际上是一种二进制的位

MAX_FLAG就是一个SIP消息最多可以有多少个flag
```bash
#include <limits.h>
typedef unsigned int flag_t;
#define MAX_FLAG  ((unsigned int)( sizeof(flag_t) * CHAR_BIT - 1 ))
```
这个值更具情况而定，我的机器上是最多32个。
```bash
#include <stdio.h>
#include <limits.h>

typedef unsigned int flag_t;
#define MAX_FLAG  ((unsigned int)( sizeof(flag_t) * CHAR_BIT - 1 ))

int main()
{
    printf("%zu\n", sizeof(unsigned int));
    printf("%u\n", CHAR_BIT);
    printf("%u\n", MAX_FLAG);

    return 0;
}

$gcc -o main *.c
$main
4
8
31
```

# 由字符串获取flag

opensips 1.0时，flag都是整数，2.0才引入了字符串。

用数字容易傻傻分不清楚，字符串比较容易理解。

```bash
setflag(3);
setflag(4);
setflag(5);

setflag(IS_FROM_SBC);
```

首先，我们先要获取flag的字符串表示。这个可以用模块的参数传递进来。

```bash
static param_export_t params[]={
    {"use_test_flag", STR_PARAM,  &use_test_flag_str},
    {0,0,0}
};
```
然后我们需要在mod_init或者fixup函数中获取字符串flag对应的flagId
```bash
static int mod_init(void)
{
    flag_use_high = get_flag_id_by_name(FLAG_TYPE_MSG, use_test_flag_str);
    LM_INFO("flag mask: %d\n", flag_use_high);
    return 0;
}
```

在消息处理中，用isflagset去判断flag是否存在。isflagset返回-1，就说明flag不存在。返回1就说明flag已经存在。
```bash
static int w_find_zone_code(struct sip_msg* msg, char* str1,char* str2)
{
    int is_set = isflagset(msg, flag_use_high);
    LM_INFO("flag_use_high is %d\n", is_set);
    return 1;
}
```

