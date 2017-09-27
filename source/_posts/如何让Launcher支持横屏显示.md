---
title: 如何让Launcher支持横屏显示
date: 2017-09-21 16:21:27
tags:
---
[FAQ15487](https://onlinesso.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ15487)

N/M:
Launcher默认支持横屏显示，只需要按如下操作即可开启横屏显示：
桌面空白处长按→进入OverviewMode→点击设置→打开允许旋转的开关

L:
* 1.修改AndroidManifest.xml
``` xml
<activity
    android:name="com.android.launcher3.Launcher"
    android:launchMode="singleTask"
    android:clearTaskOnLaunch="true"
    android:stateNotNeeded="true"
    android:theme="@style/Theme"
    android:configChanges="mcc|mnc"
    android:windowSoftInputMode="adjustPan"
    android:screenOrientation="sensor"> <!--modify to sensor -->
```
 
* 2.修改Utilities.java的isRotationEnabled方法
``` Java
public static boolean isRotationEnabled(Context c) {
    return true;//直接返回true
}
```
 
此时旋转手机，Launcher会横竖屏切换。但hotseat会显示在屏幕的右方。如果要让hotseat显示在屏幕底部，可以按照如下步骤操作:
 
* 3.修改res/values/config.xml
``` xml
<!--hotseat -->
<bool name="hotseat_transpose_layout_with_orientation">false</bool> <!--改为false-->
```
 
* 4.修改Hotseat.java的onFinishInflate方法
``` Java
@Override
protected void onFinishInflate() {
    super.onFinishInflate();
    LauncherAppState app = LauncherAppState.getInstance();
    DeviceProfile grid = app.getDynamicGrid().getDeviceProfile();
    mAllAppsButtonRank = grid.hotseatAllAppsRank;
    mContent = (CellLayout) findViewById(R.id.layout);
    if (grid.isLandscape && !grid.isLargeTablet()) {
        mContent.setGridSize((int) grid.numHotseatIcons, 1); //modify
    } else {
        mContent.setGridSize((int) grid.numHotseatIcons, 1);
    }
    mContent.setIsHotseat(true);
    Log.i(TAG, "onFinishInflate,(int) grid.numHotseatIcons: " + (int) grid.numHotseatIcons);
    resetLayout();
}
```