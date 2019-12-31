---
title: Android命令行读写i2c寄存器操作
date: 2019-12-31 15:35:31
tags:
---
写命令格式：
寄存器地址 长度  数据

读命令格式：
echo “寄存器地址” > getreg
cat getreg

1.使能寄存器

``` bash
adb shell "echo "0x01,0x01,{0xff}" > /sys/bus/i2c/devices/1-20/setreg"
```

2.禁掉寄存器

``` bash
adb shell "echo "0x01,0x01,{0x00}” > /sys/bus/i2c/devices/1-20/setreg"
```

3.读寄存器

``` bash
adb shell "echo "0x01" > /sys/bus/i2c/devices/1-20/getreg"
adb shell "cat /sys/bus/i2c/devices/1-20/getreg"
```
