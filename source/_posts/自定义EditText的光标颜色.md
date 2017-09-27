---
title: 自定义EditText的光标颜色
date: 2017-09-21 13:36:32
tags:
---
### 方法一、通过XML文件设置
TextView 有一个属性 android:textCursorDrawable，这个属性是用来控制光标颜色的
android:textCursorDrawable="@null"，"@null"作用是让光标颜色和text color一样

也可以自定义游标的颜色
color_cursor.xml
``` xml
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <size android:width="1dp" />
    <solid android:color="#008000" />
</shape>
```
使用如下:
``` xml
<EditText android:textCursorDrawable="@drawable/color_cursor" />
```

方法二、通过代码设置
遗憾的是 TextView 默认没有设置游标颜色的方法
在 TextView.java 中找到
``` Java
    case com.android.internal.R.styleable.TextView_textCursorDrawable:
        mCursorDrawableRes = a.getResourceId(attr, 0);
        break;
        ...
int mCursorDrawableRes;     //这个值是不可以被直接访问的
```

于是就想到可以使用反射来设置游标的颜色
``` Java
try {
    Field f = TextView.class.getDeclaredField("mCursorDrawableRes");
    f.setAccessible(true);
    f.set(editText, R.drawable.cursor_color);
} catch (Exception ignored) {
}
```

也可以使用如下封装好的方法
``` Java
private void setTextCursorColor(TextView et, int color){
    try {
        java.lang.reflect.Field fCursorDrawableRes = TextView.class.getDeclaredField("mCursorDrawableRes");
        fCursorDrawableRes.setAccessible(true);
        int mCursorDrawableRes = fCursorDrawableRes.getInt(et);
        java.lang.reflect.Field fEditor = TextView.class.getDeclaredField("mEditor");
        fEditor.setAccessible(true);
        Object editor = fEditor.get(et);
        Class<?> clazz = editor.getClass();
        java.lang.reflect.Field fCursorDrawable = clazz.getDeclaredField("mCursorDrawable");
        fCursorDrawable.setAccessible(true);
        android.graphics.drawable.Drawable[] drawables = new android.graphics.drawable.Drawable[1];
        drawables[0] = et.getContext().getResources().getDrawable(mCursorDrawableRes);
        drawables[0].setColorFilter(color, android.graphics.PorterDuff.Mode.SRC_IN);
        fCursorDrawable.set(editor, drawables);
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```