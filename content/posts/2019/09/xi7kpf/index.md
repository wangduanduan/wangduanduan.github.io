---
title: "关注点分离的问题"
date: "2019-09-06 12:37:25"
draft: false
---
前端组件化时，有个很时髦的词语叫做关注点分离，这个用在组件上比较好，我们可以把大的模块分割成小的模块，降低了整个模块的复杂度。

但是有时候，我觉得关注点分离并不好。这个不是指在代码开发过程，而是解决问题的过程。


# 关注点分离的处理方式

假如我要解决问题A，但是在解决过程中，我发现了一个我不知道的东西B, 然后我就去研究这B是什么东西，然后接二连三，我从B一路找到了Z。

然后在这个解决过程耽误一段时候后，才想起来：我之前是要解决什么问题来着？？


# 关注点集中的处理方式

- 不要再深究的路径上走的太深
- 在走其他路径时，也不要忘记最后要回到A点