---
title: 重启framework命令
date: 2019-12-31 16:23:14
tags:
---
``` bash
adb shell stop && adb shell start
```

源码位置:在system/core/toolbox/start.c下面,原理很简单就是利用ctl属性来控制进程

start.c

``` C
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <cutils/properties.h>

int start_main(int argc, char *argv[]) {
    char buf[1024];
    if(argc > 1) {
        property_set("ctl.start", argv[1]);
    } else {
        /* defaults to starting the common services stopped by stop.c */
        property_set("ctl.start", "surfaceflinger");
        property_set("ctl.start", "zygote");
    }
    return 0;
}
```

stop.c

``` C
#include <stdio.h>
#include <string.h>

#include <cutils/properties.h>

int stop_main(int argc, char *argv[]) {
    char buf[1024];
    if(argc > 1) {
        property_set("ctl.stop", argv[1]);
    } else{
        /* defaults to stopping the common services */
        property_set("ctl.stop", "zygote");
        property_set("ctl.stop", "surfaceflinger");
    }
    return 0;
}
```
