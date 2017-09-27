---
title: 如何让EditText不自动获取焦点
date: 2017-09-25 14:56:43
tags:
---
在 EditText 的父控件中添加如下代码即可
``` xml
android:focusable="true"  
android:focusableInTouchMode="true"
```
例如：
``` xml
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:focusable="true"            //看这里
    android:focusableInTouchMode="true" //和这里
    android:orientation="horizontal" >
    <EditText
        android:id="@+id/et_keyword"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1" />

    <Button
        android:id="@+id/btn_search"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/search" />
</LinearLayout>
```