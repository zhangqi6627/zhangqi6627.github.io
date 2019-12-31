---
title: Android写log到文件模版
date: 2019-12-31 15:56:28
tags:
---
1.实现

``` Java
public String LOG_FILE_NAME = "/mnt/sdcard/test_01.log";

private String getTimeString() {
    java.util.Date now= new Date();
    java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yy-MM-dd HH:mm:ss.sss");
    String rlt = formatter.format(now);
    return rlt;
}

private void saveLog( String log) {
    try {
        OutputStream os=new FileOutputStream(LOG_FILE_NAME, true);
        os.write(log.getBytes());
        os.flush();
        os.close();
    }catch(Exception ex){
        ex.printStackTrace();
    }
}

private void writeLog(String out) {
    String log = getTimeString()+":    "+out+"\n";
    saveLog(log);
}
```

2.测试

``` Java
String str = "123456";
String log = str;
writeLog(log);
```
