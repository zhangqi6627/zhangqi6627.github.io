---
title: 关闭NavigationBar
date: 2017-09-22 12:54:57
tags:
---
[FAQ04788](https://online.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ04788)
### KK及之前版本:
默认Navigation Bar的控制在 alps/frameworks/base/core/res/res/values/config.xml文件中<bool name="config_showNavigationBar">true</bool>， 但是在6589项目以及6572等项目上修改为false不起作用，或者默认已经是false，但是还是会显示navigation Bar。
 
MT6589 和MT6572:
1. 在6589项目和6572项目上，MTK内部Demo Project有Navigation Bar的需求，因此通过Resource Overlay机制默认打开了Navigation Bar，如果要关闭，需要确认resource overlay部分是否也有定义，具体如下:
alps/mediatek/custom/project_name/resource_overlay/generic/frameworks/base/core/res/res/values/config.xml
``` Xml
<bool name="config_showNavigationBar">true</bool>
```
将这个配置信息修改为false即可。
 
2. MT6572:如果上面的xml文件定义都是false，请再确认下mediatek/config/工程名字的目录/system.prop 是否有qemu.hw.mainkeys=0,如果有，请去掉qemu.hw.mainkeys=0的定义
3. JB3 MP之后所有版本统一如下路径修改
\mediatek\custom\common\resource_overlay\navbar\frameworks\base\core\res\res\values\config.xml
``` xml
<bool name="config_showNavigationBar">true</bool>
```
将这个配置信息修改为false即可。 

4. 其他平台或者branch都可以类似查找，以上都找不到，请全局搜索config_showNavigationBar

### L和M版本:

这个两个版本的修改方式与之前的版本也是类似:

1. 先查看config_showNavigationBar值的定义，默认定义在:alps/frameworks/base/core/res/res/values/config.xml，如果没有请全局搜索。

2. 再检查qemu.hw.mainkeys值的设置。

3. 是否显示Navigation Bar，判断的值在PhoneWindowManager.java文件中的setInitialDisplaySize 函数中被设置，检查mHasNavigationBar的值是如何被设置的。如果mHasNavigationBar为true，Navigation Bar会显示，否则不显示。