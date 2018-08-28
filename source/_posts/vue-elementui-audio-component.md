---
title: Vue+ElementUI 手把手教你做一个audio组件
date: 2018-02-09 13:44:13
tags:
- vue
- ElementUI
- audio
---

# 1. 简介
## 1.1. 相关技术

- [Vue](https://cn.vuejs.org/)
- [Vue-cli](https://github.com/vuejs/vue-cli)
- [ElementUI](http://element-cn.eleme.io/#/zh-CN)
- [yarn](https://yarnpkg.com/lang/zh-hans/) (之前我用npm, 并使用cnpm的源，但是用了yarn之后，我发现它比cnpm的速度还快，功能更好，我就毫不犹豫选择yarn了)
- [Audio相关API和事件](https://segmentfault.com/a/1190000009769804)

## 1.2. 从本教程你会学到什么？

- `Vue单文件组件开发知识`
- `Element UI基本用法`
- `Audio原生API及Audio相关事件`
- `音频播放器的基本原理`
- `音频的播放暂停控制`
- `更新音频显示时间`
- `音频进度条控制与跳转`
- `音频音量控制`
- `音频播放速度控制`
- `音频静音控制`
- `音频下载控制`
- `个性化配置与排他性播放`
- `一点点ES6语法`

# 2. 学前准备
基本上不需要什么准备，但是如果你能先看一下Aduio相关API和事件将会更好

- [Audio: 如果你愿意一层一层剥开我的心](https://wdd.js.org/audio-heart-detail.html)
- [使用 HTML5 音频和视频](https://developer.mozilla.org/zh-CN/docs/Web/Guide/HTML/Using_HTML5_audio_and_video)

# 3. [在线demon](https://wangduanduan.github.io/element-audio/)
`没有在线demo的教程都是耍流氓`

- [查看在线demon](https://wangduanduan.github.io/element-audio/)
- [项目地址](https://github.com/wangduanduan/element-audio)

![](/images/20180209134536_j9HvMg_Screenshot.jpeg)

# 4. 开始编码

# 5. 项目初始化

```
➜  test vue init webpack element-audio

  A newer version of vue-cli is available.

  latest:    2.9.2
  installed: 2.9.1

? Project name element-audio
? Project description A Vue.js project
? Author wangdd <wangdd@xxxxxx.com>
? Vue build standalone
? Install vue-router? No
? Use ESLint to lint your code? No
? Set up unit tests No
? Setup e2e tests with Nightwatch? No
? Should we run `npm install` for you after the project has been created? (recommended) npm

➜  test cd element-audio 
➜  element-audio npm run dev
```

浏览器打开 `http://localhost:8080/`, 看到如下界面，说明项目初始化成功

![](/images/20180209134627_t78Jqf_Screenshot.jpeg)

## 5.1. 安装ElementUI并插入audio标签
### 5.1.1. `安装ElementUI`
```
yarn add element-ui // or npm i element-ui -S
```

### 5.1.2. 在`src/main.js`中引入Element UI
```
// filename: src/main.js
import Vue from 'vue'
import ElementUI from 'element-ui'
import App from './App'
import 'element-ui/lib/theme-chalk/index.css'

Vue.config.productionTip = false

Vue.use(ElementUI)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  template: '<App/>',
  components: { App }
})

```
### 5.1.3. 创建`src/components/VueAudio.vue`
```
// filename: src/components/VueAudio.vue
<template>
  <div>
    <audio src="http://devtest.qiniudn.com/secret base~.mp3" controls="controls"></audio>
  </div>
</template>

<script>
export default {
  data () {
    return {}
  }
}
</script>

<style>

</style>

```

### 5.1.4. 修改`src/App.vue`, 并引入`VueAudio.vue`组件
```
// filename: src/App.vue
<template>
  <div id="app">
    <VueAudio />
  </div>
</template>

<script>
import VueAudio from './components/VueAudio'

export default {
  name: 'app',
  components: {
    VueAudio
  },
  data () {
    return {}
  }
}
</script>

<style>

</style>
```
打开：http://localhost:8080/，你应该能看到如下效果，说明引入成功，你可以点击播放按钮看看，音频是否能够播放
![](/images/20180209134643_6gU9xo_Screenshot.jpeg)

## 5.2. 音频的播放暂停控制
我们需要用一个按钮去控制音频的播放与暂停，这里调用了audio的两个api,以及两个事件

- audio.play()
- audio.pause()
- play事件
- pause事件

修改`src/components/VueAudio.vue`
```
// filename: src/components/VueAudio.vue
<template>
  <div>
    <!-- 此处的ref属性，可以很方便的在vue组件中通过 this.$refs.audio获取该dom元素 -->
    <audio ref="audio" 
    @pause="onPause"
    @play="onPlay"
    src="http://devtest.qiniudn.com/secret base~.mp3" controls="controls"></audio>

    <!-- 音频播放控件 -->
    <div>
      <el-button type="text" @click="startPlayOrPause">{{audio.playing | transPlayPause}}</el-button>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      audio: {
        // 该字段是音频是否处于播放状态的属性
        playing: false
      }
    }
  },
  methods: {
    // 控制音频的播放与暂停
    startPlayOrPause () {
      return this.audio.playing ? this.pause() : this.play()
    },
    // 播放音频
    play () {
      this.$refs.audio.play()
    },
    // 暂停音频
    pause () {
      this.$refs.audio.pause()
    },
    // 当音频播放
    onPlay () {
      this.audio.playing = true
    },
    // 当音频暂停
    onPause () {
      this.audio.playing = false
    }
  },
  filters: {
    // 使用组件过滤器来动态改变按钮的显示
    transPlayPause(value) {
      return value ? '暂停' : '播放'
    }
  }
}
</script>

<style>

</style>
```
![](/images/20180209134700_DTqSCu_Screenshot.jpeg)


## 5.3. 音频显示时间
音频的时间显示主要有两部分，音频的总时长和当前播放时间。可以从两个事件中获取
- `loadedmetadata`:代表音频的元数据已经被加载完成，可以从中获取音频总时长
- `timeupdate`: 当前播放位置作为正常播放的一部分而改变，或者以特别有趣的方式，例如不连续地改变，可以从该事件中获取音频的当前播放时间，`该事件在播放过程中会不断被触发`


`要点代码`：整数格式化成时:分:秒
```
function realFormatSecond(second) {
  var secondType = typeof second

  if (secondType === 'number' || secondType === 'string') {
    second = parseInt(second)

    var hours = Math.floor(second / 3600)
    second = second - hours * 3600
    var mimute = Math.floor(second / 60)
    second = second - mimute * 60

    return hours + ':' + ('0' + mimute).slice(-2) + ':' + ('0' + second).slice(-2)
  } else {
    return '0:00:00'
  }
}
```
`要点代码`： 两个事件的处理
```
// 当timeupdate事件大概每秒一次，用来更新音频流的当前播放时间
onTimeupdate(res) {
      console.log('timeupdate')
      console.log(res)
      this.audio.currentTime = res.target.currentTime
    },
// 当加载语音流元数据完成后，会触发该事件的回调函数
// 语音元数据主要是语音的长度之类的数据
onLoadedmetadata(res) {
  console.log('loadedmetadata')
  console.log(res)
  this.audio.maxTime = parseInt(res.target.duration)
}
```
`完整代码`
```
<template>
  <div>
    <!-- 此处的ref属性，可以很方便的在vue组件中通过 this.$refs.audio获取该dom元素 -->
    <audio ref="audio" 
    @pause="onPause"
    @play="onPlay"
    @timeupdate="onTimeupdate" 
    @loadedmetadata="onLoadedmetadata"
    src="http://devtest.qiniudn.com/secret base~.mp3" controls="controls"></audio>

    <!-- 音频播放控件 -->
    <div>
      <el-button type="text" @click="startPlayOrPause">{{audio.playing | transPlayPause}}</el-button>

      <el-tag type="info">{{ audio.currentTime | formatSecond}}</el-tag>

      <el-tag type="info">{{ audio.maxTime | formatSecond}}</el-tag>
    </div>
  </div>
</template>

<script>

// 将整数转换成 时：分：秒的格式
function realFormatSecond(second) {
  var secondType = typeof second

  if (secondType === 'number' || secondType === 'string') {
    second = parseInt(second)

    var hours = Math.floor(second / 3600)
    second = second - hours * 3600
    var mimute = Math.floor(second / 60)
    second = second - mimute * 60

    return hours + ':' + ('0' + mimute).slice(-2) + ':' + ('0' + second).slice(-2)
  } else {
    return '0:00:00'
  }
}

export default {
  data () {
    return {
      audio: {
        // 该字段是音频是否处于播放状态的属性
        playing: false,
        // 音频当前播放时长
        currentTime: 0,
        // 音频最大播放时长
        maxTime: 0
      }
    }
  },
  methods: {
    // 控制音频的播放与暂停
    startPlayOrPause () {
      return this.audio.playing ? this.pause() : this.play()
    },
    // 播放音频
    play () {
      this.$refs.audio.play()
    },
    // 暂停音频
    pause () {
      this.$refs.audio.pause()
    },
    // 当音频播放
    onPlay () {
      this.audio.playing = true
    },
    // 当音频暂停
    onPause () {
      this.audio.playing = false
    },
    // 当timeupdate事件大概每秒一次，用来更新音频流的当前播放时间
    onTimeupdate(res) {
      console.log('timeupdate')
      console.log(res)
      this.audio.currentTime = res.target.currentTime
    },
    // 当加载语音流元数据完成后，会触发该事件的回调函数
    // 语音元数据主要是语音的长度之类的数据
    onLoadedmetadata(res) {
      console.log('loadedmetadata')
      console.log(res)
      this.audio.maxTime = parseInt(res.target.duration)
    }
  },
  filters: {
    // 使用组件过滤器来动态改变按钮的显示
    transPlayPause(value) {
      return value ? '暂停' : '播放'
    },
    // 将整数转化成时分秒
    formatSecond(second = 0) {
      return realFormatSecond(second)
    }
  }
}
</script>

<style>

</style>
```
打开浏览器可以看到，当音频播放时，当前时间也在改变。
![](/images/20180209134724_Po5w9m_Screenshot.jpeg)

## 5.4. 音频进度条控制
进度条主要有两个控制，改变进度的原理是：改变`audio.currentTime`属性值

- 音频播放后，当前时间改变，进度条就要随之改变
- 拖动进度条，可以改变音频的当前时间

```
// 进度条ui
<el-slider v-model="sliderTime" :format-tooltip="formatProcessToolTip" @change="changeCurrentTime" class="slider"></el-slider>

// 拖动进度条，改变当前时间，index是进度条改变时的回调函数的参数0-100之间，需要换算成实际时间
changeCurrentTime(index) {
  this.$refs.audio.currentTime = parseInt(index / 100 * this.audio.maxTime)
},
// 当音频当前时间改变后，进度条也要改变
onTimeupdate(res) {
  console.log('timeupdate')
  console.log(res)
  this.audio.currentTime = res.target.currentTime
  this.sliderTime = parseInt(this.audio.currentTime / this.audio.maxTime * 100)
},

// 进度条格式化toolTip
formatProcessToolTip(index = 0) {
  index = parseInt(this.audio.maxTime / 100 * index)
  return '进度条: ' + realFormatSecond(index)
},
```

## 5.5. 音频音量控制
音频的音量控制和进度控制差不多，也是通过拖动滑动条，去修改`aduio.volume`属性值，此处不再啰嗦

## 5.6. 音频播放速度控制
音频播放速度控制和进度控制差不多，也是点击按钮，去修改`aduio.playbackRate`属性值，该属性代表音量的大小，取值范围是0 - 1，用滑动条的时候，也是需要换算一下值，此处不再啰嗦

## 5.7. 音频静音控制
静音的控制是点击按钮，去修改`aduio.muted`属性，该属性有两个值: true(静音)，false(不静音)。 注意，静音的时候，音频的进度条还是会继续往前走的。

## 5.8. 音频下载控制
音频下载是一个a链接，记得加上`download`属性，不然浏览器会在新标签打开音频，而不是下载音频
```
<a :href="url" v-show="!controlList.noDownload" target="_blank" class="download" download>下载</a>
```

## 5.9. 个性化配置
音频的个性化配置有很多，大家可以自己扩展，通过父组件传递响应的值，可以做到个性化设置。

```
 controlList: {
  // 不显示下载
  noDownload: false,
  // 不显示静音
  noMuted: false,
  // 不显示音量条
  noVolume: false,
  // 不显示进度条
  noProcess: false,
  // 只能播放一个
  onlyOnePlaying: false,
  // 不要快进按钮
  noSpeed: false
}

setControlList () {
    let controlList = this.theControlList.split(' ')
    controlList.forEach((item) => {
      if(this.controlList[item] !== undefined){
        this.controlList[item] = true
      }
    })
},
```

例如父组件这样
```
<template>
  <div id="app">
    <div v-for="item in audios" :key="item.url">
      <VueAudio :theUrl="item.url" :theControlList="item.controlList"/>
    </div>
  </div>
</template>

<script>
import VueAudio from './components/VueAudio'

export default {
  name: 'app',
  components: {
    VueAudio
  },
  data () {
    return {
      audios: [
        {
          url: 'http://devtest.qiniudn.com/secret base~.mp3',
          controlList: 'onlyOnePlaying'
        },
        {
          url: 'http://devtest.qiniudn.com/回レ！雪月花.mp3',
          controlList: 'noDownload noMuted onlyOnePlaying'
        },{
          url: 'http://devtest.qiniudn.com/あっちゅ～ま青春!.mp3',
          controlList: 'noDownload noVolume noMuted onlyOnePlaying'
        },{
          url: 'http://devtest.qiniudn.com/Preparation.mp3',
          controlList: 'noDownload noSpeed onlyOnePlaying'
        }
      ]
    }
  }
}
</script>

<style>

</style>
```
## 5.10. 一点点ES6语法
大多数时候，我们希望页面上播放一个音频时，其他音频可以暂停。
`[...audios]`可以把一个类数组转化成数组，这个是我常用的。

```
onPlay (res) {
    console.log(res)
    this.audio.playing = true
    this.audio.loading = false
    
    if(!this.controlList.onlyOnePlaying){
      return 
    }
    
    let target = res.target
    
    let audios = document.getElementsByTagName('audio');
    // 如果设置了排他性，当前音频播放是，其他音频都要暂停
    [...audios].forEach((item) => {
      if(item !== target){
        item.pause()
      }
    })
},
```

## 5.11. 完成后的文件

```
//filename: VueAudio.vue
<template>
  <div class="di main-wrap" v-loading="audio.waiting">
    <!-- 这里设置了ref属性后，在vue组件中，就可以用this.$refs.audio来访问该dom元素 -->
    <audio ref="audio" class="dn" 
    :src="url" :preload="audio.preload"
    @play="onPlay" 
    @error="onError"
    @waiting="onWaiting"
    @pause="onPause" 
    @timeupdate="onTimeupdate" 
    @loadedmetadata="onLoadedmetadata"
    ></audio>
    <div>
      <el-button type="text" @click="startPlayOrPause">{{audio.playing | transPlayPause}}</el-button>
      <el-button v-show="!controlList.noSpeed" type="text" @click="changeSpeed">{{audio.speed | transSpeed}}</el-button>

      <el-tag type="info">{{ audio.currentTime | formatSecond}}</el-tag>

      <el-slider v-show="!controlList.noProcess" v-model="sliderTime" :format-tooltip="formatProcessToolTip" @change="changeCurrentTime" class="slider"></el-slider>
      
      <el-tag type="info">{{ audio.maxTime | formatSecond }}</el-tag>

      <el-button v-show="!controlList.noMuted" type="text" @click="startMutedOrNot">{{audio.muted | transMutedOrNot}}</el-button>

      <el-slider v-show="!controlList.noVolume" v-model="volume" :format-tooltip="formatVolumeToolTip" @change="changeVolume" class="slider"></el-slider>
      
      <a :href="url" v-show="!controlList.noDownload" target="_blank" class="download" download>下载</a>
    </div>
  </div>
</template>

<script>
  function realFormatSecond(second) {
    var secondType = typeof second

    if (secondType === 'number' || secondType === 'string') {
      second = parseInt(second)

      var hours = Math.floor(second / 3600)
      second = second - hours * 3600
      var mimute = Math.floor(second / 60)
      second = second - mimute * 60

      return hours + ':' + ('0' + mimute).slice(-2) + ':' + ('0' + second).slice(-2)
    } else {
      return '0:00:00'
    }
  }

  export default {
    props: {
      theUrl: {
        type: String,
        required: true,
      },
      theSpeeds: {
        type: Array,
        default () {
          return [1, 1.5, 2]
        }
      },
      theControlList: {
        type: String,
        default: ''
      }
    },
    name: 'VueAudio',
    data() {
      return {
        url: this.theUrl || 'http://devtest.qiniudn.com/secret base~.mp3',
        audio: {
          currentTime: 0,
          maxTime: 0,
          playing: false,
          muted: false,
          speed: 1,
          waiting: true,
          preload: 'auto'
        },

        sliderTime: 0,
        volume: 100,
        speeds: this.theSpeeds,

        controlList: {
          // 不显示下载
          noDownload: false,
          // 不显示静音
          noMuted: false,
          // 不显示音量条
          noVolume: false,
          // 不显示进度条
          noProcess: false,
          // 只能播放一个
          onlyOnePlaying: false,
          // 不要快进按钮
          noSpeed: false
        }
      }
    },
    methods: {
      setControlList () {
        let controlList = this.theControlList.split(' ')
        controlList.forEach((item) => {
          if(this.controlList[item] !== undefined){
            this.controlList[item] = true
          }
        })
      },
      changeSpeed() {
        let index = this.speeds.indexOf(this.audio.speed) + 1
        this.audio.speed = this.speeds[index % this.speeds.length]
        this.$refs.audio.playbackRate = this.audio.speed
      },
      startMutedOrNot() {
        this.$refs.audio.muted = !this.$refs.audio.muted
        this.audio.muted = this.$refs.audio.muted
      },
      // 音量条toolTip
      formatVolumeToolTip(index) {
        return '音量条: ' + index
      },
      // 进度条toolTip
      formatProcessToolTip(index = 0) {
        index = parseInt(this.audio.maxTime / 100 * index)
        return '进度条: ' + realFormatSecond(index)
      },
      // 音量改变
      changeVolume(index = 0) {
        this.$refs.audio.volume = index / 100
        this.volume = index
      },
      // 播放跳转
      changeCurrentTime(index) {
        this.$refs.audio.currentTime = parseInt(index / 100 * this.audio.maxTime)
      },
      startPlayOrPause() {
        return this.audio.playing ? this.pausePlay() : this.startPlay()
      },
      // 开始播放
      startPlay() {
        this.$refs.audio.play()
      },
      // 暂停
      pausePlay() {
        this.$refs.audio.pause()
      },
      // 当音频暂停
      onPause () {
        this.audio.playing = false
      },
      // 当发生错误, 就出现loading状态
      onError () {
        this.audio.waiting = true
      },
      // 当音频开始等待
      onWaiting (res) {
        console.log(res)
      },
      // 当音频开始播放
      onPlay (res) {
        console.log(res)
        this.audio.playing = true
        this.audio.loading = false

        if(!this.controlList.onlyOnePlaying){
          return 
        }

        let target = res.target

        let audios = document.getElementsByTagName('audio');

        [...audios].forEach((item) => {
          if(item !== target){
            item.pause()
          }
        })
      },
      // 当timeupdate事件大概每秒一次，用来更新音频流的当前播放时间
      onTimeupdate(res) {
        // console.log('timeupdate')
        // console.log(res)
        this.audio.currentTime = res.target.currentTime
        this.sliderTime = parseInt(this.audio.currentTime / this.audio.maxTime * 100)
      },
      // 当加载语音流元数据完成后，会触发该事件的回调函数
      // 语音元数据主要是语音的长度之类的数据
      onLoadedmetadata(res) {
        console.log('loadedmetadata')
        console.log(res)
        this.audio.waiting = false
        this.audio.maxTime = parseInt(res.target.duration)
      }
    },
    filters: {
      formatSecond(second = 0) {
        return realFormatSecond(second)
      },
      transPlayPause(value) {
        return value ? '暂停' : '播放'
      },
      transMutedOrNot(value) {
        return value ? '放音' : '静音'
      },
      transSpeed(value) {
        return '快进: x' + value
      }
    },
    created() {
      this.setControlList()
    }
  }

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  .main-wrap{
    padding: 10px 15px;
  }
  .slider {
    display: inline-block;
    width: 100px;
    position: relative;
    top: 14px;
    margin-left: 15px;
  }

  .di {
    display: inline-block;
  }

  .download {
    color: #409EFF;
    margin-left: 15px;
  }

  .dn{
    display: none;
  }

</style>

```

# 6. 感谢
- 如果你需要一个小型的vue音乐播放器，你可以试试[vue-aplayer](https://github.com/SevenOutman/vue-aplayer), 该播放器不仅仅支持vue组件，非Vue的也支持，你可以看看他们的[demo](https://sevenoutman.github.io/vue-aplayer/demo)


  [1]: /img/bV0pZr
  [2]: /img/bV0pZt
  [3]: /img/bV0pZx
  [4]: /img/bV0pZB
  [5]: /img/bV0pZL
