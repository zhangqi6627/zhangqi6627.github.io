---
title: Chronometer的学习和使用
date: 2017-10-11 09:45:28
tags:
---
### 1.布局
``` xml
<Chronometer
    android:id="@+id/text_timer"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_centerHorizontal="true"
    android:layout_marginTop="25dp"
    android:format="%s"
    android:textColor="#cccccc"
    android:textSize="30sp"
    android:textStyle="bold" />
```

接下来的使用更加方便，直接:
``` Java
// 将计时器清零
text_timer.setBase(SystemClock.elapsedRealtime());
//开始计时
text_timer.start();
```
但是会遇到一个问题，也是我们的高能环节:
在你调用stop的时候，计时暂停，然后在调用start的时候，会发现时间不是从暂停的那个点来开始的，而是你一共开始计时的时间。
这时候就要我们来解决这个问题了。
具体解决思路:

暂停的时候，记录当前的时间，在点击开始，start之前，要将你一共开始计时的时间  减去  暂停了的时间。
关键就在于这个暂停了多长时间，暂停的时间就是我们一共计时的时间 减去 当时暂停的时间。
明了。
上代码:
``` Java
case R.id.start_btn:
    if (mRecordTime != 0) {
        text_timer.setBase(text_timer.getBase() + (SystemClock.elapsedRealtime() - mRecordTime));
    } else {
        text_timer.setBase(SystemClock.elapsedRealtime());
    }
    text_timer.start();
    break;
case R.id.stop_btn:
    text_timer.stop();
    mRecordTime = SystemClock.elapsedRealtime();
    break;
```