---
title: Android-findViewById签名变更
date: 2019-12-31 14:55:43
tags:
---
findViewById() 签名变更
现在，findViewById() 函数的全部实例均返回 <T extends View> T，而不是 View。此变更会带来以下影响：

例如，如果 someMethod(View) 和 someMethod(TextView) 均接受调用 findViewById() 的结果，这可能导致现有代码的返回类型不确定。
在使用 Java 8 源语言时，这需要在返回类型不受限制时（例如，assertNotNull(findViewById(...)).someViewMethod())）显式转换为 View。
重写非最终的 findViewById() 函数（例如，Activity.findViewById()）将需要更新其返回类型