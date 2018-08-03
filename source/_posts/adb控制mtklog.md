---
title: adb控制mtklog
date: 2018-08-03 09:21:20
tags:
---
### 1、显示MTKLogger主界面
```
adb shell am start -n com.mediatek.mtklogger/com.mediatek.mtklogger.MainActivity
```
查看当前界面包名类名：
```
adb shell "dumpsys activity top |grep ACTIVITY"
```

### 2、通过命令启动
```
a.启动全部log打印：adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name start --ei cmd_target 23
4个log打印：
1:MobileLog     (00001)
2:ModemLog      (00010)
3:NetworkLog    (00100)
4:GPSLog        (10000)

参数说明:23
1代表打开“1:MobileLog”；
2打开代表“2:ModemLog”；
3代表1和2一起打开；
4代表打开“3:NetworkLog”
5代表打开1和3；
6代表打开2和3；
7代表打开123；
23代表启动1234  ？？？不是15吗？

b.关闭LOG打印：同上命令和说明，把start换成stop就好了
```

### 3、设置参数功能：
1开启关闭Tag Log，勾选：
```
开启：adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name switch_taglog --ei cmd_target 1
关闭：adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name switch_taglog --ei cmd_target 0
```

Trigger taglog:
```
adb shell am broadcast -a com.mediatek.log2server.EXCEPTION_HAPPEND -e path SaveLogManually -e db_filename yourInputTagName
```

### 4、获取开关状态
```
adb shell getprop debug.MB.running
adb shell getprop debug.mdlogger.Running
adb shell getprop debug.mtklog.netlog.Running
```

### 5、修改log存储路径
```
adb shell setprop persist.mtklog.log2sd.path logpath
JB版本前logpath为：
/mnt/sdcard 内置sd卡
/mnt/sdcard2 外置sd卡
需要做stop/start MTKLogger才能生效
JB版本后logpath为：
internal_sd 内置sd卡
external_sd 外置sd卡
```

### 6、显示MTKLogger主界面
```
adb shell am start -n
com.mediatek.mtklogger/com.mediatek.mtklogger.MainActivity
```

### 7. Taglog开启/关闭
```
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name switch_taglog --ei cmd_target 0/1   //(0表示关，1表示开)
```

### 8、切换Mdlog录制模式为USB/SD/Passive Log to SD
```
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name switch_modem_log_mode --ei cmd_target 1/2/3     //(1表示USB模式，2表示SD模式, 3表示Passive Log to SD模式)
M:
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name
switch_modem_log_mode_mode --ei cmd_target mdtype
Mode = 1/2/3 -> Usb/sd/pst
Mdtype = 1, 3 -> md1/md3
```

### 9、开机自启动开启/关闭
```
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name set_auto_start_1/set_auto_start_0 --ei cmd_target 23 （set_auto_start_1表示开启开机自启动，set_auto_start_0表示关闭开机自启动；
23可改为1/2/4/16，分别代表MobileLog/ModemLog/NetworkLog/GPSLog）
```

### 10、设置Limit Current Log Size （JB版本以后生效）
```
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name set_log_size_300 --ei cmd_target 7 （set_log_size_300 可更改为其他合适值如set_log_size_600

7可改为1/2/4，分别代表MobileLog/ModemLog/NetworkLog）
```

### 11、设置Mobile Limit Total Log Size （JB版本以后生效）
```
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name set_total_log_size_600 --ei cmd_target 1
set_total_log_size_600 可更改为其他合适值如set_total_log_size_1200； 最后一位1不可更改，因为只有mobile log有此功能
```