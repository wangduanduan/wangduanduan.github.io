---
title: "Hugo博客常见问题以及解决方案"
date: 2022-05-28T21:08:43+08:00
tags:
- hugo
cover:
    image: "/images/qianxun.jpeg"
    alt: "千与千寻"
    caption: "千与千寻"
    relative: false
---

# 如何在markdown中插入图片

在static 目录中创建 images 目录，然后把图片放到images目录中。

在文章中引用的时候

```
![](/images/qianxun.jpeg#center)
```

![](/images/qianxun.jpeg#center)

{{< notice warning >}}

我之前创建的文件夹的名字叫做 img, 本地可以正常显示，但是部署之后，就无法显示图片了。

最后我把img改成images才能正常在网页上显示。

{{< /notice >}}
