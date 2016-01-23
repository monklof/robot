robot
=====
一切都基于你的兴趣：一个智能的信息推荐机器人

它只做一件事情: 挖掘用户常逛的网站信息，智能计算用户感兴趣的内容，呈现给用户阅读。

## 功能

1. 获取信息来源: 抓取各内容产生网站的站点数据
2. 数据挖掘: 根据用户兴趣爱好挖掘用户感兴趣的文章
3. 超棒的阅读体验: Inbox一样的体验。只关注需要关注的内容。

## 设计稿

![](http://7xqevh.com1.z0.glb.clouddn.com/robot-robot-design.png)

## 里程碑

1. *v0.1.0*: 实现web端(前后端), 只做信息展示
2. *v0.1.1*: 实现1-2个网站的抓取逻辑, 配合web端，做到能每日推荐
3. *v0.1.2*: 实现web端的done/dislike/mark功能
4. *v0.1.3*: 实现推荐算法

### 第一步计划

#### Web页面

[@monklof][mk]

目标: 2月5号之前实现一个基本的Web服务。
涉及模块: HTTP API Server & Front End(Web)模块。

#### 抓取服务

[@frostpeng][frost]

目标: 1月31号完成第一版基础的爬虫开发（针对 ruby-china.com 和 v2ex.com）。
涉及模块: Web Spider

#### 推荐算法

[@lyerox][lyx]

目标: 1月31号对实现方式做一些简单的调研，弄明白推荐的基本原理，和涉及的知识调研，能给出接下来一个较长阶段内的方向。
涉及模块: Data Minging Robot

## 贡献者

* [@frostpeng][frost]
* [@lyerox][lyx]
* [@monklof][mk]

[frost]: https://github.com/frostpeng
[lyx]: https://github.com/lyerox
[mk]: https://github.com/monklof



