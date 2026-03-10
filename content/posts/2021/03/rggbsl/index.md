---
title: "网页分享到微信添加缩略图"
date: "2021-03-23 10:53:15"
draft: false
---
header部分
```html
<meta property="og:image" content="http://abc.cc/x.jpg" />
```

body部分

```html
<div style="display:none">
        <img src="http://abc.cc/x.jpg">
</div>
```

注意，图片的连接，必须是绝对地址。就是格式必需以http开头的地址，不能用相对地址，否则缩略图不会显示。

