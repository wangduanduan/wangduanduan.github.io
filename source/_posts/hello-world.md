---
title: Hello World
tags:
- js
---
Welcome to [Hexo](https://hexo.io/)! This is your very first post. Check [documentation](https://hexo.io/docs/) for more info. If you get any problems when using Hexo, you can find the answer in [troubleshooting](https://hexo.io/docs/troubleshooting.html) or you can ask me on [GitHub](https://github.com/hexojs/hexo/issues).

JS最佳实践
> update 2017/03/07
> create by wdd
> 一直会更新
> git:https://github.com/wangduanduan/JS-Best-Practices

[TOC]

# 1 可维护性
> 很多时候，我们不是从零开始，开发新代码。而是去维护别人的代码，以他人的工作成果为基础。确保自己的代码可维护，是赠人玫瑰，手留余香的好事。一方面让别人看的舒服，另一方面也防止自己长时间没看过自己的代码，自己都难以理解。

## 1.1 什么是可维护代码
可维护的代码的一些特征

- `可理解`易于理解代码的用途
- `可适应`数据的变化，不需要完全重写代码
- `可扩展`要考虑未来对核心功能的扩展
- `可调试`给出足够的信息，让调试的时候，确定问题所在
- `不可分割`函数的功能要单一，功能粒度不可分割，可复用性增强

## 1.2 代码约定
### 1.2.1 可读性
- 统一的缩进方式
- 注释
- 空白行

#### 缩进：
- 一般使用4个空格
- 不用制表符的原因是它在不同编辑器里显示效果不同

#### 注释：哪些地方需要注释？
- 函数和方法
- 大段代码
- 复杂的算法
- hack

#### 空白行：哪些地方需要空白行？
- 方法之间
- 方法里的局部变量和第一个语句之间
- 单行或者多行注释
- 方法内衣个逻辑单元之间
```
// Good
if (wl && wl.length) {

    for (i = 0, l = wl.length; i < l; ++i) {
        p = wl[i];
        type = Y.Lang.type(r[p]);
        
        if (s.hasOwnProperty(p)) {
        
            if (merge && type == 'object') {
                Y.mix(r[p], s[p]);
            } else if (ov || !(p in r)) {
                r[p] = s[p];
            }
        }
    }
}
```

### 1.2.2 变量名和函数名
> There are only two hard problem in Computer Science cache invalidation and naming things.---Phil Karlton
- 驼峰式命名
- 变量名以名词开头
- 方法名以动词开头
- 常量全部大写
- 构造函数以大写字母开头
- jQuery对象以"$"符号开头
- 自定义事件处理函数以“on”开头

```
// Good
var count = 10;
var myName = "wdd";
var found = true;

// Bad: Easily confused with functions
var getCount = 10;
var isFound = true;

// Good
function getName() {
    return myName;
}

// Bad: Easily confused with variable
function theName() {
    return myName;
}

// Bad:
var btnOfSubmit = $('#submit');

// Good:
var $btnOfSubmit = $('#submit');

// Bad:给App添加一个处理聊天事件的函数，一般都是和websocket服务端推送消息相关
App.addMethod('createChat',function(res){
    App.log(res);
});
// Bad: 此处调用,这里很容易误以为这个函数是处理创建聊天的逻辑函数
App.createChat();

// Good: 
App.addMethod('onCreateChat',function(res){
    App.log(res);
});
// Good：此处调用
App.onCreateChat();
```
> 变量命名不仅仅是一种科学，更是一种艺术。总之，要短小精悍，见名知意。有些名词可以反应出变量的类型。

#### `变量名`

名词 | 数据类型含义
--- | ---
count, length,size |  数值
name, title,message | 字符串
i, j, k | 用来循环
car,person,student,user | 对象
success,fail | 布尔值
payload | post数据的请求体
method | 请求方式

#### `函数名`

动词 | 含义
--- | ---
can | Function returns a boolean
has | Function returns a boolean
is | Function returns a boolean
get | Function returns a nonboolean
set |　Function is used to save a value

#### `一些与函数名搭配的常用动词`
动词 | 用法
--- | ---
send | 发送
resend | 重发
validate | 验证
query | 查询
create | 创建
add | 添加
delete | 删除
remove | 移除
insert | 插入
update | 更新，编辑
copy | 复制
render | 渲染
close | 关闭
open | 开启
clear | 清除
edit | 编辑
query | 查询
on | 当事件发生
list | 渲染一个列表，如用户列表renderUsersList()
content | 渲染内容，如用户详情的页面 renderUserContent()

#### `接口常用的动词`
对于http请求的最常用的四种方法，get,post,put,delete，有一些常用的名词与其对应

含义 | 请求方法 | 词语 | 栗子
--- | --- | --- | ---
增加 | post | create | createUser,createCall
删除 | delete | delete | deleteUser
修改 | put | update | updateUser,updateProfile
查询 | get | get,query | getUser,queryUser(无条件查询使用get，有条件查询使用query) 


#### `学会使用单复数命名函数`

函数名 | 含义
--- | ---
getUser() | 获取一个用户，一般是通过唯一的id来获取
getUsers() | 获取一组用户，一般是通过一些条件来获取
createUser() | 创建一个用户
createUsers() | 创建一组用户

#### `常量`

```
var MAX_COUNT = 10;
var URL = "http://www.nczonline.net/";
```

#### `构造函数`

```
// Good
function Person(name) {
    this.name = name;
}
Person.prototype.sayName = function() {
    alert(this.name);
};
var me = new Person("wdd");
```

#### `底层http请求接口函数`

- 建议使用“_”开头，例如App._getUsers();而对于接口函数的封装，例如App.getUsers(),内部逻辑调用App._getUsers();

### 1.2.3 文件名
- 全部使用小写字母
- 单词之间的间隔使用“-”

eg：
```
app-main.js
app-event.js
app-user-manger.js
```

### 1.2.4 文件归类
自己写的js文件最好和引用的一些第三方js分别放置在不同的文件夹下。

### 1.2.5 千万别用alert

`alert的缺点`

- 如果你用alert来显示提醒消息，那么用户除了点击alert上的的确定按钮外，就只能点击上面的关闭，或者选择禁止再选择对话框，除此以外什么都不能操作。
- 有些浏览器如果禁止了alert的选项，那么你的alert是不会显示的
- 如果你在try catch语句里使用alert，那么console里将不会输出错误信息，你都没办法查看错误的详细原因，以及储出错的位置。

`更优雅的提醒方式`

- console.log() 普通提示消息
- console.error() 错误提示消息
- console.info() 信息提示消息
- console.warn() 警告提示消息


## 1.3 松散耦合
- html文件中尽可能避免写js语句
- 尽量避免在js更改某个css类的属性，而使用更改类的方法
- 不要在css中写js的表达式
- 解耦应用逻辑和事件处理程序

### 1.3.1 将应用逻辑和事件处理程序的解耦
```
//一般事件订阅的写法，以jQuery的写法为栗子
$(document).on('click','#btn-get-users',function(event){
    event.stopPropagation();
    
    //下面的省略号表示执行获取所有用于并显示在页面上的逻辑
    // Bad
    ...
    ...
    ...
    //
});
```
如果增加了需求，当点击另外一个按钮的时候，也要执行获取所有用户并显示在页面上，那么上面省略的代码又要复制一份。如果接口有改动，那么需要在两个不同的地方都要修改。
所以，应该这样。
```
$(document).on('click','#btn-get-users',function(event){
    event.stopPropagation();
    
    //将应用逻辑分离在其他个函数中
    // Good
    App.getUsers();
    App.renderUsers();
});
```
### 1.3.2 松散解耦规则

- 不要将event对象传给其他方法，只传递来自event对象中的某些数据
- 任何事件处理程序都应该只处理事件，然后把处理转交给应用逻辑。

### 1.3.3 将异步请求和数据处理解耦
```
// Bad
ReqApi.tenant.queryUsers({},function(res){
    if(!res.success){
        console.error(res);
        return;
    }
    
    //对数据的处理
    ...
    ...
    ...
});    
```
上面代码对数据的处理直接写死在异步请求里面，如果换了一个请求，但是数据处理方式是一样的，那么又要复制一遍数据处理的代码。最好的方式是将数据处理模块化成为一个函数。
```
// Good
ReqApi.tenant.queryUsers({},function(res){
    if(!res.success){
        console.error(res);
        return;
    }
    
    //对数据的处理
    App.renderUsers(res.data);
}); 
```
**异步请求只处理请求，不处理数据。函数的功能要专一，功能粒度不可分割。**

### 1.3.4 不要将某个变量写死在函数中，尽量使用参数传递进来
如果你需要一个函数去验证输入框是否是空，如下。这种方式就会绑定死了这个只能验证id为test的输入框，换成其他的就不行
```
// bad
function checkInputIsEmpty(){
    var value = $('#test').val();
    if(value){
        return true;
    }
    else{
        return false;
    }
}

// good 
function isEmptyInput(id){
    var value = $('#'+id).val();
    if(value){
        return true;
    }
    else{
        return false;
    }
}
```


## 1.4 编程实践
### 1.4.1 尊总对象所有权
javascript动态性质是的几乎任何东西在任何时间都能更改，这样就很容易覆写了一些默认的方法。导致一些灾难性的后果。`如果你不负责或者维护某个对象，那么你就不能对它进行修改。`

- 不要为实例或原型添加属性
- 不要为实例或者原型添加方法
- 不要重定义存已存在的方法

### 1.4.2 避免全局变量
`避免全局变量的深层原因在于避免作用域污染。`

`作用域就像空气，你时时刻刻不在呼吸，但你往往感觉不到它的存在。一旦它本污染。你就会感到窒息`
```
// Bad 两个全局变量
var name = "wdd";
funtion getName(){
    console.log(name);
}

// Good 一个全局变量
var App = {
    name:"wdd",
    sayName:funtion(){
        console.log(this.name);//如果这个函数当做回调数使用，这个this可能指向window,
    }
};
```
单一的全局变量便是命名空间的概念，例如雅虎的YUI,jQuery的$等。

### 1.4.3 避免与null进行比较
```
funtion sortArray(values){
    // 避免
    if(values != null){
        values.sort(comparator);
    }
}
```
```
function sortArray(values){
    // 推荐
    if(values instanceof Array){
        values.sort(compartor);
    }
}
```
#### 与null进行比较的代码，可以用以下技术进行替换

- 如果值是一个应用类型，使用**instanceof**操作符，检查其构造函数
- 如果值是基本类型，使用**typeof**检查其类型
- 如果是希望对象包含某个特定的方法名，则只用**typeof**操作符确保指定名字的方法存在于对象上。

`代码中与null比较越少，就越容易确定代码的目的，消除不必要的错误。`

### 1.4.4 从代码中分离配置文件
配置数据是一些硬代码(hardcoded)，看下面的栗子
```
function validate(value){
    if(!value){
        alert('Invalid value');
        location.href = '/errors/invalid.php';
    }
}
```
上面代码里有两个配置数据，一个是UI字符串('Invalid value'),另一个是一个Url('/error/invalid.php')。如果你把他们写死在代码里，那么如果当你需要修改这些地方的时候，那么你必须一处一处的检查并修改，而且还可能会遗漏。

#### 所以第一步是要区分，哪些代码应该写成配置文件的形式？

- 显示在UI元素中的字符串
- URL
- 一些重复的唯一值
- 一些设置变量
- 任何可能改变的值 

#### 一些例子
```
var Config = {
    "MSG_INVALID_VALUE":"Invalid value",
    "URL_INVALID":"/errors/invalid.php"
}
```

### 1.4.5 调试信息开关
在开发过程中，可能随处留下几个**console.log**,或者**alert**语句，这些语句在开发过程中是很有价值的。但是项目一旦进入生产环境，过多的console.log可能影响到浏览器的运行效率，过多的alert会降低程序的用户体验。而我们最好不要在进入生产环境前，一处一处像扫雷一样删除或者注释掉这些调试语句。

`最好的方式是设置一个开关。`
```
//全局命令空间
var App = {
    debug:true,
    log:function(msg){
        if(debug){
            console.log(msg);
        }
    },
    alert:function(msg){
        if(debug){
            alert(msg);
        }
    }
};

//使用
App.log('获取用户信息成功');
App.alert('密码不匹配');

//关闭日志输出与alert
App.debug = false;
```

### 1.4.6 使用jQuery Promise
没使用promise之前的回调函数写法
```
// bad：没使用promise之前的回调函数写法
function sendRequest(req,successCallback,errorCallback){
    var inputData = req.data || {};
    inputData = JSON.stringify(inputData);
    $.ajax({
        url:req.base+req.destination,
        type:req.type || "get",
        headers:{
            sessionId:session.id
        },
        data:inputData,
        dataType:"json",
        contentType : 'application/json; charset=UTF-8',
        success:function(data){
            successCallback(data);
        },
        error:function(data){
            console.error(data);
            errorCallback(data);
        }
    });
}

//调用
sendRequest(req,function(res){
    ...
},function(res){
    ...
});
```
使用promise之后
```
function sendRequest(req){
    var dfd = $.Deferred();
    var inputData = req.data || {};
    inputData = JSON.stringify(inputData);
    $.ajax({
        url:req.base+req.destination,
        type:req.type || "get",
        headers:{
            sessionId:session.id
        },
        data:inputData,
        dataType:"json",
        contentType : 'application/json; charset=UTF-8',
        success:function(data){
            dfd.resolve(data);
        },
        error:function(data){
            dfd.reject(data);
        }
    });
    
    return dfd.promise();
}

//调用
sendRequest(req)
.done(function(){
    //请求成功
    ...
})
.fail(function(){
    //请求失败
    ...
});
```

### 1.4.7 显示错误提醒，不要给后端接口背锅

假如前端要去接口获取用户信息并显示出来，如果你的请求格式是正确的，但是接口返回400以上的错误，你必须通过提醒来告知测试，这个错误是接口的返回错误，而不是前端的逻辑错误。

### 1.4.8 REST化接口请求
> 对资源的操作包括获取、创建、修改和删除资源，这些操作正好对应HTTP协议提供的GET、POST、PUT和DELETE方法。

`对应方式`

请求类型 | 接口前缀
--- | ---
GET | .get,
POST | .create 或者 .get
PUT | .update
DELETE | .delete

`说明`

- 有些接口虽然是获取某一个资源，但是它使用的却是POST请求，所以建议使用.get比较好

示例：
```
// 与用户相关的接口
App.api.user = {};

// 获取一个用户: 一般来说是一个指定的Id，例如userId
App.api.user.getUser = function(){
    ...
};

// 获取一组用户: 一般来说是一些条件，获取条件下的用户，筛选符合条件的用户
App.api.user.getUsers = function(){
    ...
};

// 创建一个用户
App.api.user.createUser = function(){
    
};

// 创建一组用户
App.api.user.createUsers = function(){
    
};

// 更新一个用户
App.api.user.updateUser = function(){
    
};

// 更新一组用户
App.api.user.updateUsers = function(){
    
};

// 更新一个用户
App.api.user.updateUser = function(){
    
};

// 更新一组用户
App.api.user.updateUsers = function(){
    
};

// 删除一个用户
App.api.user.deleteUser = function(){
    
};

// 删除一组用户
App.api.user.deleteUsers = function(){
    
};
```


# 2 性能

## 2.1 注意作用域
- 避免全局查找
- 避免with语句

## 2.2 选择正确的方法
- 优化循环
    - `减值迭代`：从最大值开始，在循环中不断减值的迭代器更加高效
    - `简化终止条件`：由于每次循环过程都会计算终止条件，所以必须保证它尽可能快。也就是避免其他属性查找
    - `简化循环体`：由于循环体是执行最多的，所以要确保其最大限度地优化。
- 展开循环
- 避免双重解释：
```
// **Bad** 某些代码求值
eval("alert('hello')");

// **Bad** 创建新函数
var sayHi = new Function("alert('hello')");

// **Bad** 设置超时
setTimeout("alert('hello')");
```
- 性能的其他注意事项
    - 原生方法较快
    - switch语句较快：可以适当的替换ifelse语句`case 的分支不要超过128条`
    - 位运算符较快

## 2.3 最小化语句数
### 多个变量声明(`废弃`)
```
// 方式1：Bad
var count = 5;
var name = 'wdd';
var sex = 'male';
var age = 10;

// 方式2：Good
var count = 5,
    name = 'wdd',
    sex = 'male',
    age = 10;
```
`2017-03-07 理论上方式2可能要比方式1性能高一点。但是我在实际使用中，这个快一点几乎是没什么感受的。就像你无法感受到小草的生长一样。反而可读性更为重要。所以，每行最好只定义一个变量，并且每行都有一个var,并用分号结尾。`


### 插入迭代值
```
// Good
var name = values[i++];
```

### 使用数组和对象字面量
```
// Good
var values = ['a','b','c'];

var person = {
    name:'wdd',
    age:10
};
```
`只要有可能，尽量使用数组和对象字面量的表达式来消除不必要的语句`


## 2.4 优化DOM交互
> 在JavaScript各个方面中，DOM无疑是最慢的一部分。DOM操作与交互要消耗大量的时间。因为他们往往需要重新渲染整个页面或者某一部分。进一步说，看似细微的操作也可能花很久来执行。因为DOM要处理非常多的信息。理解如何优化与DOM的交互可以极大的提高脚本完成的速度。

- 使用dom缓存技术
- 最小化现场更新
- 使用innerHTML插入大段html
- 使用事件代理

### 2.4.1 Dom缓存技术
调用频率非常高的dom查找，可以将DOM缓存在于一个变量中
```
// 最简单的dom缓存

var domCache = {};

function myGetElement(tag){
    return domCache[tag] = domCache[tag] || $(tag);
}
```

## 2.5 避免过长的属性查找，设置一个快捷方式
```
// 先看下面的极端情况
app.user.mother.parent.home.name = 'wdd'
app.user.mother.parent.home.adderess = '上海'
app.user.mother.parent.home.weather = '晴天'

// 更优雅的方式
var home = app.user.mother.parent.home;
home.name = 'wdd';
home.address = '上海',
home.weather = '晴天'
```

`注意`
使用上面的方式是有前提的，必须保证app.user.mather.parent.home是一个对象，因为对象是传递的引用。如果他的类型是一个基本类型，例如：number,string,boolean，那么复制操作仅仅是值传递，新定义的home的改变，并不会影响到app.user.mather.parent.home的改变。

# 3 快捷方式
## 3.1 字符串转数字
```
+'4.1' === 4.1
```

## 3.2 数字转字符
```
4.1+'' === '4.1'
```

## 3.3 字符串取整
```
'4.99' | 0 === 4
```


# 4 推荐深度阅读
## 4.1 关于技术
- [《编写可读代码的艺术》][1]
- [《编写可维护的JavaScript》][2]
- [《JavaScript忍者秘籍》][3]
- [《JavaScript: The Good Parts》][4]
- [Writing Fast, Memory-Efficient JavaScript][5]
- [JavaScript 秘密花园][6]
- [You-Dont-Know-JS][7]
- [《HTTP权威指南》][8]
- [Caching Tutorial for Web Authors and Webmasters][9]

## 4.2 技术之外
- [《筑巢引凤-高黏度社会化网站设计秘诀》][10]
- [《黑客与画家》][11]
- [《大秦帝国》][12]

# 参考文献
- JavaScript高级程序设计(第3版) 【美】尼古拉斯·泽卡斯
- Maintainable JavaScript (英文版) Nicholas C. Zakas(其实和上边那本书应该是同一个人)
- JavaScript忍者秘籍 John Resig / Bear Bibeault （John Resig 大名鼎鼎jQuery的创造者）
- [百度前端研发部 文档与源码编写风格][13]


  [1]: https://book.douban.com/subject/10797189/
  [2]: https://book.douban.com/subject/21792530/
  [3]: https://book.douban.com/subject/26638316/
  [4]: https://book.douban.com/subject/2994925/
  [5]: https://www.smashingmagazine.com/2012/11/writing-fast-memory-efficient-javascript/
  [6]: http://bonsaiden.github.io/JavaScript-Garden/zh/
  [7]: https://github.com/getify/You-Dont-Know-JS
  [8]: https://book.douban.com/subject/10746113/
  [9]: https://www.mnot.net/cache_docs/
  [10]: https://book.douban.com/subject/5290566/
  [11]: https://book.douban.com/subject/6021440/
  [12]: https://book.douban.com/subject/10539901/
  [13]: https://github.com/fex-team/styleguide