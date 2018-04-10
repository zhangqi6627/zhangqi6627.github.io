---
title: mtklog分析
date: 2018-04-09 13:10:12
tags:
---
https://www.cnblogs.com/xiyuan2016/p/6740521.html

http://www.voidcn.com/article/p-btyoxkos-bpn.html

### Mtklog 结构
mtklog分析:  
	1. mdlog1                           // modem 相关底层的log  
		1.1 MDLog1_2010_0101_000152     // 每次打开mtklog都会新建一个文件夹  
		1.2 MDLog1_2015_0101_000042  

	2. mobilelog                        // android log 和 kernel log  
		2.1 APLog_2010_0101_000147  
		2.1 APLog_2015_0101_000037        
			atf_log                     // 所有_log都是进入安卓之后的  
			atf_log.boot                // 所有.boot都是启动到进入安卓之前的log  
            bootprof                    // 启动的简要信息 - 可以分析启动时间 - 启动模式(普通or看门狗or按键())  
            cmdline                     // lk传给kernel的参数(包括lcm等) - 可以自己加  
            crash_log                   // 崩溃log  
            crash_log.boot  
            events_log                  // 事件log，主要输出记录各个activity周期及事件  
            events_log.boot：  
            kernel_log                  // 内核log，常用  
            kernel_log.boot  
            last_kmsg                   // 上一次关机前的log - 可以分析重启原因  
            main_log                    // hal层的log打印在这里  
            main_log.boot  
            mblog_history               // 本目录下所有log的大小等信息  
            ProjectConfig.mk            // 工程配置  
            properties                  // 属性  
            radio_log                   // 输出通话，网络状态变化  
            radio_log.boot  
            sys_log                     // jni、framework层log，Exception定位点  
            sys_log.boot  

	3. netlog                           //网络log  
		3.1 NTLog_2010_0101_000147  
			NTLog_2015_0101_000037  
			tcpdump_NTLog_2015_0101_000037_start.cap.tmp  

	4. running_file_tree.txt            //

### ZZ_INTERNAL相关信息及解释
```
ANR,2173,-1361051648,99,/data/core/,1,system_app_anr,android.process.media,Tue Jul  4 18:51:03 HKT 2017,1

第一列：exception class，有KE/NE/JE/EE等
第二列：pid
第三列：tid
第四列：固定是99
第五列：固定是/data/core
第六列：exception level，0: fatal, 1: exception, 2: warning, 3: reminding
第七列：exception type info string (如果是NE，则这个栏位是signal名称，比如：SIGSEGV，KE则为空，SWT则为:system_server_watchdog)
第八列：module name or process name
第九列：UTC time
第十列：固定是1
```

### trace部分信息解析
```
----- pid 2173 at 2017-07-04 11:51:32 -----
Cmd line: android.process.media
"main" prio=5 tid=1 Native
"Binder:2173_1" prio=5 tid=9 Blocked
  | group="main" sCount=1 dsCount=0 obj=0x22c05430 self=0xa1fcab00
  | sysTid=2186 nice=10 cgrp=bg_non_interactive sched=0/0 handle=0xa497a920
  | state=S schedstat=( 26942858 122825452 281 ) utm=0 stm=2 core=0 HZ=100
  | stack=0xa487e000-0xa4880000 stackSize=1014KB
  | held mutexes=
  at com.android.providers.media.MediaProvider.getParent(MediaProvider.java:4118)
  - waiting to lock <0x06de4cd2> (a java.util.HashMap) held by thread 13
  at com.android.providers.media.MediaProvider.insertFile(MediaProvider.java:4395)
  at com.android.providers.media.MediaProvider.insertInternal(MediaProvider.java:4662)
  at com.android.providers.media.MediaProvider.insert(MediaProvider.java:4015)
  at android.content.ContentProvider$Transport.insert(ContentProvider.java:272)
  at android.content.ContentProviderNative.onTransact(ContentProviderNative.java:163)
  at android.os.Binder.execTransact(Binder.java:570)
```
  
  
1)pid 2173 at 2017-07-04 11:51:32  
  ANR发生的进程的ID，时间点

