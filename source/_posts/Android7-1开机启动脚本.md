---
title: Android7.1开机启动脚本
date: 2019-12-31 16:19:35
tags:
---
1.开机修改为：Permissive模式启动
2.在device/qcom/common/rootdir/etc/init.qcom.rc添加: 下边两种方式都可。

``` init.rc
service test_service /system/bin/sh /system/bin/set.sh
    user root
    disabled
    oneshot

on property:sys.boot_completed=1
    start test_service
    exec /system/bin/sh /system/bin/test.sh
```

3.在/system/bin下set.sh和test.sh内容
set.sh

``` bash
#!/system/bin/sh
touch /data/1111111111.txt
```

test.sh

``` bash
touch /data/444444444.txt
```

4.Androoid.mk文件,将set.sh和test.sh拷贝到device/qcom/msmxxx目录下
device/qcom/msmxxx/msmxxx.mk

``` Makefile
PRODUCT_COPY_FILES += device/qcom/msmxxx/set.sh:system/etc/set.sh
PRODUCT_COPY_FILES += device/qcom/msmxxx/test.sh:system/etc/test.sh
```

5.编译

``` bash
make bootimage -j16
```
