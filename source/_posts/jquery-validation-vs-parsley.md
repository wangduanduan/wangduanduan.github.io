---
title: 表单验证工具 jquery-validation Vs Parsley
date: 2018-02-08 09:26:00
tags:
- jQuery
- Parsley
---

# 1. 基本对比

名称 | gitbub地址 | stars | 文档地址
--- | --- | --- | ---
jquery-validation | [这里](https://github.com/jquery-validation/jquery-validation) | 7859(截止7/21) | [这里](http://www.runoob.com/jquery/jquery-plugin-validate.html)
Parsley.js | [这里](https://github.com/guillaumepotier/Parsley.js) | 7979(截止7/21) | [这里](http://parsleyjs.org/)

# 2. 强烈推荐Parsley
这两个表格验证插件我都用过，最早用的是jqueryValidataion, 现在用Parsley。
这两个插件都`依赖jQuery`。但是如果说那个跟好用的话，真心推荐Parsley。Parsley`号称不用写一行代码就能验证表单`。另外从star的数量上也可以看出来Parsley更流行。而且Parsley支持在html中就将错误信息定义在里面。

Parsley优势

- `直观的DOM API`: 像没有其他表单验证库一样，只需用HTML格式写入您的要求，Parsley将会做剩下的所有事情！不需要编写一行代码来验证表单。
- `动态表单验证`： parsley现在更聪明，它会自动检测您的表单的修改并相应地调整其验证。简单地添加，删除或编辑字段，parsley将会自动验证。
- 还有好多... 


```
<form>
 <input type="text" required="" 
 data-parsley-checkphonenum 
 data-parsley-checkphonenum-message="手机号码格式有误" 
 name="phoneNum" class="form-control" 
 placeholder="请填写手机号">
</form>

//验证表单
// 注意 checkphonenum是我自定义的验证规则，添加到parsley里面的
$('from').parsley().validate();
```


  [1]: /img/bVRjET