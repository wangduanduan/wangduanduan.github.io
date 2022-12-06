---
title: "概念理解 module_exports"
date: "2020-08-22 12:45:42"
draft: false
---

# module_exports
这个结构在每个模块中都有，这个有点类似js的export或者说是node.js的module.export。

这是一个接口的规范。

重要讲解几个关键点：

- local_zone_code是模块名字，这个是必需的
- cmds表示在opensips脚本里可以有那些暴露的函数
- params规定了模块的参数
- mod_init在模块初始化的时候会被调用, 只会被调用一次

关于module_exports这个结构的定义，可以查阅：sr_module.h文件

```bash
struct module_exports exports= {
    "local_zone_code",
    MOD_TYPE_DEFAULT,/* class of this module */
    MODULE_VERSION,
    DEFAULT_DLFLAGS, /* dlopen flags */
    0,               /* load function */
    NULL,            /* OpenSIPS module dependencies */
    cmds,
    0,
    params,
    0,          /* exported statistics */
    0,          /* exported MI functions */
    0,          /* exported pseudo-variables */
    0,          /* exported transformations */
    0,          /* extra processes */
    0,          /* pre-init function */
    mod_init,
    (response_function) 0,
    (destroy_function) 0,
    0  /* per-child init function */
};
```


# cmds

```bash
struct cmd_export_ {
    char* name;             /* opensips脚本里的函数名 */
    cmd_function function;  /* 关联的C代码里的函数 */
    int param_no;           /* 参数的个数 */
    fixup_function fixup;   /* 修正参数 */
    free_fixup_function free_fixup; /* 修正参数的 */
    int flags;              /* 函数flag，主要是用来标记函数可以在哪些路由中使用 */
};
```
cmd_function
```bash
typedef  int (*cmd_function)(struct sip_msg*, char*, char*, char*, char*,
            char*, char*);
```


## cmd_function与fixup_function的关系

- cmd_function是在opensips运行后，在路由脚本中会执行到
- fixup_function实际上是在opensips运行前，脚本解析完成后会执行
- fixup_function的目的是在脚本解析阶段发现参数的问题，或者修改某些参数的值

真实的栗子：
```bash
static cmd_export_t cmds[]={
    {"lzc_change", (cmd_function)change_code, 2, change_code_fix, 0, REQUEST_ROUTE},
    {0,0,0,0,0,0}
};

static int change_code_fix(void** param, int param_no)
{
    LM_INFO("enter change_code_fix: param: %s\n", (char *)*param);
    LM_INFO("enter change_code_fix: param_no: %d\n", param_no);
    LM_INFO("enter change_code_fix: local_zone_code: %s len:%d\n", local_zone_code.s,local_zone_code.len);
    return 0;
}
```

上面的定义，可以在opensips脚本中使用lzc_change这个函数。这个函数对应c代码里的change_code函数。这个函数允许接受2两个参数。

opensips脚本
```bash
route{
   lzc_change("abcd","desf");
}
```

debug日志：<br />从日志可以看出来lzc_change有两个参数，change_code_fix被调用了两次，每次调用可以获取参数的值，和参数的序号。
```bash
DBG:core:fix_actions: fixing lzc_change, opensips.mf2.cfg:18
INFO:local_zone_code:change_code_fix: enter change_code_fix: param: abcd
INFO:local_zone_code:change_code_fix: enter change_code_fix: param_no: 1
INFO:local_zone_code:change_code_fix: enter change_code_fix: local_zone_code: 0728 len:4
INFO:local_zone_code:change_code_fix: enter change_code_fix: param: desf
INFO:local_zone_code:change_code_fix: enter change_code_fix: param_no: 2
INFO:local_zone_code:change_code_fix: enter change_code_fix: local_zone_code: 0728 len:4
```

