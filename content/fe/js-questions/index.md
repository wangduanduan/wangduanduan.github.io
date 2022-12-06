---
title: 'JS 考题'
date: '2022-11-04 08:42:15'
draft: false
---

# 1. 分析输出

```javascript
for (var i = 0; i < 3; i++) {
    setTimeout(() => console.log(i), 1)
}

for (let i = 0; i < 3; i++) {
    setTimeout(() => console.log(i), 1)
}
```

# 2. 分析输出

```javascript
const shape = {
    radius: 10,
    diameter() {
        return this.radius * 2
    },
    perimeter: () => 2 * Math.PI * this.radius,
}

shape.diameter()
shape.perimeter()
```

# 3. 分析输出

```javascript
const a = {}

function test1(a) {
    a = {
        name: 'wdd',
    }
}

function test2() {
    test1(a)
}

function test3() {
    console.log(a)
}

test2()
test3()
```

# 4. 分析输出

```javascript
class Chameleon {
    static colorChange(newColor) {
        this.newColor = newColor
        return this.newColor
    }

    constructor({ newColor = 'green' } = {}) {
        this.newColor = newColor
    }
}

const freddie = new Chameleon({ newColor: 'purple' })
freddie.colorChange('orange')
```

# 5. 分析输出

```javascript
function Person(firstName, lastName) {
    this.firstName = firstName
    this.lastName = lastName
}

const member = new Person('Lydia', 'Hallie')
Person.getFullName = function () {
    return `${this.firstName} ${this.lastName}`
}

console.log(member.getFullName())
```

# 6. 事件传播的三个阶段是什么？

-   A: Target > Capturing > Bubbling
-   B: Bubbling > Target > Capturing
-   C: Target > Bubbling > Capturing
-   D: Capturing > Target > Bubbling

# 7. 所有对象都有原型

A: 对
B: 错

# 8. 输出？

```javascript
function sum(a, b) {
    return a + b
}

sum(1, '2')
```

# 9. 输出？

```javascript
function getPersonInfo(one, two, three) {
    console.log(one)
    console.log(two)
    console.log(three)
}

const person = 'Lydia'
const age = 21

getPersonInfo`${person} is ${age} years old`
```

# 输出？

```javascript
function checkAge(data) {
    if (data === { age: 18 }) {
        console.log('You are an adult!')
    } else if (data == { age: 18 }) {
        console.log('You are still an adult.')
    } else {
        console.log(`Hmm.. You don't have an age I guess`)
    }
}

checkAge({ age: 18 })
```

# 输出？

```javascript
function getAge(...args) {
    console.log(typeof args)
}

getAge(21)
```
