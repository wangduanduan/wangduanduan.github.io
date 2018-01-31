---
title: git合并上游仓库即同步fork后的仓库
date: 2018-01-31 17:16:44
tags:
- fork
- git
- 合并上游分支
---

# 前提说明
- 仓库A: http://gitlab.tt.cc:30000/fe/omp.git
- 仓库B: 仓库Bfork自仓库A, 仓库A的地址是：http://gitlab.tt.cc:30000/wangdd/omp.git

某一时刻，仓库A更新了。仓库B需要同步上游分支的更新。

# 本地操作

```
// 1 查看远程分支
➜  omp git:(master) git remote -v
origin	http://gitlab.tt.cc:30000/wangdd/omp.git (fetch)
origin	http://gitlab.tt.cc:30000/wangdd/omp.git (push)

// 2 添加一个远程同步的上游仓库
➜  omp git:(master) git remote add upstream http://gitlab.tt.cc:30000/fe/omp.git
➜  omp git:(master) git remote -v
origin	http://gitlab.tt.cc:30000/wangdd/omp.git (fetch)
origin	http://gitlab.tt.cc:30000/wangdd/omp.git (push)
upstream	http://gitlab.tt.cc:30000/fe/omp.git (fetch)
upstream	http://gitlab.tt.cc:30000/fe/omp.git (push)

// 3 拉去上游分支到本地，并且会被存储在一个新分支upstream/master
➜  omp git:(master) git fetch upstream
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 4 (delta 2), reused 0 (delta 0)
Unpacking objects: 100% (4/4), done.
From http://gitlab.tt.cc:30000/fe/omp
 * [new branch]      master     -> upstream/master

// 4 将upstream/master分支合并到master分支，由于我已经在master分支，此处就不在切换到master分支
➜  omp git:(master) git merge upstream/master
Updating 29c098c..6413803
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)

// 5 查看一下，此次合并，本地有哪些更新
➜  omp git:(master) git log -p

// 6 然后将更新推送到仓库B
➜  omp git:(master) git push
```

# 总结
通过上述操作，仓库B就同步了仓库A的代码。整体的逻辑就是将`上游分支拉去到本地，然后合并到本地分支上`。就这么简单。