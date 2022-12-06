---
title: "Type 'Timeout' is not assignable to type 'number'"
date: "2020-05-12 15:35:54"
draft: false
---

```javascript
let timer:NodeJS.Timer;
timer = global.setTimeout(myFunction, 1000);
```


参考<br />[http://evanshortiss.com/development/nodejs/typescript/2016/11/16/timers-in-typescript.html](http://evanshortiss.com/development/nodejs/typescript/2016/11/16/timers-in-typescript.html)

