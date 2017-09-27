---
title: 预置了PDFViewer之后会报错
date: 2017-09-22 10:28:20
tags:
---
报错log如下:
```
12-01 11:26:14.609: E/AndroidRuntime(4918): FATAL EXCEPTION: main
12-01 11:26:14.609: E/AndroidRuntime(4918): Process: com.google.android.apps.pdfviewer, PID: 4918
12-01 11:26:14.609: E/AndroidRuntime(4918): java.lang.UnsatisfiedLinkError: Couldn't load foxit from loader dalvik.system.PathClassLoader[DexPathList[[zip file "/system/app/Pdfviewer.apk"],nativeLibraryDirectories=[/vendor/lib, /system/lib]]]: findLibrary returned null
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at java.lang.Runtime.loadLibrary(Runtime.java:365)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at java.lang.System.loadLibrary(System.java:553)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at com.google.android.apps.viewer.pdflib.PdfDocument.loadLibfoxit(PdfDocument.java:169)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at com.google.android.apps.viewer.pdflib.PdfDocumentService.onBind(PdfDocumentService.java:29)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at android.app.ActivityThread.handleBindService(ActivityThread.java:2757)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at android.app.ActivityThread.access$1900(ActivityThread.java:151)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1408)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at android.os.Handler.dispatchMessage(Handler.java:110)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at android.os.Looper.loop(Looper.java:193)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at android.app.ActivityThread.main(ActivityThread.java:5299)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at java.lang.reflect.Method.invokeNative(Native Method)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at java.lang.reflect.Method.invoke(Method.java:515)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:825)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:641)
12-01 11:26:14.609: E/AndroidRuntime(4918): 	at dalvik.system.NativeStart.main(Native Method)
```

需要将PDFViewer中的lib库提取出来，编译进去
``` Makefile
include $(CLEAR_VARS)
LOCAL_MODULE := libLCEFgenerator
LOCAL_SRC_FILES := libs/libLCEFgenerator.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(PRODUCT_OUT)/system/lib
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libLCEFnativeU
LOCAL_SRC_FILES := libs/libLCEFnativeU.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(PRODUCT_OUT)/system/lib
include $(BUILD_PREBUILT)
```