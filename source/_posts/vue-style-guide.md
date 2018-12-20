---
title: v-for Vue风格指南
date: 2018-12-19 09:29:30
tags:
- Vue
---


# 1. v-for设置key值

**key的值应当是遍历元素的某个唯一属性，例如 item.id，而不是遍历的序号index。直接把key的值绑定为index, 可能会引起不必要的bug**

```html
// good
<ul>
  <li v-for="(item,index) in list" :key="item.id">
    {{ todo.text }}
  </li>
</ul>

// very bad
<ul>
  <li v-for="(item,index) in list" :key="index">
    {{ todo.text }}
  </li>
</ul>
```

**如果要遍历的对象没有一个唯一的id, 非常建议给要遍历的元素加上唯一的id**。推荐使用[nanoid](https://github.com/ai/nanoid)

```js
import nanoid from 'nanoid'

...
someAjax()
.then((res)=>{
  res.users.forEach((item)=>{
    item.id = nanoid()
  })
  this.users = res.users
})
.catch((err)=>{
  console.error(err)
})
...
```

# 2. v-for元素一定要是对象

**除非是最简单的渲染，如果要在渲染期间改变某个元素值，那么只能将简单元素构造为对象。**

```jsx
// very bad
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: ['a', 'b', 'c']
  }
})

<div id="example-1">
  <input v-for="item in items" v-model="item">
</div>
```

```js
// good
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [{id:1, value:'a'}, {id: 2, value:'b'}, {id:3, value:'c'}]
  }
})

<div id="example-1">
  <input v-for="item in items" :key="item.id" v-model="item.value">
</div>
```


# 3. v-for不要和v-if一起使用

**一般情况下，列表中的元素需要按照某些条件进行显示或者隐藏，那么建议使用计算属性。**

好处：

- `渲染效率更高`
- `解藕渲染层的逻辑，可维护性更强`

```jsx
// very bad
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [
      {id:1, value:'a', show: true}, 
      {id:2, value:'b', show: false}, 
      {id:3, value:'c', show: false}
    ]
  }
})

<div id="example-1">
  <input v-for="item in items" v-if="item.show" :key="item.id" v-model="item.value">
</div>
```

```jsx
// very good
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [
      {id:1, value:'a', show: true}, 
      {id:2, value:'b', show: false}, 
      {id:3, value:'c', show: false}
    ]
  },
  computed: {
    itemsShow: function(){
      return this.items.filter(function(item){
        return item.show
      })
    }
  }
})

<div id="example-1">
  <input v-for="item in itemsShow" v-if="item.show" :key="item.id" v-model="item.value">
</div>
```