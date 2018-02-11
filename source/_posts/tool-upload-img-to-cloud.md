---
title: Mac版：上传图片到远程图床哪家强？
date: 2018-02-11 14:09:09
tags:
- 工具
---

> markdown写文档虽然如行云流水，但是一旦需要引入图片了。往往需要四五步操作，如果图片仅仅保存在本地，那么复制markdown时，图片路径往往都不对了，还要重新上传一遍图片，很是麻烦。

因此，`最好把图片直接上传到图床上`，然后通过公网链接来引入图片。图床选择上，我选择七牛云。

我在网上找到了3个不错的工具，在此记录一下。

# 1. 三个工具分析一览

这些工具在上传图片成功后，会把链接保存在剪贴板中，在markdown文件中只需要粘贴一下就可以了。

名称 | 收费标准 | 优点 | 缺点 | 推荐指数 | 说明 | 下载地址
---|---|---|---|----
ipic | 50元/年 | 支持很多的云服务，压缩，拖拽上传 | 死贵, 免费版只能用新浪图床，图片很可能会丢失 | `A` |功能很多，价钱死贵 | 可通过mac app store 下载
UCQCloud | 免费 | 免费，支持压缩，拖拽上传，截图上传 | 仅支持七牛，服务器仅支持华东和华北 | `AAA` | 免费，功能够用 | [UCQCloud1.3.3.dmg](https://link.jianshu.com/?t=http://7xr7vj.com1.z0.glb.clouddn.com/UCQCloud1.3.3.dmg)
cuImage | 终身1元 | 剪贴板上传，压缩上传，拖拽上传，快捷键上传，自动把链接转成markdown的形式 | 仅支持七牛 | `AAAA` | cuImage的压缩率要比UCQCloud高很多 | 可通过mac app store 下载


总体来说：`如果你用七牛图床，cuImage是性价比最高, 用户体验最好的`


# 2. 三个工具操作截图与简介

# 3. cuImage

- 图片上传完成后自动复制URL。
- 在“上传历史”中查看已上传图片。
- 批量上传图片。
- 通过截图或复制上传图片。
- 通过拖拽上传图片。
- 通过”服务“菜单上传图片。
- 通过全局快捷键上传图片。
- 上传之前压缩图片。
- 支持BMP/JPEG/PNG/GIF/TIFF等多种文件格式。
- 只支持七牛云，已兼容七牛云华东、华北、华南及北美的存储区域。

![](https://camo.githubusercontent.com/16d25db3e16f70c864c6794d565bd46535d91944/687474703a2f2f6f68636f71626638652e626b742e636c6f7564646e2e636f6d2f32303137303231303136303432325f30724f3472385f6375496d61676544656d6f2e676966)

# 4. UCQCloud
1、文件上传(带上传进度)

- 支持软件面板拖放、选择文件(任意二进制文件)上传
- 支持状态栏粘贴板图片上传
- 支持状态栏拖放文件上传
2、图片高质量压缩

- 本地图片上传使用Tinypng在线高质量无损压缩
- 粘贴板图片上传使用开源库pngquant压缩
- 正常情况压缩节省50%以上空间,大幅提高博客图片加载速度，节约网盘存储空间。
3、上传历史记录管理
- 文件预览查看，删除，拷贝上传外链地址等

4、支持文件夹批量处理
- 直接拖入文件夹，或文件批量处理

作者：huluo666
链接：https://www.jianshu.com/p/694dad59f20c
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。


![](http://7xr7vj.com1.z0.glb.clouddn.com/%E7%B2%98%E8%B4%B4%E6%9D%BF%E4%B8%8A%E4%BC%A0.gif)
![](https://upload-images.jianshu.io/upload_images/328273-2ff220978053e895.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700)

# 5. ipic
图床神器 iPic 可自动上传图片、保存 Markdown 链接，给你前所未有的插图体验。

- 上传前压缩图片
- 通过拖拽上传图片
- 通过服务上传图片 [Command + U…

![](http://p394yuy0c.bkt.clouddn.com/20180128190724_D3rHNM_Screen%20Shot%202018-01-28%20at%207.06.56%20PM.jpeg)

# 6. 参考文献
- [iPic - 图床神器](https://toolinbox.net/iPic/)
- [Mac七牛图床与文件批量上传工具: UCQCloud1.3.3](https://www.jianshu.com/p/694dad59f20c)
- [cuImage - 图床利器](https://github.com/hulizhen/cuImage)