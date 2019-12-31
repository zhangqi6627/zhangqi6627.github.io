---
title: Android修改kernel logo和开机动画
date: 2019-12-31 15:51:47
tags:
---
一、uboot 开机logo
1.安装图片工具

``` bash
sudo apt-get install netpbm
```

2.生成logo脚本
//make-uboot-logo.sh

``` bash
#!/bin/sh
#1.uboot logo
jpegtopnm $1 | ppmquant 31 | ppmtobmp -bpp 8 > $2
```

使用: ./make-uboot-logo.sh xxx.png xxx.bmp
注意:需要xxx.png格式,生成xxx.bmp格式

二、kernel开机logo
1、安装pngtopnm

``` bash
sudo apt-get install netpbm
#安装完以后就会生成pngtopnm、pnmquant、pnmtoplainpnm三个工具
```

2、制作logo图片
将logo图片保存为mylogo.png，注意扩展名为png。

3、制作.ppm格式的图片

``` bash
pngtopnm mylogo.png > mylogo.pnm
pnmquant 224 mylogo.pnm > mylogo224.pnm
pnmtoplainpnm mylogo224.pnm > logo_linux_clut224.ppm
```

4.拷贝文件到相应目录
用logo_linux_clut224.ppm替换kernel/drivers/video/logo目录下的同名文件，删除对应的.o文件并重新编译内核即可。

5.内核的配置
内核中除了要选中 Graphics support项下的 Bootup logo配置项外，还要选中 Console display driver support配置项。否则kernel不会显示logo。

三、android开机动画

1.开机时，系统自动检测在/system/media或/data/local/目录有没有bootanimation.zip文件。
  如果有，这按照bootanimation.zip里面的png排列顺序依次显示开机图片，开起来就是动画效果；
  否则按照android默认的方式显示开机动画：frameworks/base/core/res/assets/images

2./system/media/bootanimation.zip //bootainimation.zip里包含desc.txt和图片part0,part1(为目录)
desc.txt内容：
320 480 30
p 1 0 part0
p 0 0 part1

分辨率：320:宽 480:高 30:每秒播放30张图片
p 1(只播放一次) 0(空指令) part0(代表part0文件夹内图片只按名称顺序播放一次)
p 0(重复播放)  0(空指令)  part1(代表part1文件夹内的图片会循环播放)

zip压缩命令：

``` bash
zip -r -X -Z store bootanimation.zip part*/*.png desc.txt
```

3.push到系统

``` bash
adb push bootainimation.zip /system/media
```

或者：在device.mk里添加

``` Makefile
PRODUCT_COPY_FILES += vendor/bootanimation.zip:/system/media/bootanimation.zip
```
