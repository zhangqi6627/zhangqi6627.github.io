---
title: 在framework下添加字体和使用方法
date: 2018-03-26 14:58:38
tags:
---
1.将需要添加的ttf字体文件放在 frameworks/base/data/fonts/ 目录

A:frameworks/base/data/fonts/clock_thin.ttf

2.修改 frameworks/base/data/fonts/Android.mk 文件,将字体文件编译到 system/fonts/ 目录中

M:frameworks/base/data/fonts/Android.mk
font_src_files := \
    AndroidClock.ttf \
    clock_thin.ttf

3.修改 frameworks/base/data/fonts/fonts.mk 文件

M:frameworks/base/data/fonts/fonts.mk
PRODUCT_PACKAGES := \
    DroidSansMono.ttf \
    AndroidClock.ttf \
    clock_thin.ttf \
    fonts.xml

4.在 fonts.xml 文件中定义字体对应的名称

M:frameworks/base/data/fonts/fonts.xml
``` xml
<family name="clock-font">
    <font weight="400" style="normal">clock_thin.ttf</font>
</family>
```

5.使用新添加的字体

方法1:
``` Java
TextView textView = new TextView(mContext);
textView.setTypeface(android.graphics.Typeface.createFromFile("/system/fonts/clock_thin.ttf"));
```

方法2:
``` Xml
<TextView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:fontFamily="clock-font" />
```

6.在项目中的具体使用实例----Bug124982 修改桌面时钟widget的字体

M:alps/frameworks/base/core/java/android/widget/RemoteViews.java
``` Java
public class RemoteViews implements Parcelable, Filter {
    ...
    private class TextViewSizeAction extends Action {
        ...
        @Override
        public void apply(View root, ViewGroup rootParent, OnClickHandler handler) {
            final TextView target = root.findViewById(viewId);
            if (target == null) return;

            //通过特殊约定的参数(如77,0)来特殊设置TextView的字体
            if(units == -77 && size == 0f){
                target.setTypeface(android.graphics.Typeface.createFromFile("/system/fonts/clock_thin.ttf"));
            }else{
                target.setTextSize(units, size);
            }
            //Redmine124982 zhangqi modified for clock widget font 2018/03/23:end
        }
        ...
    }
    ...
}
```

M:alps/vendor/mediatek/proprietary/packages/apps/DeskClock/src/com/android/alarmclock/DigitalAppWidgetProvider.java
``` Java
public class DigitalAppWidgetProvider extends AppWidgetProvider {
    private static RemoteViews relayoutWidget(Context context, AppWidgetManager wm, int widgetId, Bundle options, boolean portrait) {
        final String packageName = context.getPackageName();
        final RemoteViews rv = new RemoteViews(packageName, R.layout.digital_widget);
        //通过特殊约定的参数(如77,0)来特殊设置TextView的字体,这里调用setTextViewTextSize方法就会调用RemoteViews的内部类TextViewSizeAction的apply方法
        rv.setTextViewTextSize(R.id.clock, -77, 0f);
        ...
    }
    ...
}
```