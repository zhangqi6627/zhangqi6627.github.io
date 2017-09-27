---
title: support_features
date: 2017-09-21 17:10:05
tags:
---
1.关闭 PackageManager.FEATURE_TOUCHSCREEN 支持，
A) System Feature
PackageManager pm = getPackageManager();
pm.hasSystemFeature(PackageManager.FEATURE_TOUCHSCREEN)
It returns ‘TRUE’ on the test device which is NOT correct, It should return TOUCHSCREEN_NOTOUCH, TOUCHSCREEN_UNDEFINED, or TOUCHSCREEN_STYLUS
客户反馈说Facebook检测到我们的非触屏手机M2414中有 PackageManager.FEATURE_TOUCHSCREEN 属性，现在需要去掉该属性

解决：
a. PackageManager.hasSystemFeature() 源码分析
alps/frameworks/base/core/java/android/content/pm/PackageManager.java
alps/frameworks/base/services/java/com/android/server/pm/PackageManagerService.java
跟踪代码发现 hasSystemFeature(feature) 方法只要在 mAvailableFeatures 里面包含对应的 feature 就会返回true
所有的 feature 的加载是在 private void readPermissionsFromXml(File permFile) { }
void readPermissions() {} 这个方法会读取 "etc/permissions" 目录下的所有文件中的 feature 属性

通过下面这段代码可以查看手机支持的所有feature
``` Java
android.content.pm.FeatureInfo[] featureInfos = getPackageManager().getSystemAvailableFeatures();
for(android.content.pm.FeatureInfo featureInfo : featureInfos){
    android.util.Log.e("zhangqi8888", "DialpadFragment->featureInfo:"+featureInfo.toString());
}
```

b. 通过 adb shell 查看 etc/permissions 目录下的所有文件，包括
...
/system/etc/permissions/handheld_core_hardware.xml
/system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml
/system/etc/permissions/android.hardware.touchscreen.multitouch.xml
/system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml
/system/etc/permissions/android.hardware.touchscreen.xml
在以上几个文件中都能找到 <feature name="android.hardware.touchscreen" />

c. 通过在 alps/ 目录下搜索文件 find . -name "android.hardware.touchscreen"，找到在如下一些文件
frameworks/native/data/etc/handheld_core_hardware.xml
frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml
frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml
frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml
frameworks/native/data/etc/android.hardware.touchscreen.xml
mediatek/config/sr72_w_kk/android.hardware.touchscreen.xml

这些文件在 mediatek/frameworks-ext/native/etc/sensor_touch_permission.mk 文件中编译拷贝到 /system/etc/下面，代码如下
``` Makefile
#touch related file for CTS
ifeq ($(strip $(CUSTOM_KERNEL_TOUCHPANEL)),generic)
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml
else
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml
endif
```

在 ProjectConfig.mk 文件中查看 CUSTOM_KERNEL_TOUCHPANEL 这个宏里面没有值
#touch driver need to report correct touch axes
CUSTOM_KERNEL_TOUCHPANEL=

d. 最终修改
frameworks/native/data/etc/handheld_core_hardware.xml
frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml
frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml
frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml
frameworks/native/data/etc/android.hardware.touchscreen.xml
mediatek/config/sr72_w_kk/android.hardware.touchscreen.xml
把以上几个文件中 <feature name="android.hardware.touchscreen" /> 的相关属性都注释掉

e. 有何影响
通过搜索发现只在 WindowManagerService.java 文件中有使用这个属性
alps/frameworks/base/services/java/com/android/server/wm/WindowManagerService.java
``` Java
mIsTouchDevice = mContext.getPackageManager().hasSystemFeature(PackageManager.FEATURE_TOUCHSCREEN);
if (mIsTouchDevice) {
    if ((sources & InputDevice.SOURCE_TOUCHSCREEN) == InputDevice.SOURCE_TOUCHSCREEN) {
        config.touchscreen = Configuration.TOUCHSCREEN_FINGER;
    }
}
```
改了之后，只是不会走上面这段代码把 touchscreen 设置为 TOUCHSCREEN_FINGER，而通过调试发现修改之前 touchscreen 也是 TOUCHSCREEN_NOTOUCH，所以不会有影响

2.
B) Configuration.touchscreen
``` Java
Configuration config = getResources().getConfiguration();
config.touchscreen
```
it returns TOUCHSCREEN_NOTOUCH on the test device, which should be correct. Please make sure it will return NOTOUCH in future.

解决方案：
默认就是 TOUCHSCREEN_NOTOUCH，无需修改

3.
C) Configuration.keyboard
config.keyboard
it returns KEYBOARD_NOKEYS on the test device which is NOT correct. 
It should return KEYBOARD_12KEY

解决方案：
alps/frameworks/base/services/java/com/android/server/wm/WindowManagerService.java
``` Java
boolean computeScreenConfigurationLocked(Configuration config) {
    ......
    //zhangqi modified begin
    if (device.getKeyboardType() == InputDevice.KEYBOARD_TYPE_ALPHABETIC) {
        config.keyboard = Configuration.KEYBOARD_QWERTY;
        keyboardPresence |= presenceFlag;
    }else if(device.getKeyboardType() == InputDevice.KEYBOARD_TYPE_NON_ALPHABETIC){
        config.keyboard = Configuration.KEYBOARD_12KEY;     //配置成 KEYBOARD_12KEY
    }
    //zhangqi modified end
    ......
}
```