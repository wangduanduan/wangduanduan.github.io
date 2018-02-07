---
title: 15行代码为segmentfault增加头条文章排序功能
date: 2018-02-07 14:00:46
tags:
---

有个需求，想看点赞最多的头条，但是页面没有这种按钮。怎么办？自己写吧。

先看效果
![](http://p3alsaatj.bkt.clouddn.com/20180207140139_xwjt2M_Screenshot.jpeg)

再看代码
```
var rows = $('.news__item').each(function(){
    var key = +$(this).find('.news__item-zan-number').text();
    $(this).data('key', key);
}).get();

rows.sort(function(a,b){
    var keyA = $(a).data('key');
    var keyB = $(b).data('key');
    if(keyA<keyB){return -1;}
    else{return 1;}
});

$.each(rows, function(index, row){
    $('.news__list').prepend(row);
});
```

  [1]: /img/bVJevF