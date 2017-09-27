---
title: 默认打开wifi热点
date: 2017-09-25 15:20:04
tags:
---
[FAQ10275](https://onlinesso.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ10275)怎样默认打开便携式WIFI热点 


//frameworks/base/services/java/com/android/server/wifi/WifiService.java
``` Java
public void checkAndStartSoftAp() {										//在 WifiService 中添加这个方法
    mWifiStateMachine.autoConnectInit();
    boolean isAirplaneModeOn = Settings.Global.getInt(mContext.getContentResolver(), Settings.Global.AIRPLANE_MODE_ON, 0) != 0;
    if (mWifiStateMachine.hasCustomizedAutoConnect() && isAirplaneModeOn) {
        SXlog.i(TAG, "Don't enable softAp when airplane mode is on for customization.");
    } else {
        Slog.i(TAG, "WifiService starting up with softAp");
        setWifiApEnabled(null, true);
    }
}
```

//frameworks/base/services/java/com/android/server/SystemServer.java
在 initAndLoop() 方法中将
``` Java
wifi.checkAndStartWifi();
```
替换为
``` Java
wifi.checkAndStartSoftAp();		//调用上面添加的方法
```