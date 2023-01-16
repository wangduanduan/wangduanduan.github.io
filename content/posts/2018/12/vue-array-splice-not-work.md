---
title: WTF!! Vue数组splice方法无法正常工作
date: 2018-12-12 20:29:16
tags:
- bug
- Vue
- splice
---

当函数执行到this.agents.splice()时，我设置了断点。发现传参index是0，但是页面上的列表项对应的第一行数据没有被删除，

WTF！！！ 这是什么鬼！然后我打开Vue Devtools, 然后刷新了一下，发现那个数组的第一项还是存在的。什么鬼？？

```js
removeOneAgentByIndex: function (index) {
  this.agents.splice(index, 1)
}
```

然后我就谷歌了一下，发现这个[splice not working properly my object list VueJs](https://stackoverflow.com/questions/48484773/splice-not-working-properly-my-object-list-vuejs), 大概意思是v-for的时候最好给列表项绑定`:key=`。然后我是试了这个方法，发现没啥作用。

最终我决定，单步调试，**如果我发现该问题出在Vue自身，那我就该抛弃Vue, 学习React了**

单步调试中出现一个异常的情况，removeOneAgentByIndex是被A函数调用的，A函数由websocket事件驱动。正常情况下应该触发一次的事件，服务端却发送了两次到客户端。由于事件重复，第一次执行A删除时，实际上removeOneAgentByIndex是执行成功了，但是重复的第二个事件到来时，A函数又往agents数组中添加了一项。导致看起来，removeOneAgentByIndex函数执行起来似乎没有设么作用。而且这两个重复的事件是在几乎是在同一时间发送到客户端，所以我几乎花了将近一个小时去解决这个bug。`引起这个bug的原因是事件重复，所以我在前端代码中加入事件去重功能，最终解决这个问题。`

我记得之前看过一篇文章，一个开发者调通过回调函数计费，回调函数是由事件触发，但是没想到有时候事件会重发，导致重复计费。后来这名开发者在自己的代码中加入事件去重的功能，最终解决了这个问题。

事后总结：我觉得我不该怀疑Vue这种库出现了问题，但是我又不禁去怀疑。

通过这个bug, 我也学到了第二方法，可以删除Vue数组中的某一项，参考下面代码。

```js
// Only in 2.2.0+: Also works with Array + index.
removeOneAgentByIndex: function (index) {
  this.$delete(this.agents, index)
}
```

另外Vue devtools有时候并不会实时的观测到组件属性的变化，即使点了Refresh按钮。如果点了Refresh按钮还不行，那建议你重新打开谷歌浏览器的devtools面板。