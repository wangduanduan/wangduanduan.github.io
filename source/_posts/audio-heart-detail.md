---
title: Audio 如果你愿意一层一层剥开我的心
date: 2018-02-08 09:44:01
tags:
- audio
---

> 我觉得DOM就好像是元素周期表里的元素，JS就好像是实验器材，通过各种化学反应，产生各种魔术。

![](http://p3alsaatj.bkt.clouddn.com/20180208094439_zGRL80_Screenshot.jpeg)

# Audio
通过打开谷歌浏览器的dev tools -> Settings -> Elements -> Show user agent shadow DOM, 你可以看到其实Audio标签也是由常用的 input标签和div等标签合成的。

![](http://p3alsaatj.bkt.clouddn.com/20180208094451_tBBQUM_Screenshot.jpeg)

# 基本用法
```
1 <audio src="http://65.ierge.cn/12/186/372266.mp3">
Your browser does not support the audio element.
</audio>

<br>

2 <audio src="http://65.ierge.cn/12/186/372266.mp3" controls="controls">
Your browser does not support the audio element.
</audio>

<br>

// controlsList属性目前只支持 chrome 58+
3 <audio src="http://65.ierge.cn/12/186/372266.mp3" controls="controls" controlsList="nodownload"> 
Your browser does not support the audio element.
</audio>

<br>

4 <audio controls="controls">
<source src="http://65.ierge.cn/12/186/372266.mp3" type='audio/mp3' />
</audio>
```
你可以看出他们在Chrome里表现的差异

![](http://p3alsaatj.bkt.clouddn.com/20180208094513_MO2e9z_Screenshot.jpeg)

关于audio标签支持的音频类型，可以参考[Audio#Supported_audio_coding_formats](https://en.wikipedia.org/wiki/HTML5_Audio#Supported_audio_coding_formats)

![](http://p3alsaatj.bkt.clouddn.com/20180208094523_k82xlG_Screenshot.jpeg)

# 常用属性
- autoplay: 音频流文件就绪后是否自动播放
- preload: "none" | "metadata" | "auto" | "" 
    - "none": 无需预加载
    - "metadata": 只需要加载元数据，例如音频时长，文件大小等。
    - "auto": 自动优化下载整个流文件
    
- controls： "controls" | "" 是否需要显示控件
- loop： "loop" or "" 是否循环播放
- mediagroup： string 多个视频或者音频流是否合并
- src： 音频地址

# API(重点)
- load(): 加载资源
- play(): 播放
- pause(): 暂停
- canPlayType()： 询问浏览器以确定是否可以播放给定的MIME类型
- buffered()：指定文件的缓冲部分的开始和结束时间

# 常用事件：Media Events(重点)

事件名  |	何时触发
--- | ---
loadstart | 开始加载
progress |	正在加载
suspend | 用户代理有意无法获取媒体数据，无法获取整个文件
abort |	主动终端下载资源并不是由于发生错误
error |	获取资源时发生错误
play |	开始播放
pause | 播放暂停
loadedmetadata | 刚获取完元数据
loadeddata | 第一次渲染元数据
waiting | 等待中
playing | 正在播放
canplay	| 用户代理可以恢复播放媒体数据，但是估计如果现在开始播放，则媒体资源不能以当前播放速率直到其结束呈现，而不必停止进一步缓冲内容。
canplaythrough | 用户代理估计，如果现在开始播放，则媒体资源可以以当前播放速率一直呈现到其结束，而不必停止进一步的缓冲。
timeupdate	| 当前播放位置作为正常播放的一部分而改变，或者以特别有趣的方式，例如不连续地改变。
ended |	播放结束
ratechange | 媒体播放速度改变
durationchange | 媒体时长改变
volumechange| 媒体声音大小改变

# Audio DOM 属性(重点)
## 只读属性
- `duration`： 媒体时长，数值， 单位s
- `ended`: 是否完成播放，布尔值
- `paused`: 是否播放暂停，布尔值

## 其他可读写属性(重点)
- `playbackRate`： 播放速度，大多数浏览器支持0.5-4， 1表示正常速度，设置该属性可以修改播放速度
- `volume`：0.0-1.0之间，设置该属性可以修改声音大小
- `muted`: 是否静音， 设置该属性可以静音
- `currentTime`：指定播放位置的秒数

```
// 你可以使用元素的属性seekable来决定媒体目前能查找的范围。它返回一个你可以查找的TimeRanges 时间对象。
var mediaElement = document.getElementById('mediaElementID');
mediaElement.seekable.start();  // 返回开始时间 (in seconds)
mediaElement.seekable.end();    // 返回结束时间 (in seconds)
mediaElement.currentTime = 122; // 设定在 122 seconds
mediaElement.played.end();      // 返回浏览器播放的秒数
```

以下方法可以使音频以2倍速度播放。
```
<audio id="wdd" src="http://65.ierge.cn/12/186/372266.mp3" controls="controls">
Your browser does not support the audio element.
</audio>

<script>
    var myAudio = document.getElementById('wdd');
    myAudio.playbackRate = 2;
</script>
```

# 常见问题及解决方法
- `录音无法拖动，播放一端就自动停止`： https://wenjs.me/p/about-mp3progress-on-audio
- `如何隐藏Audio的下载按钮`：https://segmentfault.com/a/1190000009737051
- `想找一个简单的录音播放插件`： https://github.com/kolber/audiojs


# 参考资料
- [W3C: the-audio-element](https://www.w3.org/TR/html5/embedded-content-0.html#the-audio-element)
- [wikipedia: HTML5 Audio](https://en.wikipedia.org/wiki/HTML5_Audio#Supported_audio_coding_formats)
- [W3C: HTML/Elements/audio](https://www.w3.org/wiki/HTML/Elements/audio#Media_Events)
- [Native Audio in the browser](http://html5doctor.com/native-audio-in-the-browser/)
- [HTMLMediaElement.playbackRate](https://developer.mozilla.org/en-US/Apps/Fundamentals/Audio_and_video_delivery/WebAudio_playbackRate_explained)
- [使用 HTML5 音频和视频](https://developer.mozilla.org/zh-CN/docs/Web/Guide/HTML/Using_HTML5_audio_and_video)

  [1]: /img/bVO9vK
  [2]: /img/bVO9xq
  [3]: /img/bVO9xQ
  [4]: /img/bVO9yB
  [5]: /img/bVPaRk
  [6]: /img/bVPaSA
  [7]: /img/bVPaSS