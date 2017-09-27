---
title: framework下添加一个自定义的服务 SELinux Permission Denied
date: 2017-09-19 15:22:13
tags:
---
问题点:
在systemserver.java中添加如下代码，向servicemanager进程中添加一个service
``` Java
try {
    Slog.i(TAG, "Hello Service");
    ServiceManager.addService("hello", new HelloService());//
} catch (Throwable e) {
    Slog.e(TAG, "Failure starting Hello Service", e);
}
```

servicemanager是BINDER的管理者，负责协调Android里的进程通信。这里添加的helloservice是一个硬件管理服务，运行在单独的进程里，如果APP想要使用这个服务就必须通过servicemanager查询和调用。
执行代码的时候出现了如下错误:
```
E SELinux : avc:  denied  { add } for service=hello scontext=u:r:system_server:s0 tcontext=u:object_r:default_android_service:s0 tclass=service_manager
E ServiceManager: add_service('hello',62) uid=1000 - PERMISSION DENIED
```

提示为SELinux Permission Denied。
解决办法参考:
http://stackoverflow.com/questions/30165852/selinux-permission-denied-for-a-new-framework-service-in-android 
解决办法:

external\sepolicy\service.te
```
type mytest_service, system_api_service, system_server_service, service_manager_type;
```

external\sepolicy\service_contexts

```
mytestservice u:object_r:mytest_service:s0
```