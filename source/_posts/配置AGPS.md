---
title: 配置AGPS
date: 2017-09-22 13:34:36
tags:
---
[FAQ03537](https://online.mediatek.com/Pages/FAQ.aspx?List=SW&FAQID=FAQ03537)
packages/apps/settings/src/com/mediatek/lbs/AgpsSettings.java
``` Java
onCreate(){
    ...
    //这个文件在mediatek/frameworks/base/agps/etc/agps_profiles_conf.xml文件中
    mAgpsProfileManager.updateAgpsProfile("/etc/agps_profiles_conf.xml");
    ...
}
```
添加一个AGPS
``` Java
<agps_profile code="Nextel Localización"
    slp_name="Nextel Localización"
    backup_slp_name_var="Nextel_SPL_Name"
    address="supl.nexteldata.com.mx"
    port="7275"
    tls="1"
    show_type="0"
/>
```
修改默认AGPS
``` Java
<agps_conf_para 
    ...
    default_profile="Nextel Localización"     //修改这个地方
    ...
/>
```