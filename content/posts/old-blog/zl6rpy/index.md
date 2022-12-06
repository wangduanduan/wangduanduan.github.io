---
title: "从/bin/sh到费曼学习法"
date: "2021-04-28 15:08:19"
draft: false
---

今天在写一个shell脚本的时候，遇到一个奇怪的报错，说我的脚本有语法错误。

```bash
if [ $1 == $2 ]; then
	echo ok
else
	echo not ok
fi
```

编译器的报错是说if语句是有问题的，但是我核对了好久遍，也看了网上的例子，发现没什么毛病。

我自己看了几分钟，还是看不出所以然来。然后我就找了一位同事帮我看看，首先我给他解释了一遍我的脚本是如何工作的，说着说着，他还在思考的时候。我突然发现，我知道原因了。

这个shell脚本是我从另一个脚本里拷贝的。脚本的第一行是

```bash
#!/bin/sh
```

原因就在与第一行的这条语句。

一般情况下我们都是写得/bin/bash,  但是在拷贝的时候，我没有考虑到这个。实际在我的电脑上/bin/sh很可能不是bash, 而是zsh，zsh的语法和bash的语法是不一样的。所以会抱语法错误

```bash
#!/bin/bash
```

这就是典型的一叶障目，不见泰山。 我觉得我需要买个小黄鸭，在遇到的难以解决的问题时，抽丝剥茧的解释给它听。


经过这件事情后，我也想到了今天刚学到的一个概念。叫做费曼学习法，据说是很牛逼的学习法，可以非常快的学习一门知识。

简单介绍一下费曼学习法：

1. 选择一个你要学学习的概念，写在本子上
2. 假装你要把这个概念教会别人
3. 你一定会某些地方卡壳的，当你卡壳的时候，就立即回去看书
4. 简化你的语言，目的是用你自己的语言，解释某个概念，如果你依然还是有些困惑，那说明你还是不够了解这个概念。

 费曼曾获得诺贝尔奖，所以上他不是个简单的人。费曼的老师叫惠勒，费曼的学习方法很可能收到惠勒的影响。


惠勒常常说：人只有教别人的时候，才能学到更多。

> Another favorite Wheelerism is "one can only learn by teaching. 惠勒主义


惠勒还有一句名言：

去恨就是是学习，去学习是去理解，去理解是去欣赏，去欣赏则是去爱，也许你会爱上你的理论。，

> To hate is to study, to study is to understand, to understand is to appreciate, to appreciate is to love. So maybe I'll end up loving your theory.  -- Wheeler


总之，我们如果在学习时能够把知识传授给别人，对自己来说也是一种学习。


# 参考

- [https://www.zhihu.com/question/20576786](https://www.zhihu.com/question/20576786)
- [https://baike.baidu.com/item/%E8%B4%B9%E6%9B%BC%E5%AD%A6%E4%B9%A0%E6%B3%95/50895393](https://baike.baidu.com/item/%E8%B4%B9%E6%9B%BC%E5%AD%A6%E4%B9%A0%E6%B3%95/50895393)
- [https://www.quora.com/Learning-New-Things/How-can-you-learn-faster/answer/Acaz-Pereira](https://www.quora.com/Learning-New-Things/How-can-you-learn-faster/answer/Acaz-Pereira)
- [https://www.scientificamerican.com/article/pioneering-physicist-john-wheeler-dies/](https://www.scientificamerican.com/article/pioneering-physicist-john-wheeler-dies/)

