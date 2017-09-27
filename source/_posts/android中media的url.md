---
title: android中media的url
date: 2017-09-21 12:52:17
tags:
---
```
http://site.com/image.png // from Web
file:///mnt/sdcard/image.png // from SD card
file:///mnt/sdcard/video.mp4 // from SD card (video thumbnail)
content://media/external/images/media/13 // from content provider
content://media/external/video/media/13 // from content provider (video thumbnail)
assets://image.png // from assets
drawable:// + R.drawable.img // from drawables (non-9patch images) //通常不用。
```