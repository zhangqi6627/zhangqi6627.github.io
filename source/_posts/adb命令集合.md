---
title: adb命令集合
date: 2017-09-21 16:40:22
tags:
---
关机命令
``` bash
adb shell reboot -p
adb shell svc power shutdown
```

重启命令
``` bash
adb reboot
adb reboot recovery
adb reboot bootloader
```

恢复出厂设置
``` bash
adb shell am broadcast -a android.intent.action.MASTER_CLEAR
```

启动 Activity
``` bash
adb shell am start -n com.google.android.setupwizard/com.google.android.setupwizard.WalledGardenActivity
```

查看手机中安装的所有apk的包名
``` bash
adb shell pm list packages [-f] [-d] [-e] [-s] [-3] [-i] [-u] [--user USER_ID] [FILTER]
无	所有应用
-f	显示应用关联的 apk 文件
-d	只显示 disabled 的应用
-e	只显示 enabled 的应用
-s	只显示系统应用
-3	只显示第三方应用
-i	显示应用的 installer
-u	包含已卸载应用
<FILTER>	包名包含 <FILTER> 字符串
```

保存读取SettingsProvider中的值
``` bash
adb shell settings put global device_provisioned 0
adb shell settings get global device_provisioned
```

通过命令行输入字符串
``` bash
adb shell input text "helloworld"
```

通过adb命令直接操作sqlite3数据库
``` bash
adb shell sqlite3 /data/data/com.android.launcher3/databases/launcher.db "select * from favorites;"
adb shell sqlite3 /data/data/com.android.launcher3/databases/launcher.db ".dump" > sql.txt
```

通过adb命令快速查看关机动画
``` bash
adb shell setprop ctl.start bootanim
adb shell setprop ctl.stop bootanim
```
Monkey测试
``` bash
adb shell monkey -s 6516 --throttle 200 --ignore-crashes --ignore-timeouts --ignore-security-exceptions -v 20000000 > result.txt
```

查看IMEI码
``` bash
adb shell service call iphonesubinfo 1
```

查看手机型号
``` bash
adb shell getprop ro.product.model
```

查看Android系统版本
``` bash
adb shell getprop ro.build.version.release
```

清除应用数据与缓存
``` bash
adb shell pm clear <packagename>
```

wm(WindowManager)
``` bash
查看设备分辨率
adb shell wm size

修改屏幕密度为240dpi
adb shell wm density 240

重置屏幕密度为默认密度
adb shell wm density reset
```

截屏
``` bash
adb exec-out screencap -p > sc.png
```

在指定设备上安装apk
``` bash
adb -s 设备名称 install xxx.apk
```

SeLinux相关
```
查看selinux权限 enforcing permissive
adb shell getenforce
设置为permissive 如果为1则为enforcing
adb shell setenforce 0
```

Logcat相关
```
adb logcat -f /sdcard/aaa.txt	//将log输出到手机sdcard下的aaa.txt文件中
adb logcat -v time>log.txt //打印时间信息的log
adb logcat -v process/tag/thread/raw/time/long //设置日志输出格式控制字段
adb logcat -f /sdcard/aaa.txt //将log输出到手机sdcard下的aaa.txt文件中
adb logcat -c && adb logcat //logcat 有缓存，如果仅需要查看当前开始的 log，需要清空之前的
adb logcat -b events/main/crash/radio/all //加载一个可使用的日志缓冲区供查看
adb bugreport > xxx.log  
```

dumpsys
```
adb shell dumpsys window displays |head -n 5
adb shell dumpsys meminfo 显示内存信息
adb shell dumpsys cpuinfo 显示CPU信息
adb shell dumpsys account 显示accounts信息
adb shell dumpsys activity 显示所有的activities的信息
adb shell dumpsys window 显示键盘，窗口和它们的关系
adb shell dumpsys wifi 显示wifi信息
```

获取CPU信息
```
adb shell cat /proc/cpuinfo
```

查看wifi密码
```
adb shell cat /data/misc/wifi/*.conf
```