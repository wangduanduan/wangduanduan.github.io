---
title: "Windows安装Tesserocr"
date: "2024-04-24 08:34:07"
draft: false
type: posts
tags:
- tesserocr
categories:
- all
---

# 安装tesserocr-windows_build

到[tesserocr-windows_build release](tesserocr-windows_build)页面下载对应的whl文件

如下载 tesserocr-2.6.2-cp312-cp312-win_amd64.whl， 下载之后用pip安装

```
pip install tesserocr-2.6.2-cp312-cp312-win_amd64.whl
```

# 安装ocr windows exe程序

在这个页面，有对应的exe程序，https://digi.bib.uni-mannheim.de/tesseract/

例如下载这个exe文件 https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-v5.3.0.20221214.exe

下载完成之后点击安装，一般我们不需要修改他的安装位置，默认的安装位置是C:\Program Files\Tesseract-OCR

我们将C:\Program Files\Tesseract-OCR\tessdata下的所有文件，复制到C:\Program Files\Tesseract-OCR\目录下



# 参考
- https://github.com/simonflueckiger/tesserocr-windows_build/releases
- https://digi.bib.uni-mannheim.de/tesseract/
- https://tesseract-ocr.github.io/tessdoc/Downloads.html
- https://blog.csdn.net/Yuyh131/article/details/103880585