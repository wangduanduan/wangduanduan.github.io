---
title:  代码整洁之道 - 有意义的命名
date: 2018-02-08 09:17:54
tags:
---

> 在小朱元璋出生一个月后，父母为他取了一个名字（元时惯例）：朱重八，这个名字也可以叫做朱八八。我们这里再介绍一下，朱重八家族的名字，都很有特点。
>朱重八高祖名字：朱百六；
>朱重八曾祖名字：朱四九；
>朱重八祖父名字：朱初一；
>他的父亲我们介绍过了，叫朱五四。
>取这样的名字不是因为朱家是搞数学的，而是因为在元朝，老百姓如果不能上学和当官就没有名字，只能以父母年龄相加或者出生的日期命名。（登记户口的人一定会眼花）--《明朝那些事儿》

那么问题来了，朱四九和朱百六是什么关系？ 你可能马上懵逼了。所以说：`命名不仅仅是一种科学，更是一种艺术`。

# 1. 名副其实
```
// bad
var d; // 分手的时间，以天计算

// good
var daysAfterBrokeUp; // 分手以后，以天计算
```

# 2. 避免误导
```
// bad
var nameList = 'wdd'; // List一般暗指数据是数组，而不应该赋值给字符串

// good
var nameList = ['wdd','ddw','dwd']; // 

// bad
var ill10o = 10; //千万不要把i,1,l,0,o,O放在一起，傻傻分不清楚

// good
var illOne = 10;
```

# 3. 做有意义的区分
```
// bad
var userData, userInfo; // Data和Info, 有什么区别？？？？, 不要再用data和info这样模糊不清的单词了

// good
var userProfile, userAcount
```

# 4. 使用读得出来的名称
```
// bad 
var beeceearrthrtee; // 你知道怎么读吗？ 鼻涕阿三？？

// good
var userName;
```

# 5. 使用可搜索的名称
```
// bad
var e = 'not found'; // 想搜e, 就很难搜

// good
var ERROR_NO_FOUND = 'not found';
```

# 6. 方法名一概是动词短语
```
// good
function createAgent(){}
funtion deleteAgent(){}
function updateAgent(){}
function queryAgent(){}
```

# 7. 尽量不要用单字母名称, 除了用于循环
```
// bad
var i = 1;

// good
for(var i=0; i<10; i++){
    ...
}

// very good
userList.forEach(function(user){
    ...
});
```

# 8. 每个概念对应一个词
```
controller和manager, 没什么区别，要用controller都用controller, 要用manager都用manager, 不要混着用
```

# 9. 建立项目词汇表, 不要随意创造名称
```
user, agent, org, queue, activity, device...
```

# 10. 参考资料
- 《代码整洁之道》
- 《明朝那些事儿》











