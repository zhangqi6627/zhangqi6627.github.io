---
title: Android反射调用通知栏回收
date: 2019-12-31 14:04:21
tags:
---
``` Java
Class<?> serviceManagerClass;
serviceManagerClass = Class.forName("android.os.ServiceManager");
Method getService = serviceManagerClass.getMethod("getService", String.class);
IBinder retbinder = (IBinder) getService.invoke(serviceManagerClass, "statusbar");
Class<?> statusBarClass = Class.forName(retbinder.getInterfaceDescriptor());
Object statusBarObject = statusBarClass.getClasses()[0].getMethod("asInterface", IBinder.class).invoke(null, new Object[] { retbinder });
Method collapsePanels = statusBarClass.getMethod("collapsePanels");
collapsePanels.setAccessible(true);
collapsePanels.invoke(statusBarObject);
```