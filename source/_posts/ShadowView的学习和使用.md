---
title: ShadowView的学习和使用
date: 2017-09-30 14:51:25
tags:
---
1.添加依赖库
```
dependencies {
    compile 'com.loopeer.lib:shadow:0.0.3'
}
```

2.使用
``` xml
<com.loopeer.shadow.ShadowView
    android:id="@+id/shadow_view"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="12dp"
    android:elevation="10dp"
    android:foreground="?attr/selectableItemBackground"
    android:onClick="onShadowClickTest"
    android:padding="10dp"
    app:cornerRadius="4dp"
    app:shadowMargin="20dp"
    app:shadowRadius="14dp">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Google Developer Days Europe 2017 took place in Krakow, Poland. In this playlist, you can find all the recorded sessions from the event, across all tracks (Develop on Mobile, Mobile Web, Beyond Mobile, and Android)."/>
</com.loopeer.shadow.ShadowView>
```

3.常用属性
```
android:foreground
shadowMargin
shadowMarginTop
shadowMarginLeft
shadowMarginRight
shadowMarginBottom
cornerRadius
cornerRadiusTL
cornerRadiusTR
cornerRadiusBL
cornerRadiusBR
foregroundColor
shadowColor
shadowDx
shadowDy
shadowRadius
backgroundColor
```