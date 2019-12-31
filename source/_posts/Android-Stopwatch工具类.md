---
title: Android--Stopwatch工具类
date: 2019-12-31 15:48:39
tags:
---
现在我的一部分工作就是优化客户端的性能，比如优化列表快速滑动卡顿现象。

一个很好的办法就是使用DDMS的Method Profiling功能，它可以生成一个表格来显示app中所有执行的方法的执行时间，占cpu运行的百分比，还有图形化的显示。功能很强大！

但是，有的时候是跨线程工作的，比如，我获得要发送一个http请求到http请求返回时的时间，这个它就无能为力了（或许可能我没有发现这个功能）；还比如，我要获得从sd卡上读一个文件所需的时间。

一个最原始的方法就是

long start = SystemClock.uptimeMillis();
//do something
Log.i(TAG, "time: " + (SystemClock.uptimeMillis() - start));
这样就可以获得这段代码的运行时间了，我发现在测试Adapter的getView方法性能时很管用。因为ListView快速滑动时卡顿最主要的原因就是getView方法执行时间过长，我的测试过程中发现getView方法的执行时间不能超过10ms（当然这个在不同手机上运行时间不一样）。也就是如果在一个手机上getView方法执行时间超过10ms，这个列表快速滑动时就会产生卡顿现象。

但是Adapter中可能有很多方法，我要在每个方法中都像上面那样写么？我不要烦死了？

然后，我就从秒表中获得启发，我可不可以也像秒表一样写一个类来对每个方法测试它的运行时间呢？

下面这个类就诞生了，其实这个类很简单，你只需要在你需要测试时间的方法A前写一句：

StopWatch.begin("bxbxbai");
这就相当于按了一下秒表（StopWatch工具就是在HashMap中添加了一条记录），然后在方法A后面写一句：

StopWatch.end("bxbxbai");
这就相当于按了一下秒表，系统在Log中输出了方法A的的运行时间，并且把tag删除。

StopWatch.lap("bxbxbai");
这个方法不会删除tag，它会输出当前时间到打tag的时候的时间间隔，就是秒表的计次功能。

不光如此，这个类还支持跨进程，比如，我在A线程中执行begin方法，我可以在一个Callback中执行end方法，输出总共的执行时间。
