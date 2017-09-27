---
title: 添加MoreRingtone菜单
date: 2017-09-22 14:08:38
tags:
---
``` Java
//packages/apps/Settings/ext/src/com/mediatek/settings/ext/DefaultAudioProfileExt.java
public void setRingtonePickerParams(Intent intent) {
    //把这个改为true就可以显示 More Ringtones ... 选项了
	intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_MORE_RINGTONES, true);    
    mHasMoreRingtone = true;
}
```