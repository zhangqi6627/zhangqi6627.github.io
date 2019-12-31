---
title: Android dex/odex/oat/vdex/art区别
date: 2019-12-31 16:09:02
tags:
---
1.dex
java程序编译成class后，dx工具将所有class文件合成一个dex文件，dex文件是jar文件大小的50%左右.

2.odex（Android5.0之前）全称：Optimized DEX;即优化过的DEX.
Android5.0之前APP在安装时会进行验证和优化，为了校验代码合法性及优化代码执行速度，验证和优化后，会
产生ODEX文件，运行Apk的时候，直接加载ODEX，避免重复验证和优化，加快了Apk的响应时间.
注意：优化会根据不同设备上Dalvik虚拟机版本、Framework库的不同等因素而不同，在一台设备上被优化过
的ODEX文件，拷贝到另一台设备上不一定能够运行。

3.oat（Android5.0之后）
oat是ART虚拟机运行的文件,是ELF格式二进制文件,包含DEX和编译的本地机器指令,oat文件包含DEX文件，因此比ODEX文件占用空间更大。
Android5.0以后在编译的时候(此处指系统预制app，如果通过adb install或者商店安装，在安装时
dex2oat把dex编译为odex的ELF格式文件)dex2oat默认会把classes.dex翻译成本地机器指令，生成ELF格
式的OAT文件，ART加载OAT文件后不需要经过处理就可以直接运行，它在编译时就从字节码装换成机器码了，因
此运行速度更快。不过android5.0之后oat文件还是以.odex后缀结尾,但是已经不是android5.0之前的文件
格式，而是ELF格式封装的本地机器码.
可以认为oat在dex上加了一层壳，可以从oat里提取出dex.

4.vdex
Android8.0以后加入的,包含APK的未压缩DEX代码，另外还有一些旨在加快验证速度的元数据。

5.art (optional)
包含APK中列出的某些字符串和类的ART内部表示，用于加快应用启动速度。

注意：Android5.0以后在／data/dalvik-cache目录下的.dex文件已经不是android5.0之前的dex文件，
它是ELF文件,可以使用file命令查看如下：

``` bash
file system@app@Camera2@Camera2.apk@classes.dex

system@app@Camera2@Camera2.apk@classes.dex: ELF 64-bit LSB shared object, ARM aarch64, version 1 (GNU/Linux), dynamically linked, stripped
```
