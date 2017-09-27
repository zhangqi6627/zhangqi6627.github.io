---
title: android清理缓存功能的实现
date: 2017-09-21 11:15:46
tags:
---
相关代码:
``` Java
private void clearCache() {
    PackageManager pm = getPackageManager();
    // 反射
    try {
        Method method = PackageManager.class.getMethod("getPackageSizeInfo", new Class[] { String.class, IPackageStatsObserver.class });
        method.invoke(pm, new Object[] { "com.wang.clearcache", new IPackageStatsObserver.Stub() {
            public void onGetStatsCompleted(PackageStats pStats, boolean succeeded) throws RemoteException {
                long cachesize = pStats.cacheSize;
                long codesize = pStats.codeSize;
                long datasize = pStats.dataSize;
                System.out.println("cachesize:" + cachesize);
                System.out.println("codesize:" + codesize);
                System.out.println("datasize" + datasize);
            }
        }});
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

需要导入两个 aidl 文件
```
frameworks/base/core/java/android/content/pm/PackageStats.aidl
frameworks/base/core/java/android/content/pm/IPackageStatsObserver.aidl
```

需要添加权限
```
<uses-permission android:name="android.permission.GET_PACKAGE_SIZE"/>
```