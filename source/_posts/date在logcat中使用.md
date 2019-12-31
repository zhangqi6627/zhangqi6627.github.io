---
title: date在logcat中使用
date: 2019-12-31 16:14:25
tags:
---
``` bash
adb logcat -s NetlinkEvent | tee $(date "+%Y:%m:%d-%H:%M:%S".log)
adb logcat | packages-$(date "+%Y-%m-%d-%H:%M:%S"-123.log)
```
