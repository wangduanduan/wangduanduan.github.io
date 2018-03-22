---
title: IE11 0x2ee4 bug 以及类似问题解决方法
date: 2018-02-11 14:12:19
tags:
- IE11
- 0x2ee4
- ajax
---

`一千个IE浏览器访问同一个页面，可能报一千种错误`。前端激进派对IE恨得牙痒痒，但是无论你爱，或者不爱，IE就在那里，不来不去。

一些银行，以及政府部门，往往都是指定必须使用IE浏览器。所以，一些仅在IE浏览器上出现的问题。总结起来问题的原因很简单：`IE的配置不正确`

下面就将一个我曾经遇到的问题: `IE11 0x2ee4`， 以及其他的问题的解决方案

# 1. IE11 SCRIPT7002: XMLHttpRequest: 网络错误 0x2ee4

> 背景介绍：在一个HTTPS域向另外一个HTTPS域发送跨域POTST请求时

这个问题在浏览器的输出内容如下，怪异的是，并不是所有IE11都会报这个错误。

```
SCRIPT7002: XMLHttpRequest: 网络错误 0x2ee4, 由于出现错误 00002ee4 而导致此项操作无法完成
```

stackoverflow上有个答案，它的思路是：`在post请求发送之前，先进行一次get操作` 这个方式我试过，是可行的。但是深层次的原因我不是很明白。


![](http://p3alsaatj.bkt.clouddn.com/20180211141321_kcU1Mh_Screenshot.jpeg)


然而真相总有大白的一天，其实深层次的原因是，IE11的配置。

去掉检查证书吊销的的检查，解决0x2ee4的问题

`解决方法`
- 去掉check for server certificate revocation*， 也有可能你那边是中文翻译的：叫检查服务器证书是否已吊销
- 去掉检查发型商证书是否已吊销
- 点击确定
- 重启计算机

![](http://p3alsaatj.bkt.clouddn.com/20180211141332_EzU6Hs_Screenshot.jpeg)

# 2 其他常规设置

## 2.1 去掉兼容模式， 使用Edge文档模式

![](http://p3alsaatj.bkt.clouddn.com/20180211141344_ctLchE_Screenshot.jpeg)

下图中红色框里的按钮也要取消勾选
![](http://p3alsaatj.bkt.clouddn.com/20180211141353_182pMj_Screenshot.jpeg)

## 2.2 有些使用activeX，还是需要检查是否启用的
![](http://p3alsaatj.bkt.clouddn.com/20180211141403_eM2ajd_Screenshot.jpeg)
![](http://p3alsaatj.bkt.clouddn.com/20180211141414_8gyYUu_Screenshot.jpeg)
![](http://p3alsaatj.bkt.clouddn.com/20180211141427_CeMrwH_Screenshot.jpeg)

## 2.3 允许跨域
如果你的接口跨域了，还要检查浏览器是否允许跨域，否则浏览器可能默认就禁止跨域的

设置方法 
1. internet选项 
2. 安全 
3. 自定义级别 
4. `启用通过跨域访问数据源`
5. `启用跨域浏览窗口和框架`
5. 确定 
6. 然后`重启电脑`

![](http://p3alsaatj.bkt.clouddn.com/20180211141443_fV3amH_Screenshot.jpeg)


![](http://p3alsaatj.bkt.clouddn.com/20180322150920_oVhst9_Jietu20180322-150855.jpeg)