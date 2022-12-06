---
title: '清除所有GIT历史记录'
date: '2022-12-01 09:49:29'
draft: false
type: posts
tags:
    - git
categories:
    - git
---

有些时候，git 仓库累积了太多无用的历史更改，导致 clone 文件过大。如果确定历史更改没有意义，可以采用下述方法清空历史，

1.  先 clone 项目到本地目录 (以名为 mylearning 的仓库为例)

```
git clone git@gitee.com:badboycoming/mylearning.git
```

2.  进入 mylearning 仓库，拉一个分支，比如名为 latest_branch

```
git checkout --orphan latest_branch
```

3.  添加所有文件到上述分支 (Optional)

```
 git add -A
```

4.  提交一次

```
 git commit -am "Initial commit."
```

5.  删除 master 分支

```
git branch -D master
```

6.  更改当前分支为 master 分支

```
git branch -m master
```

7.  将本地所有更改 push 到远程仓库

```
git push -f origin master
```

8.  关联本地 master 到远程 master

```
git branch --set-upstream-to=origin/master
```
