---
title: 定时器学习：利用定时器分解耗时任务案例
date: 2018-02-08 14:09:54
tags:
- setTimeout
---

对于执行时间过长的脚本，有的浏览器会弹出警告，说页面无响应。有的浏览器会直接终止脚本。总而言之，浏览器不希望某一个代码块长时间处于运行状态，因为js是单线程的。一个代码块长时间运行，将会导致其他任何任务都必须等待。从用户体验上来说，很有可能发生页面渲染卡顿或者点击事件无响应的状态。

> 如果一段脚本的运行时间超过5秒，有些浏览器（比如Firefox和Opera）将弹出一个对话框警告用户该脚本“无法响应”。而其他浏览器，比如iPhone上的浏览器，将默认终止运行时间超过5秒钟的脚本。--《JavaScript忍者秘籍》

JavaScript忍者秘籍里有个很好的比喻：页面上发生的各种事情就好像一群人在讨论事情，如果有个人一直在说个不停，其他人肯定不乐意。我们希望有个裁判，定时的切换其他人来说话。

Js利用定时器来分解任务，关键点有两个。

1. 按什么维度去分解任务

2. 任务的现场保存与现场恢复

# 1. 例子
要求：动态创建一个表格，一共10000行，每行10个单元格

## 1.1. 一次性创建
```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title></title>
</head>
<body>

<table>
	<tbody></tbody>
</table>

<script type="text/javascript">
	var tbody = document.getElementsByTagName('tbody')[0];

	var allLines = 10000;
	// 每次渲染的行数

	console.time('wd');
	for(var i=0; i<allLines; i++){
		var tr = document.createElement('tr');

		for(var j=0; j<10; j++){
			var td = document.createElement('td');

			td.appendChild(document.createTextNode(i+','+j));
			tr.appendChild(td);
		}

		tbody.appendChild(tr);
	}
	console.timeEnd('wd');

</script>
</body>
</html>
```
`总共耗时180ms, 浏览器已经给出警告！[Violation] 'setTimeout' handler took 53ms`。

![](https://wdd.js.org/img/images/20180208141029_DSFYi3_Screenshot.jpeg)


## 1.2. 分批次动态创建
```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title></title>
</head>
<body>

<table>
	<tbody></tbody>
</table>

<script type="text/javascript">
	var tbody = document.getElementsByTagName('tbody')[0];

	var allLines = 10000;
	// 每次渲染的行数
	var everyTimeCreateLines = 80;
	// 当前行
	var currentLine = 0;

	setTimeout(function renderTable(){
		console.time('wd');
		for(var i=currentLine; i<currentLine+everyTimeCreateLines && i<allLines; i++){
			var tr = document.createElement('tr');

			for(var j=0; j<10; j++){
				var td = document.createElement('td');

				td.appendChild(document.createTextNode(i+','+j));
				tr.appendChild(td);
			}

			tbody.appendChild(tr);
		}
		console.timeEnd('wd');

		currentLine = i;

		if(currentLine < allLines){
			setTimeout(renderTable,0);
		}
	},0);

</script>
</body>
</html>
```
`这次异步按批次创建，没有耗时的警告。因为控制了每次代码在50ms内运行。实际上每80行耗时约10ms左右。这就不会引起页面卡顿等问题。`

![](https://wdd.js.org/img/images/20180208141052_DlS2x4_Screenshot.jpeg)


  [1]: /img/bVLoTq
  [2]: /img/bVLoUo