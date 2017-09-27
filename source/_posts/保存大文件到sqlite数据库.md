---
title: 保存大文件到sqlite数据库
date: 2017-09-22 13:20:16
tags:
---
``` Java
ContentValues contentValues = new ContentValues();
InputStream is = getResources().openRawResource(rid);
int bufSize = 63 * 1024;
byte[] buffer = new byte[bufSize];
try{
    int size = is.read(buffer);
    while(size > = 0){
        ByteArrayOutputStream out = new ByteArrayOutputStream(size);
        out.write(buffer,0,size);
        out.flush();
        out.close();
        contentValues.put("song_mp3",out.toByteArray());
        db.insert(mySong,null,contentValues);
        size = is.read(buffer);
    }
}catch(Exception e){
    e.printStackTrace();
}
```