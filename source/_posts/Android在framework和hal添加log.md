---
title: Android在framework和hal添加log
date: 2019-12-31 15:39:07
tags:
---
1.在Android.mk添加

``` Makefile
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_C_INCLUDES:= $(LOCAL_PATH)/include
LOCAL_SRC_FILES:= test.c
LOCAL_MODULE := libtest
LOCAL_SHARED_LIBRARIES:= libcutils libutils     ## 添加对应的库
LOCAL_MODULE_TAGS := optional
```

2.在test.c中添加

``` C
#include <utils/Log.h>
#define LOG_TAG “test”

ALOGE(“xxx—————> %s(), %d\n",__FUNCTION__,__LINE__);
```
