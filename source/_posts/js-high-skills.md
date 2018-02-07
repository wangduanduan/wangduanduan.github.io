---
title:  JavaScript 高级技巧
date: 2018-02-07 10:14:56
tags:
---

## 安全类型检测
- javascript内置类型检测并不可靠
- safari某些版本（<4）typeof正则表达式返回为function

建议使用Object.prototype.toString.call()方法检测数据类型
```

    function isArray(value){
        return Object.prototype.toString.call(value) === "[object Array]";
    }
    
    function isFunction(value){
        return Object.prototype.toString.call(value) === "[object Function]";
    }
    
    function isRegExp(value){
        return Object.prototype.toString.call(value) === "[object RegExp]";
    }
    
    function isNativeJSON(){
        return window.JSON && Object.prototype.toString.call(JSON) === "[object JSON]";
    }

```
`对于ie中一COM对象形式实现的任何函数，isFunction都返回false，因为他们并非原生的javascript函数。`

**在web开发中，能够区分原生与非原生的对象非常重要。只有这样才能确切知道某个对象是否有哪些功能**

以上所有的正确性的前提是：Object.prototype.toString没有被修改过


## 作用域安全的构造函数
```
function Person(name){
    this.name = name;
}

//使用new来创建一个对象
var one = new Person('wdd');

//直接调用构造函数
Person();
```
由于this是运行时分配的，如果你使用new来操作，this指向的就是one。如果直接调用构造函数，那么this会指向全局对象window,然后你的代码就会覆盖window的原生name。如果有其他地方使用过window.name, 那么你的函数将会埋下一个深藏的bug。

==那么，如何才能创建一个作用域安全的构造函数？==
方法1
```
function Person(name){
    if(this instanceof Person){
        this.name = name;
    }
    else{
        return new Person(name);
    }
}
```

# 惰性载入函数
假设有一个方法X，在A类浏览器里叫A,在b类浏览器里叫B,有些浏览器并没有这个方法,你想实现一个跨浏览器的方法。

惰性载入函数的思想是：`在函数内部改变函数自身的执行逻辑`

```
function X(){
    if(A){
        return new A();
    }
    else{
        if(B){
            return new B();
        }
        else{
            throw new Error('no A or B');
        }
    }
}
```
换一种写法
```
function X(){
    if(A){
        X = function(){
            return new A();
        };
    }
    else{
        if(B){
            X = function(){
                return new B();
            };
        }
        else{
            throw new Error('no A or B');
        }
    }
    
    return new X();
}
```

# 防篡改对象
## 不可扩展对象 Object.preventExtensions
```
// 下面代码在谷歌浏览器中执行
> var person = {name: 'wdd'};
undefined
> Object.preventExtensions(person);
Object {name: "wdd"}
> person.age = 10
10
> person
Object {name: "wdd"}
> Object.isExtensible(person)
false
```

## 密封对象Object.seal
密封对象不可扩展，并且不能删除对象的属性或者方法。但是属性值可以修改。
```
> var one = {name: 'hihi'}
undefined
> Object.seal(one)
Object {name: "hihi"}
> one.age = 12
12
> one
Object {name: "hihi"}
> delete one.name
false
> one
Object {name: "hihi"}
```

## 冻结对象 Object.freeze
最严格的防篡改就是冻结对象。对象不可扩展，而且密封，不能修改。只能访问。

# 高级定时器
## 函数节流
函数节流的思想是：`某些代码不可以没有间断的连续重复执行`
```
var processor = {
	timeoutId: null,

	// 实际进行处理的方法
	performProcessing: function(){
		...
	},

	// 初始化调用方法
	process: function(){
		clearTimeout(this.timeoutId);

		var that = this;

		this.timeoutId = setTimeout(function(){
			that.performProcessing();
		}, 100);
	}
}

// 尝试开始执行
processor.process();
```

## 中央定时器
页面如果有十个区域要动态显示当前时间，一般来说，可以用10个定时来实现。其实一个中央定时器就可以搞定。


中央定时器动画 demo地址：http://wangduanduan.coding.me/my-all-demos/ninja/center-time-control.html

```
var timers = {
		timerId: 0,
		timers: [],
		add: function(fn){
			this.timers.push(fn);
		},
		start: function(){
			if(this.timerId){
				return;
			}

			(function runNext(){
				if(timers.timers.length > 0){
					for(var i=0; i < timers.timers.length ; i++){
						if(timers.timers[i]() === false){
							timers.timers.splice(i, 1);
							i--;
						}
					}

					timers.timerId = setTimeout(runNext, 16);
				}
			})();
		},
		stop: function(){
			clearTimeout(timers.timerId);
			this.timerId = 0;
		}
	};
```


参考书籍：
《javascript高级程序设计》
《javascript忍者秘籍》
