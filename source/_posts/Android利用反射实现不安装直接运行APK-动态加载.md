---
title: Android利用反射实现不安装直接运行APK(动态加载)
date: 2019-12-31 14:39:07
tags:
---
``` Java
public void LoadAPK(Bundle paramBundle, String dexpath, String dexoutputpath) {
    ClassLoader localClassLoader = ClassLoader.getSystemClassLoader();
    DexClassLoader localDexClassLoader = new DexClassLoader(dexpath, dexoutputpath, null, localClassLoader);
    try {
        PackageInfo plocalObject = getPackageManager().getPackageArchiveInfo(dexpath, 1);
        if ((plocalObject.activities != null) && (plocalObject.activities.length > 0)) {
            String activityname = plocalObject.activities[0].name;  
            Log.d(TAG, "activityname = " + activityname);  
            Class localClass = localDexClassLoader.loadClass(activityname);  
            Constructor localConstructor = localClass.getConstructor(new Class[] {});
            Object instance = localConstructor.newInstance(new Object[] {});  
            Log.d(TAG, "instance = " + instance);  
            Method localMethodSetActivity = localClass.getDeclaredMethod("setActivity", new Class[] { Activity.class });
            localMethodSetActivity.setAccessible(true);
            localMethodSetActivity.invoke(instance, new Object[] { this });
            Method methodonCreate = localClass.getDeclaredMethod("onCreate", new Class[] { Bundle.class });
            methodonCreate.setAccessible(true);
            methodonCreate.invoke(instance, new Object[] { paramBundle });
        }
        return;
    } catch (Exception ex) {
        ex.printStackTrace();
    }
}
```