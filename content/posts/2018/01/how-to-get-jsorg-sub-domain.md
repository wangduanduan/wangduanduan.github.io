---
title: 组织在召唤：如何免费获取一个js.org的二级域名
date: 2018-01-29 18:08:03
tags:
- jsorg
- hexo
---

> 之前我是使用wangduanduan.github.io作为我的博客地址，后来觉得麻烦，有把博客关了。最近有想去折腾折腾。
先看效果：[wdd.js.org](https://wdd.js.org)

如果你不了解js.org可以看看我的这篇文章:[一个值得所有前端开发者关注的网站js.org](https://segmentfault.com/a/1190000008342301)

![](https://wdd.js.org/img/images/20180129182103_Avcxhn_Jietu20180129-182047.jpeg)

# 1. 前提
- 已经有了github pages的一个博客，并且博客中有内容，没有内容会审核不通过的。我第一次申请域名，就是因为内容太少而审核不通过。

# 2. 想好自己要什么域名？
比如你想要一个：wdd.js.org的域名，你先在浏览器里访问这个地址，看看有没有人用过，如果已经有人用过，那么你就只能想点其他的域名了。

# 3. fork js.org的项目，添加自己的域名
1 fork https://github.com/js-org/dns.js.org
2 修改你fork后的仓库中的`cnames_active.js`文件，加上自己的一条域名，最好要按照字母顺序

如下图所示，我在第1100行加入。注意，不要在该行后加任何注释。
```
"wdd": "wangduanduan.github.io",
```

![](https://wdd.js.org/img/images/20180129182555_tx71OV_Jietu20180129-182542.jpeg)

3 commit

# 4. 加入CNAME文件
我是用hexo和next主题作为博客的模板。其中我在`gh-pages`分支写博客，然后部署到`master`分支。

我在我的`gh-pages`分支的`source`目录下加入CNAME文件, 内容只有一行

```
wdd.js.org
```

![](https://wdd.js.org/img/images/20180129183216_aPl2ld_Jietu20180129-183209.jpeg)

将博客再次部署好，`如果CNAME生效的话，你已经无法从原来的地址访问：wangduanduan.github.io， 这个博客了。`

# 5. 向js.org项目发起pull-request
找到你fork后的项目，点击 `new pull request`, 向原来的项目发起请求。

![](https://wdd.js.org/img/images/20180129190011_xvkHec_Jietu20180129-185938.jpeg)

然后你可以在`js-org/dns.js.org`项目的pull requests看到你的请求，当这个请求被合并时，你就拥有了js.org的二级域名。

![](https://wdd.js.org/img/images/20180129190308_0cZZwM_Jietu20180129-190255.jpeg)


![](https://wdd.js.org/img/images/20180129190454_9BnL7F_Jietu20180129-190449.jpeg)