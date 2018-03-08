---
title: 如何编译ICU资源
date: 2017-09-22 12:02:45
tags:
---
如果只是测试修改后效果，执行步骤A即可；如果需要build后生效，则需要执行全部步骤
下面是KK的icu资源的路径为例子，如果是Android L请改为external/icu/icu4c/source/
### A. （KK,L）需要建立临时目录，并且在临时目录中编译ICU资源
#### 1. 在external/icu4c下新建临时目录icubuild，进入icubuild目录
``` bash
$ mkdir external/icu4c/icuBuild
$ cd external/icu4c/icuBuild
```
#### 2. 执行icuConfigureRun Linux命令，生成make文件
``` bash
$.././runConfigureICU Linux
```
#### 3. 执行make -j2命令
``` bash
$ make -j2
```
#### 4. 将生成的external/icu4c/icuBuild/data/out/tmp/icudtxxl.dat push到手机测试
``` bash
$ adb remount
$ adb push external/icu4c/icuBuild/data/out/tmp/ icuxxl.dat system/usr/icu/
$ adb reboot
```
 
KK：icudt51l.dat
Android L：icudt53l.dat
（M、N）无需建立临时目录
1.进入到 external/icu/icu4c/source/ 目录下的
2.在该目录下执行 ./runConfigureICU Linux命令生成MAKE文件
3.执行 make INCLUDE_UNI_CORE_DATA=1
 
### B. COPY所需文件
（KK ，L）将第一步生成的external\icu4c\icubuild\data\out\tmp\icudtxxl.dat复制到external\icu4c\stubdata下并改名为icudtxxl-all.dat，覆盖原来的同名文件
KK版本是icudt5l.dat和icudt5l-all.dat
> 
注意：Android L是没有icudt53l-all.dat文件的，直接把icudt53l.dat拷贝过来替换原来的文件即可。


(M、N)将生成的icudtxxl.dat 文件拷贝到对应目录下:
``` Java
M:cp external/icu/icu4c/source/data/out/tmp/icudt55l.dat   $AOSP/external/icu/icu4c/source/stubdata
N:cp external/icu/icu4c/source/data/out/tmp/icudt56l.dat   $AOSP/external/icu/icu4c/source/stubdata
```
### C. 重新编译工程

### D. 遇到的问题
1.编译的时候出错？？？
Item curr/uz_Cyrl_UZ.res depends on missing item curr/uz_Cyrl.res
Item lang/uz_Cyrl_UZ.res depends on missing item lang/uz_Cyrl.res
Item region/uz_Cyrl_UZ.res depends on missing item region/uz_Cyrl.res
Item uz_Cyrl_UZ.res depends on missing item uz_Cyrl.res
Item zone/uz_Cyrl_UZ.res depends on missing item zone/uz_Cyrl.res
['/home/zq/zq/trunk_LCA_a35eh_0526/prebuilts/misc/linux-x86_64/icu-4.8/icupkg', '-tl', '-s', '/home/zq/zq/trunk_LCA_a35eh_0526/external/icu4c/tmp', '-a', '/home/zq/zq/trunk_LCA_a35eh_0526/external/icu4c/stubdata/icudt48l-default.txt', 'new', 'icudt48l.dat']

解决：
在external/icu4c/stubdata/icudt48l-default.dat 中加上	curr/uz_Cyrl.res 等资源就可以了

2.push了之后开不了机？？？ 01-01 00:02:35.238: E/ICU(2288): Couldn't find ICU DateTimePatterns for uz_UZ

解决：
将uz_UZ.txt中的	"%%ALIAS"{"uz_Cyrl_UZ"} 这句话删除了就可以了

3.编译成功push开机之后，语言列表中少了乌兹别克语？？？

4.语言列表在哪里加载？？？

5.Couldn't find ICU yesterday/today/tomorrow for uz_UZ??

解决：
将资源make -j2 clean