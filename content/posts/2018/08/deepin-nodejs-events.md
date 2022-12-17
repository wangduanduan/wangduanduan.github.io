---
title: NodeJS Events 模块笔记
date: 2018-08-10 10:18:57
tags:
- node
---

# 1. 环境
- node 8.11.3

# 2. 基本使用

```
// 01.js

const EventEmitter = require('events');

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter();
myEmitter.on('event', () => {
  console.log('an event occurred!');
});
myEmitter.emit('event');
```

输出：
```
an event occurred!
```


# 3. 传参与this指向

- `emit()`方法可以传不限制数量的参数。
- 除了箭头函数外，在回调函数内部，this会被绑定到EventEmitter类的实例上

```
// 02.js
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter()

myEmitter.on('event', function (a, b){
  console.log(a, b, this, this === myEmitter)
})

myEmitter.on('event', (a, b) => {
  console.log(a, b, this, this === myEmitter)
})

myEmitter.emit('event', 'a', {name:'wdd'})
```


输出：
```
a { name: 'wdd' } MyEmitter {
  domain: null,
  _events: { event: [ [Function], [Function] ] },
  _eventsCount: 1,
  _maxListeners: undefined } true
a { name: 'wdd' } {} false
```

# 4. 同步还是异步调用listeners?

- emit()法会`同步`按照事件注册的顺序执行回调

```
// 03.js
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter()

myEmitter.on('event', () => {
  console.log('01 an event occurred!')
})

myEmitter.on('event', () => {
  console.log('02 an event occurred!')
})

console.log(1)
myEmitter.emit('event')
console.log(2)
```

输出：

```
1
01 an event occurred!
02 an event occurred!
2
```

`深入思考，为什么事件回调要同步？异步了会有什么问题？`

同步去调用事件监听者，能够确保按照注册顺序去调用事件监听者，并且避免竞态条件和逻辑错误。

# 5. 如何只订阅一次事件？

- 使用once去只订阅一次事件

```
// 04.js
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}
const myEmitter = new MyEmitter()

let m = 0
myEmitter.once('event', () => {
  console.log(++m)
})
myEmitter.emit('event')
myEmitter.emit('event')

```

# 6. 不订阅，就发飙的错误事件

`error`是一个特别的事件名，当这个事件被触发时，如果没有对应的事件监听者，则会导致程序崩溃。

```
events.js:183
      throw er; // Unhandled 'error' event
      ^

Error: test
    at Object.<anonymous> (/Users/xxx/github/node-note/events/05.js:12:25)
    at Module._compile (module.js:635:30)
    at Object.Module._extensions..js (module.js:646:10)
    at Module.load (module.js:554:32)
    at tryModuleLoad (module.js:497:12)
    at Function.Module._load (module.js:489:3)
    at Function.Module.runMain (module.js:676:10)
    at startup (bootstrap_node.js:187:16)
    at bootstrap_node.js:608:3
```

`所以，最好总是给EventEmitter实例添加一个error的监听器`

```
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter()

myEmitter.on('error', (err) => {
  console.log(err)
})

console.log(1)
myEmitter.emit('error', new Error('test'))
console.log(2)

```

# 7. 内部事件 newListener与removeListener

newListener与removeListener是EventEmitter实例的自带的事件，你最好不要使用同样的名字作为自定义的事件名。

- newListener在订阅者被加入到订阅列表前触发
- removeListener在订阅者被移除订阅列表后触发

```
// 06.js 
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter()

myEmitter.on('newListener', (event, listener) => {
  console.log('----')
  console.log(event)
  console.log(listener)
})

myEmitter.on('myEmitter', (err) => {
  console.log(err)
})
```

输出：

从输出可以看出，即使没有去触发myEmitter事件，on()方法也会触发newListener事件。

```
----
myEmitter
[Function]
```

# 8. 事件监听数量限制

- myEmitter.listenerCount('event'): 用来计算一个实例上某个事件的监听者数量
- EventEmitter.defaultMaxListeners: EventEmitter类默认的最大监听者的数量，默认是10。超过会有警告输出。
- myEmitter.getMaxListeners()： EventEmitter实例默认的某个事件最大监听者的数量，默认是10。超过会有警告输出。
- myEmitter.eventNames()： 返回一个实例上又多少种事件


EventEmitter和EventEmitter实例的最大监听数量为10并不是一个硬性规定，只是一个推荐值，该值可以通过setMaxListeners()接口去改变。

- 改变EventEmitter的最大监听数量会影响到所有EventEmitter实例
- 该变EventEmitter实例的最大监听数量只会影响到实例自身

如无必要，最好的不要去改变默认的监听数量限制。事件监听数量是node检测内存泄露的一个标准一个维度。

EventEmitter实例的最大监听数量不是一个实例的所有监听数量。

例如同一个实例A类型事件5个监听者，B类型事件6个监听者，这个并不会有告警。如果A类型有11个监听者，就会有告警提示。

如果在事件中发现类似的告警提示`Possible EventEmitter memory leak detected`，要知道从事件最大监听数的角度去排查问题。


```
// 07.js
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter()

const maxListeners = 11

for (let i = 0; i < maxListeners; i++) {
  myEmitter.on('event', (err) => {
    console.log(err, 1)
  })
}

myEmitter.on('event1', (err) => {
  console.log(err, 11)
})

console.log(myEmitter.listenerCount('event'))
console.log(EventEmitter.defaultMaxListeners)
console.log(myEmitter.getMaxListeners())
console.log(myEmitter.eventNames())
```

输出：

```
11
10
10
[ 'event', 'event1' ]
(node:23957) MaxListenersExceededWarning: Possible EventEmitter memory leak detected. 11 event listeners added. Use emitter.setMaxListeners() to increase limit
```