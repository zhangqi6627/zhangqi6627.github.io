---
title: 根据控件的ID名称获取控件的ID值
date: 2017-09-21 13:10:29
tags:
---
frameworks/base/core/java/android/app/Activity.java
``` Java
private View findViewByName(String name){
    return findViewById(getResources().getIdentifier(name, "id", getPackageName()));
}

private View findViewByName(View parent, String name){
    return parent.findViewById(getResources().getIdentifier(name, "id", getPackageName()));
}
```
具体用法如下
``` Java
View setting_autodownload_layout = findViewByName("setting_autodownload_layout");
```