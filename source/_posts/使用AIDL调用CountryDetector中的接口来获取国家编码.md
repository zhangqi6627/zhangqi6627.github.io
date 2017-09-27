---
title: 使用AIDL调用CountryDetector中的接口来获取国家编码
date: 2017-09-22 14:12:26
tags:
---
``` Java
//在自己的代码中使用AIDL调用CountryDetector中的接口来获取国家编码
private String getCountryCode() {
    String countryCode = "";
    try {
        Method method = Class.forName("android.os.ServiceManager").getMethod("getService", String.class);
        IBinder binder = (IBinder) method.invoke(null, new Object[] { "country_detector" });            //这里的country_detector不要写错，否则获取不到服务
        ICountryDetector countryDetector = ICountryDetector.Stub.asInterface(binder);
        Country country = countryDetector.detectCountry();
        if (country != null) {
            countryCode = country.getCountryIso();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return countryCode;
}
```
> 
tips:该方法同样使用于其他AIDL的服务