---
title: Android判断某个点是否在View的区域内
date: 2019-12-31 14:40:02
tags:
---
``` Java
private boolean isInViewArea(View view, float x, float y) {
    Log.e(MainActivity.class.getName(), "x " + x + "y " + y);
    Rect r = new Rect();
    view.getLocalVisibleRect(r);
    Log.e(MainActivity.class.getName(), "left " + r.left + "right " + r.right);
    if (x > r.left && x < r.right && y > r.top && y < r.bottom) {
        return true;
    }
    return false;
}
```