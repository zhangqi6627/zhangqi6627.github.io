---
title: ANR问题分析
date: 2018-04-11 10:41:59
tags:
---
# 如何去分析ANR
先看个LOG:
```
04-01 13:12:11.572 I/InputDispatcher( 220): Application is not responding:Window{2b263310com.android.email/com.android.email.activity.SplitScreenActivitypaused=false}.  5009.8ms since event, 5009.5ms since waitstarted
04-01 13:12:11.572 I/WindowManager( 220): Input event dispatching timedout sending tocom.android.email/com.android.email.activity.SplitScreenActivity
04-01 13:12:14.123 I/Process(  220): Sending signal. PID: 21404 SIG: 3---发生ANR的时间和生成trace.txt的时间
04-01 13:12:14.123 I/dalvikvm(21404):threadid=4: reacting to signal 3 
……
04-01 13:12:15.872 E/ActivityManager(  220): ANR in com.android.email(com.android.email/.activity.SplitScreenActivity)
04-01 13:12:15.872 E/ActivityManager(  220): Reason:keyDispatchingTimedOut
04-01 13:12:15.872 E/ActivityManager(  220): Load: 8.68 / 8.37 / 8.53
04-01 13:12:15.872 E/ActivityManager(  220): CPUusage from 4361ms to 699ms ago ----CPU在ANR发生前的使用情况

04-01 13:12:15.872 E/ActivityManager(  220):   5.5%21404/com.android.email: 1.3% user + 4.1% kernel / faults: 10 minor
04-01 13:12:15.872 E/ActivityManager(  220):   4.3%220/system_server: 2.7% user + 1.5% kernel / faults: 11 minor 2 major
04-01 13:12:15.872 E/ActivityManager(  220):   0.9%52/spi_qsd.0: 0% user + 0.9% kernel
04-01 13:12:15.872 E/ActivityManager(  220):   0.5%65/irq/170-cyttsp-: 0% user + 0.5% kernel
04-01 13:12:15.872 E/ActivityManager(  220):   0.5%296/com.android.systemui: 0.5% user + 0% kernel
04-01 13:12:15.872 E/ActivityManager(  220): 100%TOTAL: 4.8% user + 7.6% kernel + 87% iowait
04-01 13:12:15.872 E/ActivityManager(  220): CPUusage from 3697ms to 4223ms later:-- ANR后CPU的使用量
04-01 13:12:15.872 E/ActivityManager(  220):   25%21404/com.android.email: 25% user + 0% kernel / faults: 191 minor
04-01 13:12:15.872 E/ActivityManager(  220):    16% 21603/__eas(par.hakan: 16% user + 0% kernel
04-01 13:12:15.872 E/ActivityManager(  220):    7.2% 21406/GC: 7.2% user + 0% kernel
04-01 13:12:15.872 E/ActivityManager(  220):    1.8% 21409/Compiler: 1.8% user + 0% kernel
04-01 13:12:15.872 E/ActivityManager(  220):   5.5%220/system_server: 0% user + 5.5% kernel / faults: 1 minor
04-01 13:12:15.872 E/ActivityManager(  220):    5.5% 263/InputDispatcher: 0% user + 5.5% kernel
04-01 13:12:15.872 E/ActivityManager(  220): 32%TOTAL: 28% user + 3.7% kernel
```

从LOG可以看出ANR的类型，CPU的使用情况，如果CPU使用量接近100%，说明当前设备很忙，有可能是CPU饥饿导致了ANR
如果CPU使用量很少，说明主线程被BLOCK了
如果IOwait很高，说明ANR有可能是主线程在进行I/O操作造成的
除了看LOG，解决ANR还得需要trace.txt文件，
如何获取呢？可以用如下命令获取
``` bash
$ chmod 777 /data/anr
$ rm /data/anr/traces.txt
$ ps
$ kill -3 PID
$ adb pull data/anr/traces.txt ./mytraces.txt
```
从trace.txt文件，看到最多的是如下的信息：
```
-----pid 21404 at 2011-04-01 13:12:14 -----  
Cmdline: com.android.email

DALVIK THREADS:
(mutexes: tll=0tsl=0 tscl=0 ghl=0 hwl=0 hwll=0)
"main" prio=5 tid=1NATIVE
  | group="main" sCount=1 dsCount=0obj=0x2aad2248 self=0xcf70
  | sysTid=21404 nice=0 sched=0/0cgrp=[fopen-error:2] handle=1876218976
  at android.os.MessageQueue.nativePollOnce(Native Method)
  at android.os.MessageQueue.next(MessageQueue.java:119)
  at android.os.Looper.loop(Looper.java:110)
  at android.app.ActivityThread.main(ActivityThread.java:3688)
  at java.lang.reflect.Method.invokeNative(Native Method)
  at java.lang.reflect.Method.invoke(Method.java:507)
  at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:866)
  at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:624)
  at dalvik.system.NativeStart.main(Native Method)
```
说明主线程在等待下条消息进入消息队列

## Thread状态
```
ThreadState (defined at “dalvik/vm/thread.h “)
THREAD_UNDEFINED = -1, /* makes enum compatible with int32_t */
THREAD_ZOMBIE = 0, /* TERMINATED */
THREAD_RUNNING = 1, /* RUNNABLE or running now */
THREAD_TIMED_WAIT = 2, /* TIMED_WAITING in Object.wait() */
THREAD_MONITOR = 3, /* BLOCKED on a monitor */
THREAD_WAIT = 4, /* WAITING in Object.wait() */
THREAD_INITIALIZING= 5, /* allocated, not yet running */
THREAD_STARTING = 6, /* started, not yet on thread list */
THREAD_NATIVE = 7, /* off in a JNI native method */
THREAD_VMWAIT = 8, /* waiting on a VM resource */
THREAD_SUSPENDED = 9, /* suspended, usually by GC or debugger */
```

## 如何调查并解决ANR
> 
1 : 首先分析log
2 : 从trace.txt文件查看调用stack.
3 : 看代码
4 : 仔细查看ANR的成因（iowait?block?memoryleak?）