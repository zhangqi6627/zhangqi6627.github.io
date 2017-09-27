---
title: Toast优化
date: 2017-09-22 11:14:53
tags:
---
``` Java
private Toast mToast;
private void showToast(String msg){
    if(mToast == null){
        mToast = Toast.makeText(mContext,"",2000);
    }
    mToast.setText(msg);
    mToast.show();
}
```