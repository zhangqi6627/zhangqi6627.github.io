---
title: Shell死循环
date: 2019-12-31 15:40:59
tags:
---
while死循环

``` bash
#!/bin/bash

while [ 1 ]
do
    sleep 1
    adb logcat -v time
done
```

for死循环

``` bash
#!/bin/bash

for ((;;))
do
    sleep 1
    ifconfig
done
```
