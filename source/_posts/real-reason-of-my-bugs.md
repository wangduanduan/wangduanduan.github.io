---
title: 我苦苦寻找诡异的bug原因，其实是我的无知
date: 2018-02-09 13:13:12
tags:
- 思想者
---

# 问题1：chosen插件无法显示图标
`问题现象`
在我本地调试的时候，我使用了一个多选下拉框的插件，就是[chosen](https://harvesthq.github.io/chosen/), 不知道为什么，这个多选框上面的图标不见了。我找了半天没有找到原因，然后我把我的机器的内网地址给我同事，让他访问我机器，当它访问到这个页面时。他的电脑上居然显示出了这个下拉框的图标。

`这是什么鬼？`, 为什么同样的代码，在我的电脑上显示不出图标，但是在他的电脑上可以显示。有句名言说的好：`没有什么bug是一遍调试解决不了的，如果有，就再仔细调试一遍`。于是我就再次调试一遍。

我发现了一些第一遍没有注意到的东西`媒体查询`，就是在css里有这样的语句：
```
@media
```
从这里作为切入口，我发现：`媒体查询的类会覆盖它原生的类的属性`

由于我的电脑视网膜屏幕，分辨率比较高，触发了媒体查询，这就导致了媒体查询的类覆盖了原生的类。而覆盖后的类，使用了`chosen-sprite@2x.png`作为图标的背景图片。但是这个图片并没有被放在这个插件的目录下，有的只有`chosen-sprite.png`这个图片。在一般情况下，都是用`chosen-sprite.png`作为背景图片的。这就解释了：为什么同事的电脑上出现了图标，但是我的电脑上没有出现这个图标。

总结: `如果你要使用一个插件，你最好把这个插件的所有文件都放在同一个目录下。而不要只放一些你认为有用的文件。最后：媒体查询的相关知识也是必要的。`

# 问题2：jQuery 与 Vue之间的暧昧
jQuery流派代表着直接操纵DOM的流派，Vue流派代表着操纵数据的流派。

如果在项目里，你使用了一些jQuery插件，也使用了Vue，这就可能导致一些问题。

举个例子：

```
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <script src="https://cdn.bootcss.com/vue/2.4.4/vue.js"></script>
    <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
</head>
<body>

<div id="app">
    姓名 <input type="text" v-model="userName"> <br/>
    年龄 <input type="text" id="userAge" v-model="userAge"> <br/>
</div>


<script type="text/javascript">

new Vue({
    el: '#app',
    data: {
        userName: '',
        userAge: 12
    }
});

$('#userAge').val(14);

</script>
</body>
</html>

```

在页面刚打开时：姓名输入框是空的，年龄输入框是14。但是一旦你在姓名输入框输入任何字符时，年龄输入框的值就会变成12。

如果你仔细看过[Vue官方文档](https://cn.vuejs.org/v2/guide/forms.html)，你会很容易定位问题所在。

```
v-model 会忽略所有表单元素的 value、checked、selected 特性的初始值。因为它会选择 Vue 实例数据来作为具体的值。你应该通过 JavaScript 在组件的 data 选项中声明初始值。---Vue官方文档
```

你可以用 v-model 指令在表单控件元素上创建双向数据绑定。它会根据控件类型自动选取正确的方法来更新元素。尽管有些神奇，但 `v-model 本质上不过是语法糖，它负责监听用户的输入事件以更新数据`，并特别处理一些极端的例子。

当userAge被jQuery改成14时，Vue实例中的userAge任然是12。当你输入userName时，Vue发现数据改变，触发虚拟DOM的重新渲染，同时也将userAge渲染成了12。

![](http://p3alsaatj.bkt.clouddn.com/20180209131356_2Lfly1_Screenshot.jpeg)

总结：`如果你在Vue项目中逼不得已使用jQuery, 你要知道这会导致哪些常见的问题，以及解决思路。`

# 最后
`我苦苦寻找诡异的bug原因，其实是我的无知。`


  [1]: /img/bVWuhV