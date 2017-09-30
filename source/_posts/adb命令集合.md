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

恢复出厂设置
``` bash
adb shell am broadcast -a android.intent.action.MASTER_CLEAR
```

查看手机中安装的所有apk的包名
``` bash
adb shell pm -l
```

保存读取SettingsProvider中的值
``` bash
adb shell settings put global device_provisioned 0
adb shell settings get global device_provisioned
```

启动 Activity
``` bash
adb shell am start -n com.google.android.setupwizard/com.google.android.setupwizard.WalledGardenActivity
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