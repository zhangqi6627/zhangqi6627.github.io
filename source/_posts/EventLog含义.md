---
title: EventLog含义
date: 2018-03-02 13:33:11
tags:
---
本文转载自gityuan:http://gityuan.com/2016/05/15/event-log/

1、手机设备连接电脑

2、执行命令:
```
adb shell
```

3、执行命令:
```
cat /system/etc/event-log-tags
```
通过上面的3步骤，即可查看Event所有的tags



抓取Events log命令:
```
adb logcat -v threadtime -t 4096 -b events
```
该命令会输出带有时间点、进程号等信息的events log。


下面列举tag可能使用的部分场景:
```
am_low_memory:位于AMS.killAllBackgroundProcesses或者AMS.appDiedLocked，记录当前Lru进程队列长度。
am_pss:位于AMS.recordPssSampleLocked(
am_meminfo:位于AMS.dumpApplicationMemoryUsage
am_proc_start:位于AMS.startProcessLocked，启动进程
am_proc_bound:位于AMS.attachApplicationLocked
am_kill: 位于ProcessRecord.kill，杀掉进程
am_anr: 位于AMS.appNotResponding
am_crash:位于AMS.handleApplicationCrashInner
am_wtf:位于AMS.handleApplicationWtf
am_activity_launch_time:位于ActivityRecord.reportLaunchTimeLocked()，后面两个参数分别是thisTime和 totalTime.
am_activity_fully_drawn_time:位于ActivityRecord.reportFullyDrawnLocked, 后面两个参数分别是thisTime和 totalTime
am_broadcast_discard_filter:位于BroadcastQueue.logBroadcastReceiverDiscardLocked
am_broadcast_discard_app:位于BroadcastQueue.logBroadcastReceiverDiscardLocked
```

Activity生命周期相关的方法:
```
am_on_resume_called: 位于AT.performResumeActivity
am_on_paused_called: 位于AT.performPauseActivity, performDestroyActivity
am_resume_activity: 位于AS.resumeTopActivityInnerLocked
am_pause_activity: 位于AS.startPausingLocked
am_finish_activity: 位于AS.finishActivityLocked, removeHistoryRecordsForAppLocked
am_destroy_activity: 位于AS.destroyActivityLocked
am_focused_activity: 位于AMS.setFocusedActivityLocked, clearFocusedActivity
am_restart_activity: 位于ASS.realStartActivityLocked
am_create_activity: 位于ASS.startActivityUncheckedLocked
am_new_intent: 位于ASS.startActivityUncheckedLocked
am_task_to_front: 位于AS.moveTaskToFrontLocked
```

下面列举tag可能使用的部分场景:
```
power_sleep_requested: 位于PMS.goToSleepNoUpdateLocked
power_screen_state:位于Notifer.handleEarlyInteractiveChange, handleLateInteractiveChange

battery_level: [19,3660,352] //剩余电量19%, 电池电压3.66v, 电池温度35.2℃
power_screen_state: [0,3,0,0] // 灭屏状态(0), 屏幕超时(3). 当然还有其他设备管理策略(1),其他理由都为用户行为(2)
power_screen_state: [1,0,0,0] // 亮屏状态(1)
```


补充:
```
am_proc_start (User|1|5),(PID|1|5),(UID|1|5),(Process Name|3),(Type|3),(Component|3)

am_proc_start:[0,9227,10002,com.android.browser,contentprovider,com.android.browser/.provider.BrowserProvider2]

(User|1|5) ==> 名字为User, 数据类型为1，数据单位为5)
```

>数据类型:
1: int
2: long
3: string
4: list

---

>数据单位:
1: Number of objects(对象个数)
2: Number of bytes(字节数)
3: Number of milliseconds(毫秒)
4: Number of allocations(分配个数)
5: Id、6: Percent(百分比)

---

>举例:
进程启动: UserId=0, pid=9227, uid=10002, ProcessName=com.android.browser, 数据类型=ContentProvider, 组件=com.android.browser/.provider.BrowserProvider2