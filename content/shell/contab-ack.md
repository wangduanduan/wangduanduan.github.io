---
title: "Ack 在contab中无法查到关键词"
date: 2021-06-18
draft: true
tags:
- ack
- contab
---

手工执行，可以获得预期结果，但是在crontab中，却查不到结果。

```
stage_count=$(ack -h "\- name:" -t yaml | wc -l)
```

最终使用`--nofilter`参数，解决了问题。

```
stage_count=$(ack --nofilter -h "\- name:" -t yaml | wc -l)
```

参考
- https://stackoverflow.com/questions/55777520/ack-fails-in-cronjob-but-runs-fine-from-commandline

