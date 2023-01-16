---
title: "中途多语言适配"
date: "2022-07-12 22:54:55"
draft: false
---

# 1. 前提说明
- 项目已经处于维护期
- 项目一开始并没有考虑多语言，所以很多地方都是写死的中文
- 现在要给这个项目添加多语言适配

# 2. 工具选择

- [https://www.npmjs.com/package/i18n](https://www.npmjs.com/package/i18n)
- [https://www.npmjs.com/package/vue-i18n](https://www.npmjs.com/package/vue-i18n)

# 3. 难点

- 项目很大，中文可能存在于各种文件中，例如html, vue, js, typescript等等， 人工查找不现实
- 所以首先第一步是要找出所有的中文语句


# 4. 让文本飞

1. 安装ripgrep `apt-get instal ripgrep`
2. 搜索所有包含中文的代码: `rg -e '[\p{Han}]' > han.all.md`
3. 给所有包含中文的代码，按照文件名，和出现的次数排序:  `cat han.all.md | awk -F: '{print  $1}' | uniq -c | sort -nr > stat.han.md`  这一步主要是看看哪些文件包含的中文比较多
4. 按照中文的语句，排序并统计出现的次数: `cat han.all.md |rg -o -e '([\p{Han}]+)' | sort | uniq -c | sort -nr > word.han.md`

经过上面4步，基本上可以定位出哪些代码中包含中文，中文的语句有哪些。


