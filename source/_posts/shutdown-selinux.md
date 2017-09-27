---
title: 如何设置确认selinux 模式
date: 2017-09-19 15:54:53
tags:
---
[Description]
linux SELinux 分成Enforce 以及 Permissive 两种模式，如何进行设置与确认当前SELinux模式？
 
[Keyword]
android, SELinux, Enforce, Permissive
 
[Solution]
在Android KK 4.4 版本后，Google 有正式有限制的启用SELinux, 来增强android 的安全保护。
在ENG 版本中, 可以使用setenforce 命令进行设置:
``` bash
adb shell setenforce 0    //设置成permissive 模式
adb shell setenforce 1    //设置成enforce 模式
```
 
在ENG/USER 版本中，都可以使用getenforce 命令进行查询，如：
``` bash
root@mt6589_phone_720pv2:/ # getenforce
getenforce
Enforcing
```
 
如果想开机一启动就设置模式，你可以用下面方式:
KK 版本:更新mediatek/custom/{platform}/lk/rules_platform.mk
L  版本: 更新bootable/bootloader/lk/platform/mt6xxx/rules.mk
M 版本: 更新vendor/mediatek/proprietary/bootable/bootloader/lk/platform/mt6XXX/rules.mk
choose one of following value -> 1: disabled/ 2: permissive /3: enforcing
SELINUX_STATUS := 3
可直接调整这个SELINUX_STATUS这个的值为2, 严禁直接设置成1:disabled, 此会造成生成的文件无法正确的打上标签,造成在再次设置成enforcing时，难以预料的情况发生。
 
注意的是:
在L 版本后, Google 要求强制性开启enforcing mode, 前面的设置只针对userdebug, eng 版本有效, 如果要对 user 版本有效,
需要修改 system/core/init/Android.mk
如果是 L 版本 新增:
```
ifeq ($(strip $(TARGET_BUILD_VARIANT)),user)
LOCAL_CFLAGS += -DALLOW_DISABLE_SELINUX=1
endif
```
 
如果是在 M 版本 将:
```
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
init_options += -DALLOW_LOCAL_PROP_OVERRIDE=1 -DALLOW_DISABLE_SELINUX=1
init_options += -DINIT_ENG_BUILD
else
```

修改成:
```
ifneq (,$(filter user userdebug eng,$(TARGET_BUILD_VARIANT)))
init_options += -DALLOW_LOCAL_PROP_OVERRIDE=1 -DALLOW_DISABLE_SELINUX=1
init_options += -DINIT_ENG_BUILD
else
```
 
需要注意的是, Google 要求强制性开启SELinux Enforcing Mode, 如果您关闭，将无法通过Google CTS. 
 
 
[相关FAQ]
[FAQ11486] [SELinux Policy] 如何设置SELinux 策略规则 ? 在Kernel Log 中出现"avc: denied" 要如何处理
https://online.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ11486
[FAQ11485] 权限(Permission denied)问题如何确认是Selinux 约束引起
https://online.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ11485
[FAQ11483] 如何快速Debug SELinux Policy 问题
https://online.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ11483