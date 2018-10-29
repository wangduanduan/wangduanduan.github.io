---
title: Node.js 如何找出循环依赖的文件？如何解决循环依赖问题？
date: 2018-10-29 09:21:03
tags:
---


本文重点是讲解`如何解决循环依赖这个问题`。关心这个问题是如何产生的，可以自行谷歌。

# 如何重现这个问题

```
// a.js
const {sayB} = require('./b.js')

sayB()

function sayA () {
  console.log('say A')
}

module.exports = {
  sayA
}
```

```
// b.js
const {sayA} = require('./a.js')

sayA()

function sayB () {
  console.log('say B')
}

module.exports = {
  sayB
}
```

执行下面的代码

```
➜  test git:(master) ✗ node a.js
/Users/dd/wj-gitlab/tools/test/b.js:3
sayA()
^

TypeError: sayA is not a function
    at Object.<anonymous> (/Users/dd/wj-gitlab/tools/test/b.js:3:1)
    at Module._compile (module.js:635:30)
    at Object.Module._extensions..js (module.js:646:10)
    at Module.load (module.js:554:32)
    at tryModuleLoad (module.js:497:12)
    at Function.Module._load (module.js:489:3)
    at Module.require (module.js:579:17)
    at require (internal/module.js:11:18)
    at Object.<anonymous> (/Users/dd/wj-gitlab/tools/test/a.js:1:78)
    at Module._compile (module.js:635:30)
```

`sayA is not a function`那么sayA是个什么呢，实际上它是 `undefined`

`遇到这种问题时，你最好能意识到可能是循环依赖的问题`，否则找问题可能事倍功半。

# 如何找到循环依赖的的文件

上文的示例代码很简单，2个文件，很容易找出循环依赖。`如果有十几个文件，手工去找循环依赖的文件，也是非常麻烦的。`

下面推荐一个工具 [madge](https://github.com/pahen/madge), 它可以可视化的查看文件之间的依赖关系。


注意下图1，以cli.js为起点，所有的箭头都是向右展开的，这说明没有循环依赖。`如果有箭头出现向左逆流，那么就可能是循环依赖的点。`

图2中，出现向左的箭头，说明出现了循环依赖，说明要此处断开循环。

![](http://p3alsaatj.bkt.clouddn.com/20181029092439_iAPS8M_bVbiGlF.jpeg)
【图1】
![](http://p3alsaatj.bkt.clouddn.com/20181029092450_uwYCic_bVbiGmj.jpeg)
【图2】

# 如何解决循环依赖

## 方案1： 先导出自身模块

将module.exports放到文件头部，先将自身模块导出，然后再导入其他模块。

来自：http://maples7.com/2016/08/17/cyclic-dependencies-in-node-and-its-solution/

```
// a.js
module.exports = {
  sayA
}

const {sayB} = require('./b.js')

sayB()

function sayA () {
  console.log('say A')
}
```

```
// b.js
module.exports = {
  sayB
}

const {sayA} = require('./a.js')

console.log(typeof sayA)

sayA()

function sayB () {
  console.log('say A')
}
```

## 方案2： 间接调用

通过引入一个event的消息传递，让多个个模块可以间接传递消息，多个模块之间也可以通过发消息相互调用。

```
// a.js
require('./b.js')
const bus = require('./bus.js')

bus.on('sayA', sayA)

setTimeout(() => {
  bus.emit('sayB')
}, 0)

function sayA () {
  console.log('say A')
}

module.exports = {
  sayA
}
```

```
// b.js
const bus = require('./bus.js')

bus.on('sayB', sayB)

setTimeout(() => {
  bus.emit('sayA')
}, 0)

function sayB () {
  console.log('say B')
}

module.exports = {
  sayB
}
```

```
// bus.js
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

module.exports = new MyEmitter()

```


# 总结

出现循环依赖，往往是代码的结构出现了问题。应当主动去避免循环依赖这种问题，但是遇到这种问题，无法避免时，也要意识到是循环依赖导致的问题，并找方案解决。

最后给出一个有意思的问题，下面的代码运行`node a.js`会输出什么？为什么会这样？

```
// a.js

var moduleB = require('./b.js')

setInterval(() => {
  console.log('setInterval A')
}, 500)

setTimeout(() => {
  console.log('setTimeout moduleA')
  moduleB.sayB()
}, 2000)

function sayA () {
  console.log('say A')
}

module.exports = {
  sayA
}

```

```
// b.js
var moduleA = require('./a.js')

setInterval(() => {
  console.log('setInterval B')
}, 500)

setTimeout(() => {
  console.log('setTimeout moduleB')
  moduleA.sayA()
}, 2000)

function sayB () {
  console.log('say B')
}

module.exports = {
  sayB
}

```




  [1]: /img/bVbiGlF
  [2]: /img/bVbiGmj