---
title: Small is Powerful Vue mixins
date: 2018-03-30 15:33:58
tags:
- Vue
---

# small is beautiful

```
new Vue({
  el: '#app',
  methods: {
    hello: function(){
      console.log('hello')
    }
  },
  created: function(){
    this.hello()
  }
})
```

# big is ugly

```
new Vue({
  el: '#app',
  methods: {
    hello: function(){
      console.log('hello')
    },
    hello1: function(){
      console.log('hello1')
    },
    hello2: function(){
      console.log('hello2')
    },
    hello3: function(){
      console.log('hello3')
    },
    // a lot of function be added, this is ugly
    helloN: function(){
      console.log('helloN')
    },
  },
  created: function(){
    this.hello()
  }
})
```

# mixins is powerful

```
var mix  = {
  created: function () {
    console.log('i am mixins')
  },
  methods: {
    helloX: function(){
      console.log('helloX')
    }
  }
}

new Vue({
  el: '#app',
  mixins: [mix],
  methods: {
    hello: function(){
      console.log('hello')
    },
    hello1: function(){
      console.log('hello1')
    },
    hello2: function(){
      console.log('hello2')
    },
    hello3: function(){
      console.log('hello3')
    }
  },
  created: function(){
    this.hello()
  }
})
```

# reading more 
- [guide-mixins](https://cn.vuejs.org/v2/guide/mixins.html)