2)Cmd line: android.process.media  
  ANR发生的进程的名称

3)"main" prio=5 tid=1 Native 
  说明线程名，线程的优先级，线程锁ID和线程状态.
  线程名称是启动线程的时候手动指明的，这里的main标示是主线程，
  是Android自动设定的一个线程名称，如果是自己手动创建的线程，
  一般会被命名成“Thread-xx”的格式，启动xx是线程ID，他只增不减
  不会被复用;注意这启动的tid不是线程的id，他是一个在Java虚拟机
  中用来实现线程锁的变量，随着线程的增减，这个变量的值是可能被
  复用的；
                                                                            
4)group="main" sCount=1 dsCount=0 obj=0x22c05430 self=0xa1fcab00
  group是线程组名称。
  sCount是此线程被挂起的次数，
  dsCount是线程被调试器挂起的次数。
  当一个进程被调试后，sCount会重置为，调试完毕后sCount会根据是否
  被正常挂起增长，但是dsCount不会被重置为0，所以dsCount也可以用来
  判断这个线程是否被调试过，obj表示这个线程的Java对象地址，self表
  示这个线程本身的地址。

5)此后是线程的调度信息
| sysTid=2186 nice=10 cgrp=bg_non_interactive sched=0/0 handle=0xa497a920
  sysTid是Linux下的内核线程ID，
  nice是线程调度的优先级.
  sched分别标志了线程的调度策略和优先级，
  cgrp是调度属组，
  handle是线程的处理函数地址。
  
6)线程当前上下文信息
 | state=S schedstat=( 26942858 122825452 281 ) utm=0 stm=2 core=0 HZ=100
  state是调度状态;
  schedstat从 /proc/[pid]/task/[tid]/schedstat读出
  三个值分别表示线程在cpu上执行的时间、线程的等待时间和线程执行的时间片长度;
  有的android内核版本不支持这项信息，得到的三个值都是0；utm是线程用户态下使
  用的时间值(单位是jiffies);stm是内核态下的调度时间值;core是最后执行这个线程
  cpu核的序号

7)最后就是这个线程的调度栈信息。
  一般可以通过以下几个简单的方法来判断
  *trace文件顶部的线程一般是ANR的元凶。
  *这是一个简单的方法，大部分情况下都适用，可以通过这个方法来快速判断是否是自己
   的应用造成了本次的ANR，但是并不是trace文件包含的应用就一定是造成ANR的帮凶，应
   用出现在trace文件中，只能说明出现ANR的时候这个应用进程还活着，trace文件的顶部
   则是触发ANR的应用信息，因此如果你的应用出现在trace文件的顶部，那么很有可能是
   因为你的应用造成了ANR,否则是你的应用造成ANR的可能性不大，还需要进一步分析。
   
8)如果定位不到时间点，可以看CPU 
  (sys_log)07-04 18:51:03.209156  1044  1068 E ANRManager: 3.4% TOTAL: 0.5% user  + 2.6% kernel + 0.2% irq 
   从CPU使用率可以看出:
   *如果使用量很高，说明当前设备很忙(内存不足，循环处理)
   *如果CPU使用量很少，说明主线程被BLOCK了
   *如果IOwait很高，说明ANR有可能是主线程在进行I/O操作造成的(数据库、文件操作、
    网络操作等)      
  
9)等待锁引起的ANR
  找到WallpaperManager对应代码，再结合main log等其他信息，看tid=27的thread在忙
  什么。
  
