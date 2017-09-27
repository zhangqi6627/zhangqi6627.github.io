---
title: 第一次插卡弹出apn对话框
date: 2017-09-22 10:42:23
tags:
---

### 方法a:跳转
``` Java
//单卡的时候跳转到ApnSettings
Intent intent = new Intent();
intent.setComponent(new ComponentName("com.android.settings", "com.android.settings.ApnSettings"));
intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
startActivity(intent);
```
``` Java
//双卡的时候跳转到MultipleSimActivity
Intent intent = new Intent();
intent.setComponent(new ComponentName("com.android.phone", "com.mediatek.settings.MultipleSimActivity"));		//这里注意前面的包名，应该写manifest.xml中的报名，而不是Activity中的包名
intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
startActivity(intent);
```

### 方法b:在Launcher.java中的dataDialog的onDismissListener()中调用showApnDialog()
``` Java
private void showApnDialog(){
    AlertDialog.Builder builder = new AlertDialog.Builder(Launcher.this);
    builder.setTitle("APN Config");
    builder.setMessage("The default APN Config maybe incorrect, whether reselect?");
    builder.setPositiveButton("yes",new DialogInterface.OnClickListener(){
        @Override
        public void onClick(DialogInterface dialog,int which){
            Intent intent = new Intent();
            intent.setClassName("com.android.phone", "com.android.phone.MobileNetworkSettings");
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        }
    });
    builder.setNegativeButton("no",null);
    builder.create().show();
}
```