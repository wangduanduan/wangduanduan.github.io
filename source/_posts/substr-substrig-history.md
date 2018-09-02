---
title: 追本溯源 substr与substring历史漫话
date: 2018-02-11 14:42:16
tags:
- substr
- substring
---

> 引子： 很多时候，当我要字符串截取时，我会想到substr和substring的方法，但是具体要怎么传参数时，我总是记不住。哪个应该传个字符串长度，哪个又应该传个开始和结尾的下标，如果我不去查查这两个函数，我始终不敢去使用它们。所以我总是觉得，这个两个方法名起的真是蹩脚。然而事实是这样的吗？

`看来是时候扒一扒这两个方法的历史了。`

# 1 基因追本溯源
![](https://wdd.js.org/img/images/20180211144257_1GqbRg_Screenshot.jpeg)

在编程语言的历史长河中，曾经出现过很多编程语言。然而大浪淘沙，铅华洗尽之后，很多早已折戟沉沙，有些却依旧光彩夺目。那么stubstr与substring的DNA究竟来自何处？

![](https://wdd.js.org/img/images/20180211144314_cxhcdA_Screenshot.jpeg)

> 1950与1960年代

- 1954 - FORTRAN
- 1958 - LISP
- 1959 - COBOL
- 1964 - BASIC
- 1970 - Pascal

> 1967-1978：确立了基础范式

- 1972 - `C语言`
- 1975 - Scheme
- 1978 - SQL (起先只是一种查询语言，扩充之后也具备了程序结构)

> 1980年代：增强、模块、性能

- 1983 - `C++ (就像有类别的C)`
- 1988 - Tcl

> 1990年代：互联网时代

- 1991 - `Python`
- 1991 - Visual Basic
- 1993 - `Ruby`
- 1995 - `Java`
- 1995 - Delphi (Object Pascal)
- 1995 - `JavaScript`
- 1995 - `PHP`
- 2009 - `Go`
- 2014 - `Swift (编程语言)`

## 1.1 在C++中首次出现substr()

![](https://wdd.js.org/img/images/20180211144327_EtfLjV_Screenshot.jpeg)


在c语言中，并没有出现substr或者substring方法。然而在1983，substr()方法已经出现在C++语言中了。然而这时候还没有出现substring, 所以可以见得：`substr是stustring的老大哥`

```
string substr (size_t pos = 0, size_t len = npos) const;
```

从C++的方法定义中可以看到, `substr的参数是开始下标，以及字符串长度。`

```
  std::string str="We think in generalities, but we live in details.";
  std::string str2 = str.substr (3,5);     // "think"
```

## 1.2 在Java中首次出现substring()
![](https://wdd.js.org/img/images/20180211144338_id4nE2_Screenshot.jpeg)


距离substr()方法出现已经有了将近十年之隔，此间涌现一批后起之秀，如: Python, Ruby, VB之类，然而他们之中并没有stustring的基因，在Java的String类中，我们看到两个方法。从这两个方法之中我们可以看到：substring方法基本原型的参数是开始和结束的下标。

```
String substring(int beginIndex) // 返回一个新的字符串，它是此字符串的一个子字符串。

String substring(int beginIndex, int endIndex)
// 返回一个新字符串，它是此字符串的一个子字符串。
```

# 1.3 JavaScript的历史继承
![](http://www.jstips.co/assetshttps://wdd.js.org/img/images/jstips-animation.gif)


>  
1995年，网景公司招募了Brendan Eich，目的是将Scheme编程语言嵌入到Netscape Navigator中。在开始之前，Netscape Communications与Sun Microsystems公司合作，在Netscape Navigator中引入了更多的静态编程语言Java，以便与微软竞争用户采用Web技术和平台。网景公司决定，他们想创建的脚本语言将补充Java，并且应该有一个类似的语法，排除采用Perl，Python，TCL或Scheme等其他语言。为了捍卫对竞争性提案的JavaScript的想法，公司需要一个原型。 1995年5月，Eich在10天内写完。

上帝用七天时间创造万物, Brendan Eich用10天时间创造了一门语言。或许用创造并不合适，因为JavaScript是站在了Perl，Python，TCL或Scheme等其他巨人的肩膀上而产生的。

JavaScript并不像C那样出身名门，在贝尔实验室精心打造，但是JavaScript在往后的`自然选择`中，并没有因此萧条，反而借助于C,C++, Java, Perl，Python，TCL, Scheme优秀基因，进化出更加强大强大的生命力。

因此可以想象，在10天之内，当Brendan Eich写到String的substr和substring方法时，或许他并没困惑着两个方法的参数应该如何设置，`因为在C++和Java的实现中，已经有了类似的定义。` 如果你了解历史，你就不会困惑现在。

# 2 所以，substr和substring究竟有什么不同？

如下图所示：substr和substring都接受两个参数，他们的第一个参数的含义是相同的，`不同的是第二个参数。substr的第二个参数是到达结束点的距离，substring是结束的位置。`

![](https://wdd.js.org/img/images/20180211144352_POhgos_Screenshot.jpeg)


# 3 参考文献
- [维基百科：程式語言歷史](https://zh.wikipedia.org/wiki/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80%E6%AD%B7%E5%8F%B2)
- [C++ std::string::substr](http://www.cplusplus.com/reference/string/string/substr/)
- [JavaScript](https://en.wikipedia.org/wiki/JavaScript)

如有不正确的地方，欢迎指正。




