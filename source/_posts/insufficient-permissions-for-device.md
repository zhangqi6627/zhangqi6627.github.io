---
title: insufficient permissions for device
date: 2018-04-25 09:20:29
tags:
---
问题4: error: insufficient permissions for device（解决adb shell问题）

解决方法:
在linux下连接手机usb，试用adb shell时出现error: insufficient permissions for device，

而且我们输入adb devices显示：
``` bash
xxxx@xxxx-pt:~$ adb devices
List of devices attached 
????????????    device
```
那么我们怎么解决它呢？

首先在终端查看usb的ID，输入lsusb命令，我们可以看到我们刚插如usb的ID号，如：

``` bash
xxxx@xxxx-pt:~$ lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 003: ID 0461:4d80 Primax Electronics, Ltd 
Bus 001 Device 004: ID 1c7a:0801 LighTuning Technology Inc. Fingerprint Reader
Bus 002 Device 003: ID 5986:0190 Acer, Inc 
Bus 001 Device 019: ID 0bb4:0c02 High Tech Computer Corp. Dream / ADP1 / G1 / Magic / Tattoo (Debug)
```

0bb4:0c02 的就是我们插入usb的ID号。
那么我们进入到cd /etc/udev/rules.d/下，新建一个51-android.rules文件（sudo  vim  51-android.rules），在这个文件中写上：
SUBSYSTEM=="usb", ATTRS{idVendor}==" 0bb4", ATTRS{idProduct}=="0c02",MODE="0666"
保存，再为51-android.rules加上权限（sudo chmod a+x 51-android.rules）.
拔掉usb重新插上就可以了，如：
``` bash
xxnan@xxnan-pt:~$ adb devices
List of devices attached 
0123456789ABCDEF    device
```

这样就解决了不能识别USB的问题。
