---
title: Android在Android.mk里添加TAG
date: 2019-12-31 15:55:09
tags:
---
1.定义：
system/core/include/log/log.h

``` C
#ifndef ALOGE
#define ALOGE(...) ((void)ALOG(LOG_ERROR, LOG_TAG, __VA_ARGS__))
#endif

//注意：LOG_TAG即我们添加的TAG,在Makefile或者Android.mk里写成: DLOG_TAG
```

2.Android.mk里添加TAG: xxx-test

``` Makefile
LOCAL_CFLAGS := -DLOG_TAG=\"xxx-test\"
```
