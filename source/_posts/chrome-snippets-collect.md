---
title: 谷歌浏览器： Snippets小程序哪家强？
date: 2018-02-07 13:48:55
tags:
- snippets
---

> Snippets是可以在Chrome DevTools的“源”面板中创建和执行的小脚本。 您可以从任何页面访问和运行它们。 当您运行代码段时，它会从当前打开的页面的上下文执行。

# 1. 显示所有元素的边框，看页面布局非常方便
![](/images/20180207135027_4TAe1P_Screenshot.jpeg)

```
[].forEach.call($$("*"),function(a){
  a.style.outline="1px solid #"+(~~(Math.random()*(1<<24))).toString(16)
});
```

# 2. allcolors.js
> 从页面上的元素中使用的计算样式打印所有颜色。 使用样式化的console.log调用来可视化每种颜色。

![](/images/20180207135046_bfEqm5_Screenshot.jpeg)
```
// allcolors.js
// https://github.com/bgrins/devtools-snippets
// Print out CSS colors used in elements on the page.

(function () {
  // Should include colors from elements that have a border color but have a zero width?
  var includeBorderColorsWithZeroWidth = false;

  var allColors = {};
  var props = ["background-color", "color", "border-top-color", "border-right-color", "border-bottom-color", "border-left-color"];
  var skipColors = {
    "rgb(0, 0, 0)": 1,
    "rgba(0, 0, 0, 0)": 1,
    "rgb(255, 255, 255)": 1
  };

  [].forEach.call(document.querySelectorAll("*"), function (node) {
    var nodeColors = {};
    props.forEach(function (prop) {
      var color = window.getComputedStyle(node, null).getPropertyValue(prop),
        thisIsABorderProperty = (prop.indexOf("border") != -1),
        notBorderZero = thisIsABorderProperty ? window.getComputedStyle(node, null).getPropertyValue(prop.replace("color", "width")) !== "0px" : true,
        colorConditionsMet;

      if (includeBorderColorsWithZeroWidth) {
        colorConditionsMet = color && !skipColors[color];
      } else {
        colorConditionsMet = color && !skipColors[color] && notBorderZero;
      }

      if (colorConditionsMet) {
        if (!allColors[color]) {
          allColors[color] = {
            count: 0,
            nodes: []
          };
        }

        if (!nodeColors[color]) {
          allColors[color].count++;
          allColors[color].nodes.push(node);
        }

        nodeColors[color] = true;
      }
    });
  });

  function rgbTextToRgbArray(rgbText) {
    return rgbText.replace(/\s/g, "").match(/\d+,\d+,\d+/)[0].split(",").map(function(num) {
      return parseInt(num, 10);
    });
  }

  function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
  }

  function rgbToHex(rgbArray) {
    var r = rgbArray[0],
      g = rgbArray[1],
      b = rgbArray[2];
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
  }

  var allColorsSorted = [];
  for (var i in allColors) {
    var rgbArray = rgbTextToRgbArray(i);
    var hexValue = rgbToHex(rgbArray);

    allColorsSorted.push({
      key: i,
      value: allColors[i],
      hexValue: hexValue
    });
  }

  allColorsSorted = allColorsSorted.sort(function (a, b) {
    return b.value.count - a.value.count;
  });

  var nameStyle = "font-weight:normal;";
  var countStyle = "font-weight:bold;";
  function colorStyle(color) {
    return "background:" + color + ";color:" + color + ";border:1px solid #333;";
  };

  console.group("Total colors used in elements on the page: " + window.location.href + " are " + allColorsSorted.length);
  allColorsSorted.forEach(function (c) {
    console.groupCollapsed("%c    %c " + c.key + " " + c.hexValue + " %c(" + c.value.count + " times)",
      colorStyle(c.key), nameStyle, countStyle);
    c.value.nodes.forEach(function (node) {
      console.log(node);
    });
    console.groupEnd();
  });
  console.groupEnd("All colors used in elements on the page");

})();
```

# 3. cachebuster.js
> 通过在href和src属性的末尾添加Date.now（）来覆盖所有链接和（可选）脚本标记。 默认情况下，不执行处理脚本，应将变量process_scripts更改为true以运行这些脚本。

![](/images/20180207135131_CvscRc_Screenshot.jpeg)

```
//Cache Buster
(function (){
  var rep = /.*\?.*/,
      links = document.getElementsByTagName('link'),
      scripts = document.getElementsByTagName('script'),
      process_scripts = false;
  for (var i=0;i<links.length;i++){
    var link = links[i],
        href = link.href;
    if(rep.test(href)){
      link.href = href+'&'+Date.now();
    }
    else{
      link.href = href+'?'+Date.now();
    }

  }
  if(process_scripts){
    for (var i=0;i<scripts.length;i++){
      var script = scripts[i],
          src = script.src;
      if(rep.test(src)){
        script.src = src+'&'+Date.now();
      }
      else{
        script.src = src+'?'+Date.now();
      }

    }
  }
})();
```

# 4. console-save.js
> 从控制台将对象保存为.json文件的简单方法包括一个chrome扩展和一个纯文本。
```
console.save(data, [filename])
```

