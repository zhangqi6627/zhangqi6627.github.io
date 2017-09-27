---
title: 添加代码禁用GoogleCamera
date: 2017-09-22 13:50:36
tags:
---
``` Java
在RestoreRotationReceiver.java添加如下代码即可
public void onReceive(Context context, Intent intent) {
    String action = intent.getAction();
    Log.v("RestoreRotationReceiver_IPO", action);
    if (action.equals(Intent.ACTION_BOOT_COMPLETED)|| action.equals("android.intent.action.ACTION_BOOT_IPO")) {
        try{
            context.getPackageManager().setApplicationEnabledSetting("com.google.android.GoogleCamera",android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_DISABLED,android.content.pm.PackageManager.DONT_KILL_APP);
        }catch(Exception e){
            e.printStackTrace();
        }
    ...
    }
}
```