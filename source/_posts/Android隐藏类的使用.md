---
title: Android隐藏类的使用
date: 2019-12-31 15:30:45
tags:
---
1. 首先查找源码，找到了IWindowManager.aidl文件，将源码按照相同的路径在自己的工程中创建
注:eclipse工程必须有此步骤, 而Android源码编译的话不需要此步骤.
Sample 1:

``` Java
IWindowManager  windowMger；
try{
   Object object = new Object();
   Method getService = Class.forName("android.os.ServiceManager").getMethod("getService", String.class);
   Object obj = getService.invoke(object, new Object[]{new String("window")});
   windowMger = IWindowManager.Stub.asInterface((IBinder)obj);
}catch(ClassNotFoundException ex){
}catch(NoSuchMethodException ex){
}catch(IllegalAccessException ex){
}catch(InvocationTargetException ex){
}
```

Sample 2:

``` Java
import android.os.ServiceManager;
ITelephony.Stub.asInterface(ServiceManager.getService("phone")).answerRingingCall();
```
