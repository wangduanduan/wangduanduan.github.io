---
title: Hexo NexT主题设置封面的方法
date: 2018-02-08 21:09:50
tags:
- hexo
---

![](https://wdd.js.org/img/images/20180208212257_BZZjA5_1200px-The_Great_Wave_off_Kanagawa.jpeg)

默认情况下NexT主题的首页，每篇文章几乎都会全部渲染出来。这是这样来看，首页就会变得非常长，不利于快速浏览。

而我希望首页可以尽量缩短，每个文章只需要稍微一点介绍，如果有图片，就设置一张封面就好了。

下面是具体的设置步骤

<!-- more -->

# 1. Next主题设置摘要

filename: themes/next/_config.yml，将auto_excerpt.enable设置成true，length属性表示摘要的字数限制。
```
auto_excerpt:
  enable: true
  length: 150
```


# 2. 文章具体设置

在 `<!-- more -->`上面放一张图片就可以了

```
---
title: Hexo NexT主题设置封面的方法
date: 2018-02-08 21:09:50
tags:
- hexo
---

![](https://wdd.js.org/img/images/20180208212257_BZZjA5_1200px-The_Great_Wave_off_Kanagawa.jpeg)

文章摘要

<!-- more -->

文章正文
```