10)SWT重启问题分析
  SWT是指Android Watchdog Timeout，应用层看门狗超时，通常我们说的WDT是HWT，硬件
  看门狗超时。
  1.Watchdog的目的是监控系统几个比较主要的service，比如NetworkManagementService，
  PowerManagerService，ActivityManagerService等。这些Service在启动时通过调用
  Watchdog。getInstance().addMonitor(this);加入到Watchdog的监控列表中，如果超过
  一定时间没有反应，认为系统出错，会强制启动Android。
  2.Watchdog原理：/framework/base/services/java/com/android/server/Watchdog.java
  3.具体分析方法
    *首先从enventlog中以watchdog为关键字搜索，记录下这个时刻
      17:25:23.645459 950 1285 I watchdog:surfaceflinger hang.
    *然后分析所有Service Object的monitor()为何在这个时刻之前1分钟没有做完，
    *后面具体分析方法和ANR一样
    *ANR是某个AP的主线程在一段时间内没有完成某件事情，
    *Android Watchdog 是SystemServer进程的ServerThread 线程在一段时间内没有做完
     某件事情。                

### radio_log分析网络状况
```
06-30 10:38:06.572525 938 976 I AT : AT< +ECSQ: 22,54,1,1,1,-36,-346,7,39 (RIL_URC_READER, tid:0)
06-30 10:38:06.572737 938 976 I RILC : RIL_SOCKET_1 UNSOLICITED: UNSOL_SIGNAL_STRENGTH length:72
06-30 10:38:06.573125 938 998 I RIL : [GSM MAL] URC send success, rid 0, ret 0:      #F5F6FA
06-30 10:38:06.573125 938 998 I RIL : +ECSQ: 22,54,1,1,1,-36,-346,7,39
06-30 10:38:06.574384 1028 1067 D RilMalClient: UNSOL_TO_MAL: remap to unsol resp(1009)
06-30 10:38:06.575465 1028 1067 D RpRilClientController: leave blocking write
06-30 10:38:06.575605 1028 1067 D RpRilClientController: leave blocking write
06-30 10:38:06.576133 1425 1425 D SST : [GsmSST0] handle EVENT_SIGNAL_STRENGTH_UPDATE
06-30 10:38:06.576410 1425 1425 W SignalStrength: Signal before validate=SignalStrength: 0 54 -1 -1 -1 -1 -1 99 86 9 97 2147483647 2147483647 gsm|lte 2147483647 2147483647 2147483647
06-30 10:38:06.576526 1425 1425 W SignalStrength: Signal after validate=SignalStrength: 0 54 -120 -160 -120 -1 -1 99 -86 -9 97 2147483647 2147483647 gsm|lte 2147483647 2147483647 2147483647
06-30 10:38:06.577794 1010 1367 D TelephonyRegistry: notifySignalStrengthForPhoneId: callback.onSsS r={callingPackage=android binder=android.telephony.PhoneStateListener$IPhoneStateListenerStub@d4b4edc callback=android.telephony.PhoneStateListener$IPhoneStateListenerStub@d4b4edc onSubscriptionsChangedListenererCallback=null callerUserId=0 subId=2147483647 phoneId=-1 events=1c1 canReadPhoneState=true} subId=3 phoneId=0 ss=SignalStrength: 0 54 -120 -160 -120 -1 -1 99 -86 -9 97 2147483647 2147483647 gsm|lte 2147483647 2147483647 2147483647
06-30 10:38:06.578163 1010 1367 D TelephonyRegistry: notifySignalStrengthForPhoneId: callback.onSsS r={callingPackage=com.android.systemui binder=android.os.BinderProxy@d2e4c9 callback=com.android.internal.telephony.IPhoneStateListener$Stub$Proxy@7f6d7ce onSubscriptionsChangedListenererCallback=null callerUserId=0 subId=3 phoneId=0 events=101e1 canReadPhoneState=true} subId=3 phoneId=0 ss=SignalStrength: 0 54 -120 -160 -120 -1 -1 99 -86 -9 97 2147483647 2147483647 gsm|lte 2147483647 2147483647 2147483647
06-30 10:38:06.578577 1010 1367 I use-Rlog/RLOG-GSM: getLTELevel - rsrp:-86 snr:97 rsrpIconLevel:3 snrIconLevel:3
06-30 10:38:06.578693 1010 1367 W SignalStrength: getLevel=3
06-30 10:38:06.579533 1305 1531 I use-Rlog/RLOG-GSM: getLTELevel - rsrp:-86 snr:97 rsrpIconLevel:3 snrIconLevel:3
06-30 10:38:06.582788 1305 1531 W SignalStrength: getLevel=3
06-30 10:38:06.588566 1305 1531 I use-Rlog/RLOG-GSM: getLTELevel - rsrp:-86 snr:97 rsrpIconLevel:3 snrIconLevel:3
06-30 10:38:06.589489 1305 1531 W SignalStrength: getLevel=3
```