![](/images/20180207135218_BG0kgp_Screenshot.jpeg)
```
(function(console){

    console.save = function(data, filename){

        if(!data) {
            console.error('Console.save: No data')
            return;
        }

        if(!filename) filename = 'console.json'

        if(typeof data === "object"){
            data = JSON.stringify(data, undefined, 4)
        }

        var blob = new Blob([data], {type: 'text/json'}),
            e    = document.createEvent('MouseEvents'),
            a    = document.createElement('a')

        a.download = filename
        a.href = window.URL.createObjectURL(blob)
        a.dataset.downloadurl =  ['text/json', a.download, a.href].join(':')
        e.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null)
        a.dispatchEvent(e)
    }
})(console)
```

# 5. formcontrols.js
> 在一个不错的表中显示所有html表单元素及其值和类型。 在页面上为每个表单添加一个新表

![](/images/20180207135247_mH2FW4_Screenshot.jpeg)
```
// formcontrols.js
// https://github.com/bgrins/devtools-snippets
// Print out forms and their controls

(function() {

  var forms = document.querySelectorAll("form");

  for (var i = 0, len = forms.length; i < len; i++) {
    var tab = [ ];

    console.group("HTMLForm quot;" + forms[i].name + "quot;: " + forms[i].action);
    console.log("Element:", forms[i], "\nName:    "+forms[i].name+"\nMethod:  "+forms[i].method.toUpperCase()+"\nAction:  "+forms[i].action || "null");

    ["input", "textarea", "select"].forEach(function (control) {
      [].forEach.call(forms[i].querySelectorAll(control), function (node) {
        tab.push({
          "Element": node,
          "Type": node.type,
          "Name": node.name,
          "Value": node.value,
          "Pretty Value": (isNaN(node.value) || node.value === "" ? node.value : parseFloat(node.value))
        });
      });
    });

    console.table(tab);
    console.groupEnd();
  }
})();
```

# 6. log-globals.js
> 打印全局变量

![](/images/20180207135302_NLgNKa_Screenshot.jpeg)
```
*
	log-globals
	by Sindre Sorhus
	https://github.com/sindresorhus/log-globals
	MIT License
*/
(function () {
	'use strict';

	function getIframe() {
		var el = document.createElement('iframe');
		el.style.display = 'none';
		document.body.appendChild(el);
		var win = el.contentWindow;
		document.body.removeChild(el);
		return win;
	}

	function detectGlobals() {
		var iframe = getIframe();
		var ret = Object.create(null);

		for (var prop in window) {
			if (!(prop in iframe)) {
				ret[prop] = window[prop];
			}
		}

		return ret;
	}

	console.log(detectGlobals());
})();
```

# 7. performance.js
> 打印有关window.performance对象的信息。 使用console.table和分组来组织信息。

![](/images/20180207135314_IhE6UI_Screenshot.jpeg)
```
// performance.js
// https://github.com/bgrins/devtools-snippets
// Print out window.performance information.
// https://developer.mozilla.org/en-US/docs/Navigation_timing

(function () {

  var t = window.performance.timing;
  var lt = window.chrome && window.chrome.loadTimes && window.chrome.loadTimes();
  var timings = [];

  timings.push({
    label: "Time Until Page Loaded",
    time: t.loadEventEnd - t.navigationStart + "ms"
  });
  timings.push({
    label: "Time Until DOMContentLoaded",
    time: t.domContentLoadedEventEnd - t.navigationStart + "ms"
  });
  timings.push({
    label: "Total Response Time",
    time: t.responseEnd - t.requestStart + "ms"
  });
  timings.push({
    label: "Connection",
    time: t.connectEnd - t.connectStart + "ms"
  });
  timings.push({
    label: "Response",
    time: t.responseEnd - t.responseStart + "ms"
  });
  timings.push({
    label: "Domain Lookup",
    time: t.domainLookupEnd - t.domainLookupStart + "ms"
  });
  timings.push({
    label: "Load Event",
    time: t.loadEventEnd - t.loadEventStart + "ms"
  });
  timings.push({
    label: "Unload Event",
    time: t.unloadEventEnd - t.unloadEventStart + "ms"
  });
  timings.push({
    label: "DOMContentLoaded Event",
    time: t.domContentLoadedEventEnd - t.domContentLoadedEventStart + "ms"
  });
  if(lt) {
    if(lt.wasNpnNegotiated) {
      timings.push({
        label: "NPN negotiation protocol",
        time: lt.npnNegotiatedProtocol
      });
    }
    timings.push({
      label: "Connection Info",
      time: lt.connectionInfo
    });
    timings.push({
      label: "First paint after Document load",
      time: Math.ceil(lt.firstPaintTime - lt.finishDocumentLoadTime) + "ms"
    });
  }

  var navigation = window.performance.navigation;
  var navigationTypes = { };
  navigationTypes[navigation.TYPE_NAVIGATENEXT || 0] = "Navigation started by clicking on a link, or entering the URL in the user agent's address bar, or form submission.",
  navigationTypes[navigation.TYPE_RELOAD] = "Navigation through the reload operation or the location.reload() method.",
  navigationTypes[navigation.TYPE_BACK_FORWARD] = "Navigation through a history traversal operation.",
  navigationTypes[navigation.TYPE_UNDEFINED] = "Navigation type is undefined.",

  console.group("window.performance");

  console.log(window.performance);

  console.group("Navigation Information");
  console.log(navigationTypes[navigation.type]);
  console.log("Number of redirects that have taken place: ", navigation.redirectCount)
  console.groupEnd("Navigation Information");

  console.group("Timing");
  console.log(window.performance.timing);
  console.table(timings, ["label", "time"]);
  console.groupEnd("Timing");

  console.groupEnd("window.performance");

})();
```


# 8. 更多有意思的：
- http://bgrins.github.io/devtools-snippets/

