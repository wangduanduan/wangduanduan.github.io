---
title: vscode控制字符引起的问题以及解决思路
date: 2018-02-11 17:48:41
tags:
- vscode
- 控制字符
- Local Search 解析失败
---

# 1. 环境
- macOS Sierra 10.12.5
- vscode  1.20.0 最新版

# 2. 如何重现这个问题
在使用中文输入法输入中文的时候，一直按后退键，例如输入`sfsf`，当你按了4下后退键时，你会发现，搜狗输入法弹出框虽然消失了，但是页面上还会剩下一个`s`, 这是你如何再次按一下后退的话，`s`就会变成`bs`, 变成隐藏字符。这个一般是右边有markdown渲染插件时才会出现。

从更确切的角度说，是你的编辑器一旦开了webview，就会出现这个问题，即使是vscode的欢迎页，也是webview，也会导致这个问题。所以最好在写代码时尽量关闭webview。

![](http://p3alsaatj.bkt.clouddn.com/20180211232544_7L7Ra6_Jietu20180211-232450.jpeg)

# 3. 如何让隐藏字符现身

Mac版的vscode控制字符一般是不会显示出来的，可以用一下的方法让其显示出来

```
"editor.renderControlCharacters": true
```

在编辑器中显示的像很小的`BS`, 表示backspace的意思。一般是在输入时，按了后退或者删除会偶尔出现这个字符。

![](http://p3alsaatj.bkt.clouddn.com/20180211175234_yzJFjc_Jietu20180211-175225.jpeg)


# 4. 隐藏的控制字符会出现什么问题？

## 4.1. 控制字符在github上会出现问号

例如下图的的和同字之间就是出现一个隐藏字符，在github上就会出现一个带有背景的问号。

![](http://p3alsaatj.bkt.clouddn.com/20180211180035_gpDDju_Jietu20180211-175923s.jpeg)

## 4.2. 控制字符在Hexo NexT Local Search 会导致search.xml渲染失败，搜索框一直在转圈

如果你使用浏览器打开search.xml，会发现解析报错

![](http://p3alsaatj.bkt.clouddn.com/20180211180331_Xr4FXL_Jietu20180211-180320.jpeg)


# 5. 如何解决
## 5.1. 手动删除隐藏字符
可以使用替换，先复制一个隐藏字符，然后把隐藏字符替换成空

## 5.2. 使用插件 Remove backspace control character
[Remove backspace control character](https://marketplace.visualstudio.com/items?itemName=satokaz.vscode-bs-ctrlchar-remover)

![](http://p3alsaatj.bkt.clouddn.com/20180211181051_MzYF2H_Jietu20180211-181045.jpeg)

在本家chromium已被合并，因此，在8月上旬发行的vscode 1.15将会重新确定(vscode 1.15, electron 1.7.4)。`事实上，到现在这个问题还是没解决的`

**特点**

格式化程序，用于删除打开的文档中包含的控制字符。要被删除的控制字符默认如下。

```
/[\u0000]|[\u0001]|[\u0002]|[\u0003]|[\u0004]|[\u0005]|[\u0006]|[\u0007]|[\u0008]|[\u000b]|[\u000c]|[\u000d]|[\u000e]|[\u000f]|[\u0010]|[\u0011]|[\u0012]|[\u0013]|[\u0014]|[\u0015]|[\u0016]|[\u0017]|[\u0018]|[\u0019]|[\u001a]|[\u001b]|[\u001c]|[\u001d]|[\u001e]|[\u001f]|[\u001c]|[\u007f]/gm
```

**用法**
- "editor.formatOnSave": true 如果被设定,保存时启动
- "editor.formatOnType": true 在被设定的情况下，进行变换时;输入时启动

## 5.3. 坐等官方给出更好的解决方案
官方这个bug依然还是`open`状态。[Using IME with markdown preview enabled, press ESC/BACKSPACE leads in control characters #37114](https://github.com/Microsoft/vscode/issues/37114)

## 5.4. 关闭所有webview
这个问题一般出现在标签页含有webview时发生，所以在升级到vscode最新版后，在写代码时要注意，不要开启任何有webview的标签页，其中包括
- 关闭markdown渲染插件实时渲染的功能
- 关闭vscode欢迎页标签页

# 6. 为什么官方不直接解决这个问题？
- vscode底层使用了electron，这是`electron`的[Backspace can not erase the last one character during Japanese IME conversion (macOS) #9173](https://github.com/electron/electron/issues/9173)bug, electron不解决这个问题，vscode就不会解决。

- electron底层使用了chromium， 这是`chromium`的[Two backspaces required to delete last character in webview input](https://bugs.chromium.org/p/chromium/issues/detail?id=714771)bug, chromium不解决，elctron就无法解决。

- 综上，截止文章写出之时，这个问题依然没解决。


# 7. 参考
- [Mac 上的 VSCode 编写 Markdown 总是出现隐藏字符？](https://www.zhihu.com/question/61638859)
- [Hexo next 主题的 local search 功能失效，点击搜索链接无法弹出叠加层](https://www.v2ex.com/t/298727)
- [Backspace can not erase the last one character during Chinese/Japanese IME conversion (macOS) #24981](https://github.com/Microsoft/vscode/issues/24981)
- [Backspace can not erase the last one character during Japanese IME conversion (macOS) #9173](https://github.com/electron/electron/issues/9173)
- [Two backspaces required to delete last character in webview input](https://bugs.chromium.org/p/chromium/issues/detail?id=714771)
- [控制字符](https://zh.wikipedia.org/wiki/%E6%8E%A7%E5%88%B6%E5%AD%97%E7%AC%A6)
- [Using IME with markdown preview enabled, press ESC/BACKSPACE leads in control characters #37114](https://github.com/Microsoft/vscode/issues/37114)