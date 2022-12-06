---
title: "Js 101 Question"
date: "2021-06-02 13:44:00"
draft: false
---

```js
const a = {}

function test1 (a) {
    a = {
      name: 'wdd'
    }
}

function test2 () {
    test1(a)
}

function test3 () {
    console.log(a)
}

test2()
test3()
```