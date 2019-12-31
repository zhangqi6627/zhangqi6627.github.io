---
title: Android重启framework命令及framework.jar引用
date: 2019-12-31 15:28:47
tags:
---
1、重启framwork命令

``` bash
# adb shell start //启动framework
# adb shell stop //停止framework
or
# adb shell am restart //重启framework
# adb shell am kill-all //杀死后台所有进程
# adb shell am force-stop 包名 //强杀进程

//参考
am start [options] <INTENT>	启动Activity	startActivityAsUser
am startservice <INTENT>	启动Service	startService
am stopservice <INTENT>	停止Service	stopService
am broadcast <INTENT>	发送广播	broadcastIntent
am kill <PACKAGE>	杀指定后台进程	killBackgroundProcesses
am kill-all	杀所有后台进程	killAllBackgroundProcesses
am force-stop <PACKAGE>	强杀进程	forceStopPackage
am hang	系统卡住	hang
am restart	重启	restart
am bug-report	创建bugreport	requestBugReport
am dumpheap <pid> <file>	进程pid的堆信息输出到file	dumpheap
am send-trim-memory <pid><level>	收紧进程的内存	setProcessMemoryTrimLevel
am monitor	监控	MyActivityController.run
```

2、Eclipse等IDE可以导入classes.jar直接引用
路径：out\target\common\obj\JAVA_LIBRARIES\framework_intermediates/classes.jar 