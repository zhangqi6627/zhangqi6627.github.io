---
title: android am pm wm命令
date: 2018-03-26 13:25:19
tags:
---
# am命令
am全称activity manager，你能使用am去模拟各种系统的行为，例如去启动一个activity，强制停止进程，发送广播进程，修改设备屏幕属性等等。当你在adb shell命令下执行am命令:am <command>
你也可以在adb shell前执行am命令:
adb shell am start -a android.intent.action.VIEW
关于一些am命令的介绍:

start [options] <INTENT> :启动activity通过指定的intent参数。

adb shell am start [options] <INTENT>

作用:启动一个activity

举例:adb shell am start -a com.lt.test.action.SECOND

举例:adb shell am start -n com.lt.test/.MyActivity

 

startservice [options] <INTENT> : 启动service通过指定的intent参数。具体intent跟start命令参数相同。

adb shell am startservice [options] <INTENT>

作用:启动一个service

举例:adb shell am startservice -a com.lt.test.action.ONESERVICE
举例:adb shell am startservice -n com.lt.test/.MyService

 

force-stop <PACKAGE> : 强制停止指定的package包应用。

kill [options] <PACKAGE> :杀死指定package包应用进程，该命令在安全模式下杀死进程，不影响用户体验。参数选项:--user <USER_ID> | all | current: 指定user进程杀死，如果不指定默认为所有users。（关于USER_ID下面会介绍到）

kill-all :杀死所有的后台进程。

adb shell am force-stop <PACKAGE>
作用:强制关闭一个应用程序

举例:adb shell am force-stop com.lt.test

 

broadcast [options] <INTENT> :发送一个intent。具体intent参数参照start命令参数。参数选项:--user <USER_ID> | all | current: 指定user进程杀死，如果不指定默认为所有users。

adb shell am broadcast [options] <INTENT>

作用:发送一个广播
举例:adb shell am broadcast -a "action_finish" （发送一个广播去关闭一个activity）
举例:adb shell am broadcast -a android.intent.action.MASTER_CLEAR（恢复出厂设置的方法，会清除内存所有内容）

举例:adb shell am broadcast -n com.lt.test/.MyBroadcast

 

 

# pm命令
pm全称package manager，你能使用pm命令去模拟android行为或者查询设备上的应用等，当你在adb shell命令下执行pm命令:pm <command>
你也可以在adb shell前执行pm命令:adb shell pm uninstall com.example.MyApp
关于一些pm命令的介绍:
list packages [options] <FILTER> :打印所有包，选择性的查询包列表。

adb shell pm list packages [options] <INTENT>

作用:列举出所有包含<INTENT>的package

举例:adb shell pm list packages com.lt

说明:[options]与<INTENT>参见 http://developer.android.com/tools/help/adb.html#pm

 

参数选项:
-f:查看关联文件，即应用apk的位置跟对应的包名（如:package:/system/app /MusicPlayer.apk=com.sec.android.app.music）；

-d:查看disabled packages；

-e:查看enable package；

-s:查看系统package；

-3:查看第三方package；

-i:查看package的对应安装者（如:1、 package:com.tencent.qqmusic installer=null 2、package:com.tencent.qqpim installer=com.android.vending）；

-u:查看曾被卸载过的package。（卸载后又重新安装依然会被列入）；

--user<USER_ID>:The user space to query。

list permission-groups :打印所有已知的权限群组。

list permissions [options] <GROUP> :选择性的打印权限。参数选项:

list features :设备特性。硬件之类的性能。

list libraries :当前设备支持的libs。

list users :系统上所有的users。（上面提到的USER_ID查询方式，如:UserInfo{0:Primary:3}那么USER_ID为0）

path <PACKAGE> :查询package的安装位置。

install [options] <PATH> :安装命令。

uninstall [options] <PACKAGE> :卸载命令。

clear <PACKAGE> :对指定的package删除所有数据。

enable <PACKAGE_OR_COMPONENT> :使package或component可用。（如:pm enable "package/class"）

disable <PACKAGE_OR_COMPONENT> :使package或component不可用。（如:pm disable "package/class"）

disable-user [options] <PACKAGE_OR_COMPONENT> :参数选项:--user <USER_ID>: The user to disable.
grant <PACKAGE_PERMISSION> :授权给应用。

revoke <PACKAGE_PERMISSION> :撤销权限。

set-install-location <LOCATION> :设置默认的安装位置。其中0:让系统自动选择最佳的安装位置。1:安装到内部的设备存储空间。2:安装到外部的设备存储空间。（这只用于调试应用程序， 使用该命令可能导致应用程序退出或者其他不适的后果）。

get-install-location :返回当前的安装位置。返回结果同上参数选项。

set-permission-enforced <PERMISSION> [true|false] :使指定权限生效或者失效。

create-user <USER_NAME> :增加一个新的USER。

remove-user <USER_ID> :删除一个USER。

get-max-users :该设备所支持的最大USER数。（某些设备不支持该命令）

 

 

# wm命令
wm全称是window manager，它是对手机分辨率、像素密度、显示区域进行设置的命令。其参数比较少，下面逐条介绍一下该命令的用法。

系统说明:

usage:
wm [subcommand] [options]
wm size [reset|WxH]
wm density [reset|DENSITY]
wm overscan [reset|LEFT,TOP,RIGHT,BOTTOM]
wm size: return or override display size.
wm density: override display density.
wm overscan: set overscan area for display.

1、wm size [reset|WxH]

[]内的是可选项。单纯运行wm size命令将会得到lcd本身设置的显示分辨率。

    wm size W x H命令是按witch x hight 设置分辨率。如果分辨率设置的过大，图标会变大，反之则变小。设置了分辨率以后执行wm size命令，可以看到LCD本身的分辨率及overwrite的分辨率。

 wm size reset 命令是将分辨率设置为LCD原始分辨率。

2、 wm density [reset|DENSITY]

    该命令的用法类似于wm size 命令，作用是读取、设置或者重置LCD的density值。density值即LCD的ppi.

3、 wm overscan [reset|LEFT,TOP,RIGHT,BOTTOM]

  该命令用来设置、重置LCD的显示区域。四个参数分别是显示边缘距离LCD左、上、右、下的像素数。例如，对于分辨率为540x960的屏幕，通过执行 命令wm overscan 0,0,0,420可将显示区域限定在一个540x540的矩形框里。

了解wm可以解决LCD图标大小显示不正常的问题。

但是这些设置都是临时的，适合于调试来确定问题和解决办法。永久性的修改可以参照以下两个办法

法一:

2> adb root    //提示read only filysystem时执行此命令获取root权限，

adb remount

adb pull /system/build.prop D:\

在build.prop末尾添加一行 ro.sf.lcd_density=240 

adb push  D:\build.prop  /system/

adb shell

cd /system/

chmod 644 build.prop    没有修改权限将导致手机起不来

法二: 直接修改system.prop

Y:\xxxx\device\qcom\xxxx\system.prop

ro.sf.lcd_density=240 改这个值，然后重新编译system.img

> 
注:具体命令的帮助可以输入adb shell am;adb shell pm;adb shell wm;来查看