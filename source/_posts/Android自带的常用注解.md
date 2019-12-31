---
title: Android自带的常用注解
date: 2019-12-31 14:52:06
tags:
---
1、在注释中实现链接跳转

``` Java
/**
 * ... ...
 * @see #invalidate()
 * @see #postInvalidateDelayed(long)
 */
```

2、限定参数类型

``` Java
TextView.setTextColor(@ColorInt int color);
```

3、限定参数类型及范围

``` Java
TimePicker.setHour(@IntRange(from = 0, to = 23) int hour)

public static class ByteArray {
    private @IntRange(from = 0) int mSize;
}

public class TextView ...{
    @FloatRange(from = 0.0, to = 1.0)
    private float getHorizontalFadingEdgeStrength(float position1, float position2) {
        final int horizontalFadingEdgeLength = getHorizontalFadingEdgeLength();
        if (horizontalFadingEdgeLength == 0) return 0.0f;
        final float diff = Math.abs(position1 - position2);
        if (diff > horizontalFadingEdgeLength) return 1.0f;
        return diff / horizontalFadingEdgeLength;
    }
}
```