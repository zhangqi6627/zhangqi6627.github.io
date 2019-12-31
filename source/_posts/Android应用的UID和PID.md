---
title: Android应用的UID和PID
date: 2019-12-31 14:50:54
tags:
---
PID和UID存在的意义
Pid是进程ID，Uid是用户ID，只是Android和计算机不一样，计算机每个用户都具有一个Uid，哪个用户start的程序，这个程序的Uid就是那个用户，而Android中每个程序都有一个Uid，默认情况下，Android会给每个程序分配一个普通级别互不相同的 Uid，如果应用之间要互相调用，只能是Uid相同才行，这就使得共享数据具有了一定安全性，每个软件之间是不能随意获得数据的。而同一个application 只有一个Uid，所以application下的Activity之间不存在访问权限的问题。

uid共享数据实例
假设我们有这样一个需求，A和B是两个应用，现在要求在A中获取B的一张名字为icon_home的图片资源（以Drawable实例的形式呈现），那我们可以考虑将A和B的注册文件的manifest节点添加sharedUserId，并且赋值相同，然后在A中可以用如下方式实现：

``` Java
Context subContext = null;
try {
    //首先根据B应用的包名获取其上下文，注意这个方法是Context的，如果没找到会抛出异常
    subContext = createPackageContext("com.geo.plugin", Context.CONTEXT_IGNORE_SECURITY);
} catch (NameNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
}
//然后根据上下文获取资源
Resources res = subContext.getResources();
//然后根据图片的名字获取其id
int menuIconId = res.getIdentifier("icon_home", "drawable", "com.geo.plugin");
//最后根据id生产Drawable实例
Drawable drawable = res.getDrawable(menuIconId);
```

最后需要注意的是，一个应用只有一个uid，但是可以有多个pid（通过process属性来指定进程）。