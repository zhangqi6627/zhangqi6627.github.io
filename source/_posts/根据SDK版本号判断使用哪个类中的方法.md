---
title: 根据SDK版本号判断使用哪个类中的方法
date: 2017-09-22 09:56:15
tags:
---
``` Java
class MethodInLowSdk{
    public static void aMethod();
}
class MethodInHighSdk{
    public static void aMethod();
}

void callAMethodByVersion(){
    if(android.os.Build.VERSION.SDK_INT > low_sdk){
        MethodInHighSdk.aMethod();
    }else{
        MethodInLowSdk.aMethod();
    }
}
```