---
title: 在刷机之后Camera有可能会消失
date: 2017-09-25 15:02:46
tags:
---
packages/apps/Camera/src/com/android/camera/DisableCameraReceiver.java     文件中有
``` Java
public void onReceive(Context context, Intent intent) {
    boolean needCameraActivity = FeatureSwitcher.isOnlyCheckBackCamera() ? hasBackCamera() : hasCamera();
    if (!needCameraActivity) {
        for (int i = 0; i < ACTIVITIES.length; i++) {
            //private static final String ACTIVITIES[] = {"com.android.camera.CameraLauncher", "com.android.camera.VideoCamera", "com.android.camera.Camera"};
            disableComponent(context, ACTIVITIES[i]);                        //这里接收到广播之后会将相机全都屏蔽掉
        }
    }
    disableComponent(context, "com.android.camera.DisableCameraReceiver");    //
}
```

``` xml
<receiver android:name="com.android.camera.DisableCameraReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />        //在开机之后就会注册这个广播接收器，为什么有的时候不会消失？？？
    </intent-filter>
</receiver>
```