```
3G modem:
+ECSQ: <asu>, <ber>, <rssi> （2G网络）
+ECSQ: <asu>, <ber>, <rssi>, <rscp>, <ec/no> （3G网络）
4G modem:
+ECSQ: <asu>, <ber>, <rssi>, <rscp>,1,1,1,<act> （2G网络）
+ECSQ: <asu>, <ber>, <rssi>, <rscp>, <ec/no>,1,1, <act> （3G网络）
+ECSQ: <rsrq>, <rsrp>,1,1,1,<rsrq_qdbm >,<rsrp_qdbm> <act> （4G网络）

看+ECSQ 命令带的值:
*如果第六第七位不是255 or 1 则当前在LTE状态，
*如果第四第五位不是255 or 1 则当前在3G mode。
*2G的话不是很清楚怎么看radio log,一般是在modem log里确认的。
+ECSQ:<sig1>,<sig2>,<rssi_in_qdbm>,<rscp_in_qdbm>,<ecn0_in_qdbm>,<rsrq_in_qdbm>,<rsrp_in_qdbm>,<Act>
从radio log看，手机应该在
4G mode时, 如果 SNR<0 (RSRQ<-60dbm)，则信号很差。
3G mode时, EcN0<-15 (RSCP<-115dbm)时信号很差
2G mode时, 2G：rssi< -95dbm 、 rscq > 4 (0~7 ,0最好，7最差)
```

### 通话问题分析
很多场测神马的，都会报出很多通话相关的bug，有些是通话无声，有些事通话质量不好，等等。遇到这种问题原来都是直接提给MTK的，后面发现很多都是网络质量问题，遂跟MTK讨了方法。在radiolog中搜索 +ECSQ:
```
06-30 10:38:06.572525 938 976 I AT : AT< +ECSQ: 22,54,1,1,1,-36,-346,7,39 (RIL_URC_READER, tid:0)
```
看+ECSQ 命令带的值，
如果第六第七位不是255 or 1 则当前在LTE状态，
如果第四第五位不是255or1则当前在3G mode。
2G的话不是很清楚怎么看radio log,一般是在modem log里确认的。
```
+ECSQ:<sig1>,<sig2>,<rssi_in_qdbm>,<rscp_in_qdbm>,<ecn0_in_qdbm>,<rsrq_in_qdbm>,<rsrp_in_qdbm> ,<Act>
```

判断信号质量:
手机应该在4G下。如果 SNR < 0 (RSRQ <-60)，则信号很差。 
3G mode时， EcN0<-15 (RSCP<-115)时信号很差。
2G mode时， rssi< -95dbm 、 rscq > 4 (0~7 ,0最好，7最差)


### ANR 问题分析流程
#### 1.定位问题点
```
a) 使用mobile log
*events_log中搜索am_anr
*main_log 或 Sys_log 中搜索ANR in
*traces.txt中查找相应的PID或者进程名

b) 使用anr db文件 
*使用gat工具打开db文件
*查看ZZ_INTERNAL文件 找到pid或者进程名
*在SWT_JBT_TRACES查找pid
```

#### 2.在mainlog中查看cpu
一般在trace就能看到问题点，如果还是定位不到，就需要在mainlog中搜索TOTAL：
查看CPU使用率  进而确认问题