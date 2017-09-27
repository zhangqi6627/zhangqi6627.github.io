---
title: sqlite rawQuery() 方法怎么用
date: 2017-09-22 10:45:52
tags:
---
``` Java
Cursor cursor = database.rawQuery("select count(*) from contacts;", null);
cursor.moveToFirst();		//这里必须要加上这句话，否则会报错
int count = cursor.getInt(0);
```