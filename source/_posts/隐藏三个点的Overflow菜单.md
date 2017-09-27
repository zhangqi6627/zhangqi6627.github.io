---
title: 隐藏三个点的Overflow菜单
date: 2017-09-21 13:23:56
tags:
---
frameworks/base/core/java/android/view/ViewConfiguration.java
``` Java
public boolean hasPermanentMenuKey() {
    // return sHasPermanentMenuKey;
    if(com.mediatek.common.featureoption.FeatureOption.SAGEREAL_REMOVE_SETTING_MENU){
    	return sHasPermanentMenuKey;
    }else{
    	return false; //add menu key
    }
}
```