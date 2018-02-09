---
title: 8行代码的模板字符串替换函数
date: 2018-02-08 13:51:13
tags:
---

# 1. 特点
- 无依赖
- 无检查
- 无错误处理
- 无逻辑
- 无配置

# 2. 代码
```
function render(tpl, data){
    var re = /{{([^}]+)?}}/;
    var match = '';
    while(match = re.exec(tpl)){
        tpl = tpl.replace(match[0],data[match[1]]);
    }
    return tpl;
}

```

# 3. demo
```
var tpl = '/cube_xinbao_dial_result/{{action}}/{{report_type}}/{{query}}/?userId={{userId}}';

var data = {report_type:1, query: '2323', action: 'todolist',userId: '23234234'}

function render(tpl, data){
    var re = /{{([^}]+)?}}/;
    var match = '';
    while(match = re.exec(tpl)){
        tpl = tpl.replace(match[0],data[match[1]]);
    }
    return tpl;
}

console.log(render(tpl,data));

> /cube_xinbao_dial_result/todolist/1/2323/?userId=23234234
```