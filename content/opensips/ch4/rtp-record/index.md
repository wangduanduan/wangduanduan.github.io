---
title: "rtpproxy录音"
date: "2020-05-14 16:13:10"
draft: false
---
```bash
-a -R -r /recording -S spool -P
```

- -a 所有的通话都录音
- -R 不要把RTCP也写文件
- -r  指定录音文件的位置
- -S 临时文件的位置，注意不要和录音文件位置相同
- -P 录成pcap文件的格式，而不要录成默认的 Ad-hoc的模式

