---
title: 通过反射获取FeatureOption中的所有字段的值
date: 2017-09-25 14:48:36
tags:
---
``` Java
private String getFields() {
    StringBuilder builder = new StringBuilder();
    try {
        Class clazz = Class.forName("com.mediatek.common.featureoption.FeatureOption");  //通过反射可以获取 FeatureOption.java文件中定义的所有的宏还有宏的值
        Field[] fields = clazz.getDeclaredFields();
        for (int i = 0; i < fields.length; i++) {
            if ("boolean".equalsIgnoreCase(fields[i].getType().getName())) {
                Log.e("test", fields[i].getName() + ":" + fields[i].getBoolean(clazz));
                builder.append(fields[i].getName() + ":" + fields[i].getBoolean(clazz) + "\n");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return builder.toString();
}
```