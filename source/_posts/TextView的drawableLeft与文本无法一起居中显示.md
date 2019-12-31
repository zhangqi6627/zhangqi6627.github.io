---
title: TextView的drawableLeft与文本无法一起居中显示
date: 2019-12-31 14:41:41
tags:
---
需求场景：
TextView设置的文本默认是存在一个上下间距的，也就是上下空白，当我们在使用drawableLeft的时候，这个默认的空白会使TextView中的文本向下偏移，当你的drawableLeft使用的icon很小，文字的size也很小的时候，即使你设置了android:gravity="center"，也能很明显的看到你的TextView中的文本基本上是与icon处于底边对其，而不是居中对齐（最好是在真机看，AS的Preview是没办法看到这种效果的，没办法，谁叫我们的UI是个“像素眼”，这细节揪的啊!）。

解决方法：
只要TextView中加上 android:includeFontPadding 这个属性属性就可以了!