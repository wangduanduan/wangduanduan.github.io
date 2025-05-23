---
title: "Vite React Route URL含有.时，路径无法正常匹配"
date: "2023-11-09 20:49:44"
draft: false
type: posts
tags:
- vite
- route
- react-route
- 404
categories:
- react
---

今天遇到一个奇怪的问题，react-router的路径匹配无法正常工作，反而向vite的dev server发送了GET请求，这个请求报错404。页面直接无法访问。

按理说这种前端路由的框架应该不需要向后段发送请求的。

后来我怀疑是不是代理的问题，但是只是部分页面无法访问，所以排出这个选项。

随后我的系统又收到一条测试数据，这条测试数据却能够正常跳转。

我仔细的对别了两个不同的url，发现有问题的那个url包含了一个英文字符`.`,  所以我怀疑是react-router的路径匹配有问题。

```
/call/2023-11-09/nlLBs32pp.2oXhnY6xzmYBCnjhYUkc7Z
/call/2023-11-09/fYqZKTGHBFVCz4iC5irulFc83giH9bsa	
```

我的第一反应是react-router对于动态的路径，是有字符要求的。翻阅官方文档后，没有发现类似的描述。

然后我在react-router的issue列表上查找有没有人提出类似的问题，发现了 [[Bug]: paths with dynamic parameters do not work correctly when there is a dot in the url](https://github.com/remix-run/react-router/issues/8389), 

紧接着有人分析，说这个问题并不是react-router上的，而是出在vite上。 vite的项目上也有对应的issue反应这个问题。

# 解决方案

- 方案1: 升级vite 到5.x， 由于当前稳定的还是4.x的vite, 所以这个方案改动太大，放弃
- 方案2: 在匹配路径最后加上`/`, 也就是原本的`/a.b`要改成`/a.b/`, 我试了这个方案，是有效的。
- 方案3: 使用这个专门用来解决这个问题的插件， https://github.com/ivesia/vite-plugin-rewrite-all


# 深入分析
路径带有点，一般可能认为是一个静态资源，例如`a.js, b.css`之类的，所以vite会把符合这个模式的路径直接向后段发送请求，去获取静态资源，而不是去匹配一个组件。




# 参考
- https://github.com/remix-run/react-router/issues/8389
- https://github.com/vitejs/vite/issues/2415
- https://github.com/vitejs/vite/issues/11282
- https://github.com/vitejs/vite/issues/2628
- https://github.com/vitejs/vite/pull/2191/files
- https://github.com/bripkens/connect-history-api-fallback