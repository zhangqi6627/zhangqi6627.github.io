---
title: root权限相关
date: 2018-03-08 12:49:31
tags:
---
android apk的root权限和USB adb权限的区别
 
[Keyword]
apk usb Superuser SuperSU root adb
 
[Solution]
USB adb 权限是指，当adb 连接手机时，手机中的守护进程adbd 的权限为root 权限，从而它的子进程也具有root 权限，通常如果adb shell 看到是:

Android 4.0 以后版本:
```
C:\Users\mtk71029\Desktop>adb shell
root@android:/ #
```
Android 2.3 版本:
```
C:\Users\mtk71029\Desktop>adb shell
#
```
即表明adb 的连接是root 权限的，相反如果看到是$ 即表明是shell 权限
Android 的APK 本身都是不具备root 权限的，如果想启用root 权限，那么就必须借助具有root 权限的进程或者具有s bit 的文件，目前比较通用的手法是，手机root 后，内置了su到system/bin, 然后普通APP 即可借助su 命令来达到root 权限切换。
网络上已经有同仁修改su 命令，并通过一个APK 来控制su 命令的权限控制。
如常见的Superuser: http://androidsu.com/superuser/ 这样即可人为的控制root 权限的使用。((因很久都没有更新了，只能用于ICS 以及以前的版本))
SuperSU: http://forum.xda-developers.com/showthread.php?t=1538053 (更新速度很快，推荐使用)
 
综上所叙，如果adb 已经有root 权限，那么让apk 行使root 权限就很简单了。比如:
```
adb remount
adb push su /system/bin
adb push Superuser.apk /system/app
adb shell chmod 0644 /system/app/Superuser.apk
adb shell chmod 6755 /system/bin/su
adb reboot
```