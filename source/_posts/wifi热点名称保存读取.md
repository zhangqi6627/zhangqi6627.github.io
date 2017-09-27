---
title: wifi热点名称保存读取
date: 2017-09-22 09:27:51
tags:
---

frameworks/base/wifi/java/android/net/wifi/WifiApConfigStore.java

//保存到 softap.conf 文件中
``` Java
private static final String AP_CONFIG_FILE = Environment.getDataDirectory() + "/misc/wifi/softap.conf";
```

//保存
``` Java
private void writeApConfiguration(final WifiConfiguration config) {
    DataOutputStream out = null;
    try {
        out = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(AP_CONFIG_FILE)));
        out.writeInt(AP_CONFIG_FILE_VERSION);
        out.writeUTF(config.SSID);
        int authType = config.getAuthType();
        out.writeInt(authType);
        if (authType != KeyMgmt.NONE) {
            out.writeUTF(config.preSharedKey);
        }
        out.writeInt(config.channel);
        out.writeInt(config.channelWidth);
    } catch (IOException e) {
        Log.e(TAG, "Error writing hotspot configuration" + e);
    } finally {
        if (out != null) {
            try {
                out.close();
            } catch (IOException e) {}
        }
    }
}
```
//读取
``` Java
void loadApConfiguration() {
    DataInputStream in = null;
    try {
        WifiConfiguration config = new WifiConfiguration();
        in = new DataInputStream(new BufferedInputStream(new FileInputStream(AP_CONFIG_FILE)));
        int version = in.readInt();
        if (version != 1) {
            Log.e(TAG, "Bad version on hotspot configuration file, set defaults");
            setDefaultApConfiguration();
            return;
        }
        config.SSID = in.readUTF();
        int authType = in.readInt();
        config.allowedKeyManagement.set(authType);
        if (authType != KeyMgmt.NONE) {
            config.preSharedKey = in.readUTF();
        }
        config.channel = in.readInt();
        config.channelWidth = in.readInt();
        mWifiApConfig = config;
    } catch (IOException ignore) {
        setDefaultApConfiguration();
    } finally {
        if (in != null) {
            try {
                in.close();
            } catch (IOException e) {
            }
        }
    }
}
```