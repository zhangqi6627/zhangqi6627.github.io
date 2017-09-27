---
title: 如何在下载好图片之后更新Gallery
date: 2017-09-22 13:55:31
tags:
---
``` Java
sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(new File(savePath))));
```