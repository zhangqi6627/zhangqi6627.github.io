---
title: 隐藏QuickSettings中的AutoRotate菜单
date: 2017-09-22 10:26:49
tags:
---
frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/QuickSettings.java
``` Java
if (mContext.getResources().getBoolean(R.bool.quick_settings_show_rotation_lock)) {
    parent.addView(rotationLockTile);
    rotationLockTile.setVisibility(View.GONE);		//这里把它给隐藏了
} else {
    parent.addView(autoRotateTile);
    autoRotateTile.setVisibility(View.GONE);		//这里把它给隐藏了
}
```