---
title: "什么时候应该使用ts范型?"
date: "2023-12-28 20:21:11"
draft: false
type: posts
tags:
- typescript
categories:
- all
---

我知道ts支持范型，但是因为几乎用不到，所以对于范型对我来说往往蒙上一层神秘色彩。

最近我才真正的体会到范型的真正威力。

下面就介绍我的使用场景。

在和后端接口交互的时候， 后端接口返回的数据都是如下的类型。

```ts
interface XData {
    success: boolean
    total: number
    result: any[]
}
```

这里我把result定义为any类型，因为它的具体类型是由接口确定的。 比如查话单的接口是话单的结构类型，查订单的接口返回的是订单的类型。

```ts
interface CDR {
    id: number
    creatAt: string
}

interface Order {
    id: number
}
```

在不用范型的时候，我们要么定义如下两个interface

```ts
interface XDataCDR {
    success: boolean
    total: number
    result: CDR[]
}

interface XDataOrder {
    success: boolean
    total: number
    result: Order[]
}
```

在使用axios的时候，对于响应体的data, 可以使用如下的方式声明data

```ts
function getCDR (id) {
    return axios.get<XDataCDR>('/api/xxx' + id)
}
```

但是，如果我们稍微修改一下XData的类型声明，加上范型。 就不需要用到XDataCDR和XDataOrder两个接口。

```ts
interface XData<T> {
    success: boolean
    total: number
    result: T[]
}

function getCDR (id) {
    return axios.get<XData<CDR>>('/api/xxx' + id)
}
```

只需要用到`XData<CDR>`就可以构造出新的类型。

从上面可以看出范型实际上不是约束具体的值的，而是用来对类型进行约束。使用范型，可以减少大量重复的代码。

范型一般用于关键词之后，例如interface名之后，函数名之后。

例如：

```ts
interface X<T> {
    a: T
}

function say<T>() : T[] {
}
```

所以，有些功能，直到真正用到，才能真正理解。