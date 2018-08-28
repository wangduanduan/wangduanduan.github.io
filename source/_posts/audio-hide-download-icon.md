---
title: 谷歌浏览器 audio如何隐藏下载按钮
date: 2018-02-08 13:46:45
tags:
---

当我们使用原生的audio标签时，可以看到如下的效果。

![](/images/20180208134739_FKSyw4_Screenshot.jpeg)

`那么如何让下载按钮隐藏掉呢？`

# 1. controlsList="nodownload"

```
// 这个方法只支持 Chrome 58+， 低于该版本的是没有无法隐藏的
<audio src="/i/horse.ogg" controls="controls" controlsList="nodownload">
    Your browser does not support the audio element.
</audio>
```

controlsList属性只兼容Chrome 58+以上，具体可以参考[controlslist.html](https://github.com/googlechrome/samples/blob/gh-pages/media/controlslist.html) ，[controlsList在线例子](https://googlechrome.github.io/samples/media/controlslist.html)
- nodownload: 不要下载
- nofullscreen: 不要全屏
- noremoteplayback: 不要远程回放

# 2. css方式来隐藏
```
// 这个方式兼容所有版本的谷歌浏览器
audio::-webkit-media-controls {
    overflow: hidden !important
}
audio::-webkit-media-controls-enclosure {
    width: calc(100% + 32px);
    margin-left: auto;
}
```

# 3. 即使让下载按钮隐藏了，如何禁止右键下载？
```
// 给audio标签禁止右键，来禁止下载
<audio src="/i/horse.ogg" controls="controls" controlsList="nodownload" oncontextmenu="return false">
    Your browser does not support the audio element.
</audio>
```

# 4. 第三方插件: audiojs
项目地址: https://github.com/kolber/audiojs
优点： 简单，无依赖
缺点：异步插入的audio标签，每次还是需要重新调用audiojs.createAll()方法来重新实例化

```
// 1.
<script src="/audiojs/audio.js"></script>

// 2.
<script>
   audiojs.events.ready(function() {
     var as = audiojs.createAll();
   });
</script>
```
效果图：
![](/images/20180208134755_pPAs8b_Screenshot.jpeg)


# 5. audio相关问题以及解决方案
- [关于动态生成的mp3在audio标签无法拖动的问题: (audio断点续传)](https://wenjs.me/p/about-mp3progress-on-audio)


# 6. 参考文献
- https://stackoverflow.com/questions/41115801/in-chrome-55-prevent-showing-download-button-for-html-5-video
- https://stackoverflow.com/questions/39602852/disable-download-button-for-google-chrome/40975859#40975859
- https://googlechrome.github.io/samples/media/controlslist.html

  [1]: /img/bVO1bS
  [2]: /img/bVO1c5