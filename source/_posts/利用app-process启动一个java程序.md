---
title: 利用app_process启动一个java程序
date: 2019-12-31 14:43:24
tags:
---
app_process实际上就是zygote，它已经有载入android.jar等Android环境，所以它能执行Android程序。

参考 am 和 pm 的启动脚本
am:

``` bash
base=/system
export CLASSPATH=$base/framework/am.jar
exec app_process $base/bin com.android.commands.am.Am "$@"
```

pm:

``` bash
base=/system
export CLASSPATH=$base/framework/pm.jar
exec app_process $base/bin com.android.commands.pm.Pm "$@"
```

CLASSPATH指定了你的程序的位置，com.android.commands.pm.Pm则说明了程序的入口为com.android.commands.pm.Pm，即入口函数main()所在的类，"$@"就是传递给main（）函数的参数，只是这里"$@"本身又是个shell传入的参数而已
需要注意的是CLASSPATH中的文件必须是dalvik文件格式的，关于此的转换请参考《基本Dalvik VM调用》当然CLASSPATH中的文件可以是apk文件，只是你的apk中至少应该有个拥有main()入口函数的类。