---
title: Android串口控制台改为root
date: 2019-12-31 16:28:34
tags:
---
一.第一种 adb进去

``` bash
chown root:root /system/xbin/su
```

or

``` bash
chown 0:0 /system/xbin/su
chmod 4755 su //setuid()的s位
echo 0 > /proc/sys/kernel/printk
/system/bin/id
/usr/bin/id
```

1.App获取root权限原理：
也是通过su获取s权限，app来执行/system/xbin下的su获取root。

``` Java
Process process = Runtime.getRuntime().exec("su");//切换到root权限，执行操作
DataOutputStream os = newDataOutputStream(process.getOutputStream());
os.writeBytes("mount -oremount,rw /dev/block/mtdblock3 /system\n");
os.writeBytes("busybox cp /data/data/com.koushikdutta.superuser/su /system/bin/su\n");
os.writeBytes("busybox chown 0:0 /system/bin/su\n");
os.writeBytes("chmod 4755 /system/bin/su\n");
os.writeBytes("exit\n");
os.flush();
```

2.在代码里修改su权限为6755
<1>.启动 su_daemon init.rc中添加：
service su_daemon /system/xbin/su --daemon
    class main

<2>.将su文件拷贝到out/target/product/rk3288_box/system/xbin到/systm/xbin

``` bash
adb push su /system/xbin
```

<3>.修改 system/xbin/su 权限为 06755
system/core/include/private/android_filesystem_config.h
{ 06755, AID_ROOT, AID_ROOT, 0, "system/xbin/su" },

二.第二种
如果要调试的时候信息打印到超级终端，添加console,像sh一样直接输出到console
system/core/rootdir/init.rc

init.rc设置：
service console /system/bin/sh
    class core
    console
    disabled
    user shell
    seclabel u:r:shell:s0

修改为:
service console /system/bin/sh
    console
    disabled
    user root
    group root

注意：如果android5.1以上系统打开了Selinux，必须关闭，否则在console串口控制台输入不了命令的.
编译系统boot.img,烧写后，控制台可执行root权限。
