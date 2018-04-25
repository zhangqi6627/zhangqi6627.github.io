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
adb reboot bootloader     //重启到bootloader，即刷机模式
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

录屏
```
adb shell screenrecord /sdcard/demo.mp4 
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

打印xys标签log adb logcat -s xys
打印192.168.56.101:5555设备里的xys标签log adb -s 192.168.56.101:5555 logcat -s xys
打印在ActivityManager标签里包含start的日志 adb logcat -s ActivityManager | findstr "START"
“-s”选项 : 设置输出日志的标签, 只显示该标签的日志;
“-f”选项 : 将日志输出到文件, 默认输出到标准输出流中, -f 参数执行不成功;
“-r”选项 : 按照每千字节输出日志, 需要 -f 参数, 不过这个命令没有执行成功;
“-n”选项 : 设置日志输出的最大数目, 需要 -r 参数, 这个执行 感觉 跟 adb logcat 效果一样;
“-v”选项 : 设置日志的输出格式, 注意只能设置一项;
“-c”选项 : 清空所有的日志缓存信息;
“-d”选项 : 将缓存的日志输出到屏幕上, 并且不会阻塞;
“-t”选项 : 输出最近的几行日志, 输出完退出, 不阻塞;
“-g”选项 : 查看日志缓冲区信息;
“-b”选项 : 加载一个日志缓冲区, 默认是 main, 下面详解;
“-B”选项 : 以二进制形式输出日志;

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
adb shell dumpsys power 查看Power信息
```

获取CPU信息
```
adb shell cat /proc/cpuinfo
```

查看wifi密码
```
adb shell cat /data/misc/wifi/*.conf
```


查看节点信息
```
查看节点值，例如:cat /sys/class/leds/lcd-backlight/brightness
修改节点值，例如:echo 128 > sys/class/leds/lcd-backlight/brightness

LPM: 	   echo N > /sys/modue/lpm_levels/parameters/sleep_disabled
亮度:		 /sys/class/leds/lcd-backlight/brightness
CPU:       /sys/devices/system/cpu/cpu0/cpufreq
GPU:       /sys/class/ kgsl/kgsl-3d0/gpuclk
限频:      cat /data/pmlist.config
电流:      cat /sys/class/power_supply/battery/current_now
查看Power: dumpsys power
WIFI:      data/misc/wifi/wpa_supplicant.conf
持有wake_lock: echo a> sys/power/wake_lock
释放wake_lock:echo a> sys/power/wake_unlock
查看Wakeup_source: cat sys/kernel/debug/wakeup_sources
Display(关闭AD):mv /data/misc/display/calib.cfg /data/misc/display/calib.cfg.bak 重启
关闭cabc:echo 0 > /sys/device/virtual/graphics/fb0/cabc_onoff
打开cabc:echo 3 > /sys/device/virtual/graphics/fb0/cabc_onoff
systrace:sdk/tools/monitor
限频:echo /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1497600
当出现read-only 且 remount命令不管用时:adb shell mount -o rw,remount /
进入9008模式: adb reboot edl
查看高通gpio:sys/class/private/tlmm 或者 sys/private/tlmm
查看gpio占用情况:sys/kernle/debug/gpio
```

其他一些常用命令
```
获取序列号: adb get-serialno
安装apk到sd卡: adb install -s <apkfile> // 比如:adb install -s baidu.apk
获取机器MAC地址 adb shell cat /sys/class/net/wlan0/address
查看占用内存排序 adb shell top
查看占用内存前6的app:adb shell top -m 6
刷新一次内存信息，然后返回:adb shell top -n 1
查询各进程内存使用情况:adb shell procrank
查看指定进程状态:adb shell ps -x [PID]
查看后台services信息: adb shell service list
查看当前内存占用: adb shell cat /proc/meminfo
查看IO内存分区:adb shell cat /proc/iomem
查看wifi密码:adb shell cat /data/misc/wifi/*.conf
清除log缓存:adb logcat -c
查看bug报告:adb bugreport
跑monkey:adb -s 192.168.244.151:5555 shell monkey -v -p com.bolexim 500
```