---
title: "ghost博客 固定feature博客"
date: "2019-07-22 17:30:35"
draft: false
---

# Docker ghost 安装

```bash
	docker run -d --name myghost -p 8090:2368 -e url=http://172.16.200.228:8090/ \
	-v /root/volumes/ghost:/var/lib/ghost/content ghost
```



# 模板修改


# 参考

- [https://www.ghostforbeginners.com/move-featured-posts-to-the-top-of-your-blog/](https://www.ghostforbeginners.com/move-featured-posts-to-the-top-of-your-blog/)

