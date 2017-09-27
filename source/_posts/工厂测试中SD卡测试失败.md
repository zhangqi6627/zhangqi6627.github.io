---
title: 工厂测试中SD卡测试失败
date: 2017-09-21 12:56:08
tags:
---
SD项测试失败log如下
```
01-01 00:11:49.832: I/SDCardTest(3240): Write fail
01-01 00:11:49.832: I/SDCardTest(3240): java.io.IOException: open failed: EACCES (Permission denied)
01-01 00:11:49.832: I/SDCardTest(3240): 	at java.io.File.createNewFile(File.java:950)
01-01 00:11:49.832: I/SDCardTest(3240): 	at com.example.factorydevelopx.SDCardTest.testWrite(SDCardTest.java:269)
01-01 00:11:49.832: I/SDCardTest(3240): 	at com.example.factorydevelopx.SDCardTest.sdCardSwap(SDCardTest.java:96)
01-01 00:11:49.832: I/SDCardTest(3240): 	at com.example.factorydevelopx.SDCardTest.onCreate(SDCardTest.java:71)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.Activity.performCreate(Activity.java:5264)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.Instrumentation.callActivityOnCreate(Instrumentation.java:1088)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:2302)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:2390)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.ActivityThread.access$800(ActivityThread.java:151)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1321)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.os.Handler.dispatchMessage(Handler.java:110)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.os.Looper.loop(Looper.java:193)
01-01 00:11:49.832: I/SDCardTest(3240): 	at android.app.ActivityThread.main(ActivityThread.java:5299)
01-01 00:11:49.832: I/SDCardTest(3240): 	at java.lang.reflect.Method.invokeNative(Native Method)
01-01 00:11:49.832: I/SDCardTest(3240): 	at java.lang.reflect.Method.invoke(Method.java:515)
01-01 00:11:49.832: I/SDCardTest(3240): 	at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:825)
01-01 00:11:49.832: I/SDCardTest(3240): 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:641)
01-01 00:11:49.832: I/SDCardTest(3240): 	at dalvik.system.NativeStart.main(Native Method)
01-01 00:11:49.832: I/SDCardTest(3240): Caused by: libcore.io.ErrnoException: open failed: EACCES (Permission denied)
01-01 00:11:49.832: I/SDCardTest(3240): 	at libcore.io.Posix.open(Native Method)
01-01 00:11:49.832: I/SDCardTest(3240): 	at libcore.io.BlockGuardOs.open(BlockGuardOs.java:110)
01-01 00:11:49.832: I/SDCardTest(3240): 	at java.io.File.createNewFile(File.java:943)
01-01 00:11:49.832: I/SDCardTest(3240): 	... 17 more
01-01 00:11:49.833: I/SDCardTest(3240): file read fial
01-01 00:11:49.897: I/SDCardTest(3240): Write pass
01-01 00:11:49.975: I/SDCardTest(3240): file.delete psaa
```
需要在 alps/packages/apps/FactoryDevelopX/AndroidManifest.xml 文件中添加权限
``` xml
<uses-permission android:name="android.permission.WRITE_MEDIA_STORAGE" />
```
不需要在 alps/packages/apps/FactoryDevelopX/Android.mk 文件中添加
```
LOCAL_PRIVILEGED_MODULE := true
```