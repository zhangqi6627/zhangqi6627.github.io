---
title: 给APK进行系统签名
date: 2017-09-25 14:53:17
tags:
---
在已经编译好的工程中:out/host/linux-x86/framework/signapk.jar　取出 signapk.jar　文件，
然后从　build/target/product/security/项目名字/ 下面取出另外两个文件　platform.x509.pem　和　platform.pk8 
然后三个文件+apk文件，同一个路径下。
执行签名操作 java –jar signapk.jar platform.x509.pem platform.pk8 input.apk output.apk
然后apk就相当于签名，获取了系统权限。当然，名字实际上也重新命名了。