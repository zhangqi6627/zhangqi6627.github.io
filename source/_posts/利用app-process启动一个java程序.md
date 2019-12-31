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

1.执行jar包里的java可执行文件,使用app_process启动java文件,其中java里必须有main()方法，这是函数入口。

``` bash
adb shell CLASSPATH=/system/framework/Demo.jar exec app_process /system/bin com.example.Demo
```

或在apk里启动一个可执行com.example.helloworld.Console里的main()

``` bash
adb shell CLASSPATH=/data/app/com.example.helloworld-1.apk exec app_process /system/bin com.example.helloworld.Console
//注意：/system/bin这个目录可以替换为任意目录
```

2.执行java文件

<1>.Hello.java

``` Java
public static class Hello {
　　public void main(String args[]){
　　　　System.out.println("Hello Android");
　　}
}
```

<2>.编译

``` bash
javac Hello.java
```

编译出Hello.class文件可以在普通的jvm上运行，要放到android下还需要转换成dex，需要用android sdk中的dx工具进行转换

``` bash
cd SDK/build-tools //SDK为自己下载的android sdk
dx --dex --output=Hello.dex Hello.class
```

得到Hello.dex

<3>.Hello.dex push到/sdcard

``` bash
adb push Hello.dex /sdcard
```

<4>.使用app_process 运行hello.dex

``` bash
app_process -Djava.class.path=/sdcard/Hello.dex /sdcard Hello
```
