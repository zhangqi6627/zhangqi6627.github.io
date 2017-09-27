---
title: 修改SIMToolkit的显示名称
date: 2017-09-25 15:29:07
tags:
---
//frameworks/opt/telephony/src/java/com/android/internal/telephony/cat/CommandParamsFactory.java
``` Java
CatLog.d(this, "add AlphaId: " + menu.title);
android.os.SystemProperties.set("gsm.zhangqi.stkmenu", menu.title);        //添加这一行代码将 menu.title
```
保存到 build.prop 文件中，注意这里需要将键值修改为 gsm 开头，参照system/core/init/property_service.c文件

//frameworks/base/core/java/android/app/ApplicationPackageManager.java
``` Java
if(packageName.equalsIgnoreCase("com.android.stk")) {
    String tmptext = android.os.SystemProperties.get("gsm.sim.operator.alpha");
    String numeric = android.os.SystemProperties.get("gsm.sim.operator.numeric");
    if(numeric != null && numeric.equalsIgnoreCase("28405") && tmptext != null && !tmptext.isEmpty() ){
        text = android.os.SystemProperties.get("gsm.zhangqi.stkmenu");            //添加一个判断
        if(text == null || text.toString().isEmpty()){
            if(tmptext.toLowerCase().contains("telenor")){
                text = "Telenor";
            }else if(tmptext.toLowerCase().contains("globul")){
                text = "My Globul";
            }
        }
    }
}
```

//mediatek/packages/apps/Stk1/src/com/android/stk/StkMenuInstance.java
``` Java
String alpha = android.os.SystemProperties.get("gsm.sim.operator.alpha");
String numeric = android.os.SystemProperties.get("gsm.sim.operator.numeric");
String title = android.os.SystemProperties.get("gsm.zhangqi.stkmenu");            //添加一个判断
if(title == null || title.isEmpty()){
    if(numeric != null && numeric.equalsIgnoreCase("28405") && alpha != null && !alpha.isEmpty() ){
        if(alpha.toLowerCase().contains("telenor")){
            textView.setText("Telenor");
        }else if(alpha.toLowerCase().contains("globul")){
            textView.setText("My Globul");
        }
    }
}
```