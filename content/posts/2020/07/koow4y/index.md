---
title: "使用image标签上传日志"
date: "2020-07-06 14:55:12"
draft: false
---
```javascript
function report(msg:string){
	var msg = new Image()
  msg.src = `/report?log=${msg}`
}

report
```

