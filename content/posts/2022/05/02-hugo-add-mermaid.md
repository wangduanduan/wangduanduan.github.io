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

# step1

在themes/YourTheme/layouts/partials/footer.html 的最后追加如下内容

```html
{{if .Store.Get "hasMermaid" }}
  <script type="module">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.esm.min.mjs';
    mermaid.initialize({ startOnLoad: true });
  </script>
{{end }}
```

# step2:

在layouts/_default/_markup/render-codeblock-mermaid.html

```html
<pre class="mermaid">
    {{- .Inner | htmlEscape | safeHTML }}
</pre>
{{ .Page.Store.Set "hasMermaid" true }}
```

# 在blog中增加如下代码


```mermaid
pie
    title French Words I Know
    "Merde" : 50
    "Oui" : 35
    "Alors" : 10
    "Non" : 5
```

```mermaid
sequenceDiagram
    title French Words I Know
    autonumber
    Alice->>Bob: hello
    Bob-->>Alice: hi
    Alice->Bob: talking
```