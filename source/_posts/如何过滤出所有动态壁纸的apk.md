---
title: 如何过滤出所有动态壁纸的apk
date: 2017-09-22 13:58:49
tags:
---
``` Java
public static final String SERVICE_INTERFACE = "android.service.wallpaper.WallpaperService";
List<ResolveInfo> list = mPackageManager.queryIntentServices(new Intent(WallpaperService.SERVICE_INTERFACE), PackageManager.GET_META_DATA);
```