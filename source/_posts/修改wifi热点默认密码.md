---
title: 修改wifi热点默认密码
date: 2017-09-22 10:30:07
tags:
---
M:frameworks/base/wifi/java/android/net/wifi/WifiApConfigStore.java
``` Java
private void setDefaultApConfiguration() {
	...
    //config.preSharedKey = "sayyezz.com";
    config.preSharedKey = randomUUID.substring(0, 8);    //随机wifi热点密码
    sendMessage(WifiStateMachine.CMD_SET_AP_CONFIG, config);
    ...
}
```