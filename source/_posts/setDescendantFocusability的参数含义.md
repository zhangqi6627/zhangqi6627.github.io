---
title: setDescendantFocusability的参数含义
date: 2017-09-21 13:39:14
tags:
---
beforeDescendants:viewgroup会优先其子类控件而获取到焦点
afterDescendants:viewgroup只有当其子类控件不需要获取焦点时才获取焦点
blocksDescendants:viewgroup会覆盖子类控件而直接获得焦点

ViewGroup.java
``` Java
public void setDescendantFocusability(int focusability) {
    switch (focusability) {
    case FOCUS_BEFORE_DESCENDANTS:
    case FOCUS_AFTER_DESCENDANTS:
    case FOCUS_BLOCK_DESCENDANTS:
        break;
    default:
        throw new IllegalArgumentException("must be one of FOCUS_BEFORE_DESCENDANTS, FOCUS_AFTER_DESCENDANTS, FOCUS_BLOCK_DESCENDANTS");
    }
    mGroupFlags &= ~FLAG_MASK_FOCUSABILITY;
    mGroupFlags |= (focusability & FLAG_MASK_FOCUSABILITY);
}
```