---
title: 从一个小场景学会使用 apply方法
date: 2018-02-07 10:12:36
tags:
---

# 需求
- 需要自定义一个log方法，这个方法可以像原生的console.log一样
- 在开发环境我希望调用这个log会输出日志信息，生产环境我希望即使调用了这个方法，也不会输出日志信息。


# 实现这个log
- 可能要使用apply或者call方法
- log的参数个数和类型都是不固定的
- call的参数个数是固定的，要排除它
- apply的参数是需要一个`数组`，这个合适，可以使用`arguments`来当做数组传递


# 代码
```
var MyLog = {
    silent: false,
    log: function(){
        if(!this.silent){
            console.log.apply(this, arguments);
        }
    }
};
```

# 试用
```
> MyLog.log(1,2,3, '4545');
1 2 3 "4545"
undefined

> MyLog.silent = true
true

> MyLog.log(1,2,3, '4545');
undefined
```

# 后记
- 不要随处使用console.log，因为这样当你不需要日志输出的时候，你就要到处填坑了
- 不要使用alert，这个很烦人