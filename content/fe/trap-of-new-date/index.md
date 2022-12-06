---
title: "new Date('time string')的陷阱"
date: "2022-10-29 11:44:26"
draft: false
---

一般情况下，建议你不要用new Date("time string")的方式去做时间解析。因为不同浏览器，可能接受的time string的格式都不一样。

你最好不要去先入为主，认为浏览器会支持的你的格式。

常见的格式 2010-10-10 19:00:00 就这种格式，在IE11上是不接受的。

下面的比较，在IE11上返回false, 在chrome上返回true。原因就在于，IE11不支持这种格式。

```js
new Date() > new Date('2010-10-10 19:00:00')
```

所以在时间处理上，最好选用比价靠谱的第三方库，例如dayjs， moment等等。

千万不要先入为主！！