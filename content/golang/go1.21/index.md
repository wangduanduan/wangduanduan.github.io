---
title: "Go1.21发布"
date: "2023-08-10 11:20:47"
draft: false
type: posts
tags:
- all
categories:
- golang
---

golang每隔6个月发布一个新的次版本号升级。一般是是2月一个版本，8月一个版本

# 语言层面
## 增加内置函数
### min() max() 
> 参考 https://tip.golang.org/ref/spec#Min_and_max


The built-in functions min and max compute the smallest—or largest, respectively—value of a fixed number of arguments of ordered types. There must be at least one argument.

The same type rules as for operators apply: for ordered arguments x and y, min(x, y) is valid if x + y is valid, and the type of min(x, y) is the type of x + y (and similarly for max). If all arguments are constant, the result is constant.

```go
var x, y int
m := min(x)                 // m == x
m := min(x, y)              // m is the smaller of x and y
m := max(x, y, 10)          // m is the larger of x and y but at least 10
c := max(1, 2.0, 10)        // c == 10.0 (floating-point kind)
f := max(0, float32(x))     // type of f is float32
var s []string
_ = min(s...)               // invalid: slice arguments are not permitted
t := max("", "foo", "bar")  // t == "foo" (string kind)
```

For numeric arguments, assuming all NaNs are equal, min and max are commutative and associative:

```go
min(x, y)    == min(y, x)
min(x, y, z) == min(min(x, y), z) == min(x, min(y, z))
```

For floating-point arguments negative zero, NaN, and infinity the following rules apply:

```go
   x        y    min(x, y)    max(x, y)

  -0.0    0.0         -0.0          0.0    // negative zero is smaller than (non-negative) zero
  -Inf      y         -Inf            y    // negative infinity is smaller than any other number
  +Inf      y            y         +Inf    // positive infinity is larger than any other number
   NaN      y          NaN          NaN    // if any argument is a NaN, the result is a NaN
```

For string arguments the result for min is the first argument with the smallest (or for max, largest) value, compared lexically byte-wise:

```go
min(x, y)    == if x <= y then x else y
min(x, y, z) == min(min(x, y), z)
```

### clear() 
> https://tip.golang.org/ref/spec#Clear

The built-in function clear takes an argument of map, slice, or type parameter type, and deletes or zeroes out all elements.

```go
Call        Argument type     Result

clear(m)    map[K]T           deletes all entries, resulting in an
                              empty map (len(m) == 0)

clear(s)    []T               sets all elements up to the length of
                              s to the zero value of T

clear(t)    type parameter    see below
```

If the type of the argument to clear is a type parameter, all types in its type set must be maps or slices, and clear performs the operation corresponding to the actual type argument.

If the map or slice is nil, clear is a no-op.


# 参考
- https://go.dev/doc/go1.21#