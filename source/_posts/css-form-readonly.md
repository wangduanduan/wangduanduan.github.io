---
title: 奇技淫巧：css实现整个表单只读 form readonly
date: 2018-02-09 13:31:38
tags:
- 表单
---

> 一般的方法往往给表单的各个input、select等加上readonly，但是这个方法有很多缺点。此处就不一一赘述。

我说的方法只需要给表单加上一个类，就可以让表单只读。
```
<form class="form-readonly"></form>
```

# 1. 方法1: 用:before给form做个看不见的蒙版，遮住下面所有的元素，使之不响应任何事件
```
.form-readonly{
    position: relative;
}
.form-readonly:before{
    content: "";
    z-index: 1;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
}
```

# 2. 方法2: 用pointer-events:none, 让所有事件穿透form
```
.form-readonly{
    pointer-events:none;
}
```

关于pointer-events属性，可以看看这个介绍：https://segmentfault.com/a/1190000011182335