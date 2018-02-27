---
title: Intent的高级写法
date: 2017-09-28 15:39:49
tags:
---


Intent的高级写法?

1.普通写Intent的方法和缺陷

普通activity a要调用起activity b页面会这么写:
MainActivity.java
``` Java
Intent intent = new Intent(MainActivity.this, SecondActivity.class);
intent.putExtra("is_index", message);
startActivity(intent);
```

SecondActivity.java
``` Java
@Override
protected void onCreate(Bundle savedInstanceState) {        
    super.onCreate(savedInstanceState);
    ...
    String is_index = getIntent().getExtras().getString("is_index");
    ...
}
```

> 
上面的写法是大多数Intent写法，在发起方创建intent。但这种写法在代码量大大增加的时候会出现一个问题。当activity b在各种地方都会被调用起的时候，并且会传入各种各样不同的extra字段时，会发现很混乱，哪些发起方使用了哪些extra字段，每个字段什么意思，哪些是必须的等等问题。最终造成b代码可读性变差，让以后想要调用起b的页面也不清楚需要传入哪些extra。
so，根据以上问题，无意间看到了google官方example代码里一个使用intent的小技巧。

2.优化写Intent

MainActivity.java
``` Java
Intent intent = SecondActivity.newIndexIntent(this, text);
startActivity(intent);
```

SecondActivity.java
``` Java
private final static String IS_INDEX = "is_index";

@Override
protected void onCreate(Bundle savedInstanceState) {        
    super.onCreate(savedInstanceState);
    ...
    String is_index = getIntent().getExtras().getString(IS_INDEX);
    ...
}
public static Intent newIndexIntent(Context context, String message) {
    Intent newIntent = new Intent(context, b.class);
    newIntent.putExtra(IS_INDEX, message);
    return newIntent;
}
```