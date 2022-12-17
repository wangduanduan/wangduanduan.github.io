---
title: "influxdb时间精度到秒"
date: "2019-12-11 17:48:20"
draft: false
---

```makefile
var data = []

var t1 = [
    ["2019-12-11T09:13:06.078545239Z",153],
    ["2019-12-11T09:14:06.087484224Z",118],
    ["2019-12-11T09:15:07.723571286Z",198],
    ["2019-12-11T09:16:09.534879791Z",249],
]

var t2 = [
    ["2019-12-11T09:13:06Z",153],
    ["2019-12-11T09:14:06Z",118],
    ["2019-12-11T09:15:07Z",198],
    ["2019-12-11T09:16:09Z",249],
]

var data = t1.map(function(item){
    return {
        value: [item[0], item[1]]
    }
})

option = {
    title: {
        text: '动态数据 + 时间坐标轴'
    },
    tooltip: {
        trigger: 'axis'
    },
    xAxis: {
        type: 'time'
    },
    yAxis: {
        type: 'value'
    },
    series: [{
        name: '模拟数据',
        type: 'line',
        showSymbol: false,
        hoverAnimation: false,
        data: data
    }]
};
```

- 数据集t1时间精度到秒，并且带9位小数
- 数据集t2时间精确到秒，不带小数

t1的绘线出现往回拐，明显有问题。不知道这是不是echars的bug


解决方案，查询是设置epoch=s, 用unix秒数来格式化事件

