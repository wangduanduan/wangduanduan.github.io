---
title: "Hugo Timezone没有设置， 导致页面无法渲染"
date: "2022-09-03 10:20:48"
draft: false
---

写好了博客，但是没有在网页上渲染出来，岂不是很气人！


我的archtypes/default.md配置如下

```markdown
---
title: "{{ replace .Name "-" " " | title }}"
date: "{{ now.Format "2006-01-02 15:04:05" }}"
draft: false
---
```

当使用 `hugo new` 创建一个文章的时候，有如下的头

```markdown
---
title: "01: 学习建议"
date: "2022-09-03 10:23:10"
draft: false
---
```

Hugo 默认采用的是 格林尼治平时 (GMT)，比北京时间 (UTC+8) 晚了 8 个小时，Hugo 在生成静态页面的时候，不会生成超过当前时间的文章。

如果把北京时间当作格林尼治时间来计算，那么肯定还没有超过当前时间。

所以我们要给站点设置时区。

在config.yaml增加如下内容

```yaml
timeZone: "Asia/Shanghai"
```