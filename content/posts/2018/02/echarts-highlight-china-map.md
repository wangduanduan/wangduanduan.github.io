---
title: ECharts 轮流高亮中国地图各个省份
date: 2018-02-09 13:16:53
tags:
- echarts
---

# 1. 小栗子

![](https://wdd.js.org/img/images/20180209131759_k10o0Z_bVVWEB.jpeg)

最早我是想通过`dispatchAction`方法去改变选中的省份，但是没有起作用，如果你知道这个方法怎么实现，麻烦你可以告诉我。
我实现的方法是另外一种。

```
dispatchAction({
    type: 'geoSelect',
    // 可选，系列 index，可以是一个数组指定多个系列
    seriesIndex?: number|Array,
    // 可选，系列名称，可以是一个数组指定多个系列
    seriesName?: string|Array,
    // 数据的 index，如果不指定也可以通过 name 属性根据名称指定数据
    dataIndex?: number,
    // 可选，数据名称，在有 dataIndex 的时候忽略
    name?: string
})
```

后来我改变了一个方法。这个方法的核心思路是定时获取图标的配置，然后更新配置，最后在设置配置。
```
var myChart = echarts.init(document.getElementById('china-map'));

var COLORS = ["#070093", "#1c3fbf", "#1482e5", "#70b4eb", "#b4e0f3", "#ffffff"];

// 指定图表的配置项和数据
var option = {
    tooltip: {
        trigger: 'item',
        formatter: '{b}'
    },
    series: [
        {
            name: '中国',
            type: 'map',
            mapType: 'china',
            selectedMode : 'single',
            label: {
                normal: {
                    show: true
                },
                emphasis: {
                    show: true
                }
            },
            data:[
                // 默认高亮安徽省
                {name:'安徽', selected:true}
            ],
            itemStyle: {
                normal: {
                    areaColor: 'rgba(255,255,255,0.5)',
                    color: '#000000',
                    shadowBlur: 200,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                },
                emphasis:{
                    areaColor: '#3be2fb',
                    color: '#000000',
                    shadowBlur: 200,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }
    ]
};

// 使用刚指定的配置项和数据显示图表。
myChart.setOption(option);

myChart.on('click', function(params) {
    console.log(params);
});

setInterval(function(){
    var op = myChart.getOption();
    var data = op.series[0].data;

    var length = data.length;

    data.some(function(item, index){
        if(item.selected){
            item.selected = false;
            var next = (index + 1)%length;
            data[next].selected = true;
            return true;
        }
    });

    myChart.setOption(op);

}, 3000);
```

# 2. 后续补充
我从这里发现：https://github.com/ecomfe/echarts/issues/3282，选中地图的写法是这样的，而试了一下果然可以。主要是type要是`mapSelect`,而不是`geoSelect`
```
myChart.dispatchAction({
    type: 'mapSelect',
    // 可选，系列 index，可以是一个数组指定多个系列
    // seriesIndex: 0,
    // 可选，系列名称，可以是一个数组指定多个系列
    // seriesName: string|Array,
    // 数据的 index，如果不指定也可以通过 name 属性根据名称指定数据
    // dataIndex: number,
    // 可选，数据名称，在有 dataIndex 的时候忽略
    name: '河北'
});
```

# 3. 哪里去下载中国地图？

官方示例里是没有中国地图的，不过你可以去github的官方仓库里找。地址是：https://github.com/apache/incubator-echarts/tree/master/map

![](https://wdd.js.org/img/images/20180509112951_wNvh6u_Jietu20180509-112929.jpeg)

# 4. 地图学习的栗子哪里有？

## 4.1. 先学习一下美国地图怎么玩吧

echarts官方文档上有美国地图的实例，地址：http://echarts.baidu.com/examples/editor.html?c=map-usa

![](https://wdd.js.org/img/images/20180509113143_019h7i_Jietu20180509-113135.jpeg)

## 4.2. 我国地图也是有的，参考iphone销量这个栗子

地址：http://echarts.baidu.com/option.html#series-map, 注意：`地图的相关文档在series->type:map中`

![](https://wdd.js.org/img/images/20180509113253_Y1hJI4_Jietu20180509-113227.jpeg)


