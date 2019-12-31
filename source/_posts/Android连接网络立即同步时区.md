---
title: Android连接网络立即同步时区
date: 2019-12-31 15:50:02
tags:
---
``` Java
1.frameworks/base/services/core/java/com/android/server/NetworkTimeUpdateService.java
private void onPollNetworkTimeUnderWakeLock(int event) {
    if (/省略.../event == EVENT_AUTO_TIME_CHANGED) {
    }
}

改为：
private void onPollNetworkTimeUnderWakeLock(int event) {
    if (/省略.../event == EVENT_AUTO_TIME_CHANGED || event == EVENT_NETWORK_CHANGED) {
    }
}
```

2.frameworks/base/core/res/res/values/config.xml

``` xml
末尾添加:
<!-- NTP time got retry internal time -->
<integer name="config_ntpPollingIntervalShorter">1000</integer>
<!-- NTP time got retry count. -->
<integer name="config_ntpRetry">5</integer>
```

3.vendor/system.prop

``` props
persist.sys.timezone=Asia/Shanghai
```
