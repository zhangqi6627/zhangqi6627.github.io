---
title: Android打开/关闭wifi命令
date: 2019-12-31 15:34:17
tags:
---
1.切换root权限

``` bash
adb root; adb remount
```

2.关闭wifi

``` bash
adb shell svc wifi disable
```

3.打开wifi

``` bash
adb shell svc wifi enable
```
