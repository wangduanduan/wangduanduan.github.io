---
title: 前端小白的python实战 报纸分词排序
date: 2018-02-08 09:23:37
tags:
- Python
- 分词
---

先看效果：

![](http://p3alsaatj.bkt.clouddn.com/20180208092429_56loaY_Screenshot.jpeg)
# 环境
- win7 64位
- python 3.5

# 目标
抓取一篇报纸，并提取出关键字，然后按照出现次数排序，用echarts在页面上显示出来。

# 工具选择
因为之前对nodejs的相关工具比较熟悉，在用python的时候，也想有类似的工具。所以就做了一个对比的表格。

功能 | nodejs版 | python版
--- | --- | ---
http工具 | [request](https://github.com/request/request) | [requests](https://github.com/requests/requests)
中文分词工具 | [node-segment](https://github.com/leizongmin/node-segment), [nodejieba](https://github.com/yanyiwu/nodejieba)(一直没有安装成功过) | [jieba](https://github.com/fxsjy/jieba)(分词准确度比node-segment好)
DOM解析工具 | [cheeio](https://github.com/cheeriojs/cheerio) | [pyquery](https://github.com/gawel/pyquery)(这两个工具都是有类似jQuery那种选择DOM的接口，很方便)
函数编程工具 | [underscore.js](https://github.com/jashkenas/underscore) | [underscore.py](https://github.com/serkanyersen/underscore.py)(underscore来处理集合比较方便)
服务器 | [express](https://github.com/expressjs/express) | [flask](https://github.com/pallets/flask)

# 开始的噩梦：中文乱码
感觉每个学python的人都遇到过中文乱码的问题。我也不例外。

首先要抓取网页，但是网页在控制台输出的时候，中文总是乱码。搞了好久，搞得我差点要放弃python。最终找到解决方法。[ 解决python3 UnicodeEncodeError: 'gbk' codec can't encode character '\xXX' in position XX](http://blog.csdn.net/jim7424994/article/details/22675759)

过程很艰辛，但是从中也学到很多知识。

```
import io
import sys
sys.stdout = io.TextIOWrapper(sys.stoodout.buffer,encoding='gb18030')
```

# 函数式编程： 顺享丝滑
```
#filename word_rank.py
import requests
import io
import re
import sys
import jieba as _jieba # 中文分词比较优秀的一个库
from pyquery import PyQuery as pq #类似于jquery、cheerio的库
from underscore import _ # underscore.js python版本
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030') # 解决控制台中文乱码

USELESSWORDS = ['的','要','了','在','和','是','把','向','上','为','等','个'] # 标记一些无用的单词
TOP = 30 # 只要前面的30个就可以了

def _remove_punctuation(line): # 移除非中文字符
    # rule = re.compile("[^a-zA-Z0-9\u4e00-\u9fa5]")
    rule = re.compile("[^\u4e00-\u9fa5]")
    line = rule.sub('',line)
    return line

def _calculate_frequency(words): # 计算分词出现的次数
    result = {}
    res = []

    for word in words:
        if result.get(word, -1) == -1:
            result[word] = 1
        else:
            result[word] += 1

    for word in result:
        if _.contains(USELESSWORDS, word): # 排除无用的分词
            continue

        res.append({
                'word': word,
                'fre': result[word]
            })

    return _.sortBy(res, 'fre')[::-1][:TOP] # 降序排列

def _get_page(url): # 获取页面
    return requests.get(url)

def _get_text(req): # 获取文章部分
    return pq(req.content)('#ozoom').text()

def main(url): # 入口函数，函数组合
    return _.compose(
        _get_page,
        _get_text,
        _remove_punctuation,
        _jieba.cut,
        _calculate_frequency
        )(url)

```

# python服务端：Flask浅入浅出
```
import word_rank
from flask import Flask, request, jsonify, render_template
app = Flask(__name__)
app.debug = True

@app.route('/rank') # 从query参数里获取pageUrl，并给分词排序
def getRank():
    pageUrl = request.args.get('pageUrl')
    app.logger.debug(pageUrl)

    rank = word_rank.main(pageUrl)
    app.logger.debug(rank)
    return jsonify(rank)

@app.route('/') # 主页面
def getHome():
    return render_template('home.html')

if __name__ == '__main__':
    app.run()
```

# 总结
据说有个定律：`凡是能用JavaScript写出来的，最终都会用JavaScript写出来`。 我是很希望这样啦。但是不得不承认，python上有很多非常优秀的库。
这些库在npm上并没有找到合适的替代品。

所以，我就想: `如何能用nodejs直接调用python的第三方库`

目前的解决方案有两种，第一，只用nodejs的child_processes。这个方案我试过，但是不太好用。

第二，npm里面有一些包，可以直接调用python的库。例如：[node-python](https://github.com/chrisdickinson/node-python), [python.js](https://github.com/monkeycz/python.js), 但是这些包我在win7上安装的时候总是报错。而且解决方法也蛮麻烦的。索性我就直接用python了。

最后附上项目地址：https://github.com/wangduanduan/read-newspaper


  [1]: /img/bVRLCc