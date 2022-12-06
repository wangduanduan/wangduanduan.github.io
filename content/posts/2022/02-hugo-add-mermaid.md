---
title: "hugo博客增加mermaid 绘图插件"
date: 2022-05-27T11:49:44+08:00
#draft: true
tags:
- mermaid
- 流程图
categories:
- hugo
---

# 增加mermaid shortcodes

在themes/YourTheme/layouts/shortcodes/mermaid.html 增加如下内容

```html

<script async type="application/javascript" src="https://cdn.jsdelivr.net/npm/mermaid@9.1.1/dist/mermaid.min.js">
    var config = {
      startOnLoad:true,
      theme:'{{ if .Get "theme" }}{{ .Get "theme" }}{{ else }}dark{{ end }}',
      align:'{{ if .Get "align" }}{{ .Get "align" }}{{ else }}center{{ end }}'
    };
    mermaid.initialize(config);
  </script>
  
  <div class="mermaid">
    {{.Inner}}
  </div>

```

# 在blog中增加如下代码

{{< notice warning >}}
注意下面的代码，你在实际写的时候，要把 /* 和 */ 删除
{{< /notice >}}

```go
{{/*< mermaid align="left" theme="neutral" */>}}
pie
    title French Words I Know
    "Merde" : 50
    "Oui" : 35
    "Alors" : 10
    "Non" : 5
{{/*< /mermaid >*/}}
```

{{< mermaid align="left" theme="neutral" >}}
pie
    title French Words I Know
    "Merde" : 50
    "Oui" : 35
    "Alors" : 10
    "Non" : 5
{{< /mermaid >}}

{{< mermaid align="left" theme="neutral" >}}
sequenceDiagram
    title French Words I Know
    autonumber
    Alice->>Bob: hello
    Bob-->>Alice: hi
    Alice->Bob: talking
{{< /mermaid >}}