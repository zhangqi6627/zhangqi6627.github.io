---
title: Android安装使用i2c-tools
date: 2019-12-31 15:36:43
tags:
---
Debug i2c设备驱动时，i2c-tools工具是一个很好的调试利器，看可以查看i2c总线、总线上的设备、读写寄存器值等.
For Linux: sudo apt-get install i2c-tools
1.下载i2c-tools源码
2.编译后push到android

``` bash
mm
```

3.i2cdetect,i2cdump,i2cget,i2cset使用

<1>i2cdetect列举i2C有几个总线

``` bash
i2cdetect -l
```

<2>列举总线所有设备，如总线5上的i2c设备

``` bash
i2cdetect -y -r 5
```

注意：发现 I2C 设备的位置显示为UU或者表示设备地址的数值，UU(或:0x5d表示)表示该设备在 driver 中被使用。

<3>dump第5总线上0x5d i2c设备地址(UU)的所有寄存器值

``` bash
i2cdump -y -f 5 0x5d
```

<4>i2cget获取第5个总线上0x5d i2c设备0x20地址的寄存器值

``` bash
i2cget -y -f  5  0x5d  0x20
```

<5>i2cset设置第5个总线上设备地址为0x5d，寄存器地址为0x55的值为0x01

``` bash
i2cset -y -f  5  0x5d  0x55 0x01
```

<6>i2cdump，i2cset，i2cget双字节命令，后面加 w

``` bash
i2cdump -y -f 5 0x5d w
i2cset -y -f  5  0x5d  0x55 0x010B w
i2cget -y -f  5  0x5d  0x20 w
```
