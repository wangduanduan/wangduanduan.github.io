---
title: "python request 库学习"
date: "2019-07-12 11:21:23"
draft: false
---

# 上传文件

```bash
import requests

headers = {
    "ssid":"1234"
}

files = {'file': open('yourfile.tar.gz', 'rb')}
url="http://localhost:1345/fileUpload/"

r = requests.post(url, files=files, headers=headers)

print(r.status_code)
```


