---
title: 解析assets文件夹下的xml文件
date: 2017-09-22 10:47:01
tags:
---
``` Java
SAXParserFactory.newInstance().newSAXParser().parse(getResources().getAssets().open("apns-conf.xml"), apnHandler);
```