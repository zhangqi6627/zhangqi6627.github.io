---
title: Java显示调用堆栈的几种方法
date: 2019-12-31 14:37:16
tags:
---
``` Java
Log.w(TAG, "stack", new Exception());

Log.d(TAG, Log.getStackTraceString(new Throwable()));

Log.e(TAG, Thread.currentThread().getStackTrace()[2].getClassName()+"-->"+Thread.currentThread().getStackTrace()[2].getMethodName()+"()-->"+Thread.currentThread().getStackTrace()[2].getLineNumber());

try {
    Object mObject = null;
    mObject.toString();
} catch (Exception e) {
    e.printStackTrace();
    android.util.Log.e("zhangqi8888", "NPE:" + e, e);
}
```