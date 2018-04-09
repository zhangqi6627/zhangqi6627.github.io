---
title: The application may be doing too much work on its main thread
date: 2018-04-09 10:34:00
tags:
---
在 mtklog 中搜索 grep "Skipped.*frames" ./ -ri ,搜索结果如下:
```
./main_log:04-02 12:59:51.789230 6259 6259 I Choreographer: Skipped 67 frames! The application may be doing too much work on its main thread.
./main_log:04-02 12:59:54.948920 6259 6259 I Choreographer: Skipped 114 frames! The application may be doing too much work on its main thread.
./main_log:04-02 12:59:55.683659 6259 6259 I Choreographer: Skipped 41 frames! The application may be doing too much work on its main thread.
./main_log:04-02 12:59:58.288454 6259 6259 I Choreographer: Skipped 152 frames! The application may be doing too much work on its main thread.
./main_log:04-02 12:59:59.693032 6259 6259 I Choreographer: Skipped 71 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:02.947048 6259 6259 I Choreographer: Skipped 71 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:03.461233 6259 6259 I Choreographer: Skipped 30 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:04.653194 6259 6259 I Choreographer: Skipped 31 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:07.490548 6259 6259 I Choreographer: Skipped 58 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:08.920317 11468 11468 I Choreographer: Skipped 53 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:35.015765 6259 6259 I Choreographer: Skipped 49 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:36.722107 894 894 I Choreographer: Skipped 51 frames! The application may be doing too much work on its main thread.
./main_log:04-02 13:00:38.924398 894 894 I Choreographer: Skipped 32 frames! The application may be doing too much work on its main thread.
```

从log中看出有很多地方在掉帧,在网上查到出现 The application may be doing too much work on its main thread 的原因如下:
意思是：主线程中有耗时操作，主线程受不了了。原因是我在重写callback的handleMessage方法时，模拟了延时操作。实际在开发中，这种情况是万万不可的，解决办法是实现android的两大原则：

> 
1. 不要！不要在主线程（UI线程）中执行耗时操作，如网络请求，数据库操作等。应另开线程操作，实现方式有1) 自开线程new Thread；2) runOnUIThread; 3) post方法以及4) 异步AsyncTask
2. 一定！一定要在主线程（UI线程）中修改控件的状态。否则会报：Only the original thread that created a view hierarchy can touch its views

英文原版解释:
Anyone who begins developing android application sees this message on logcat “Choreographer(abc): Skipped xx frames! The application may be doing too much work on its main thread.” So what does it actually means, why should you be concerned and how to solve it.

What this means is that your code is taking long to process and frames are being skipped because of it, It maybe because of some heavy processing that you are doing at the heart of your application or DB access or any other thing which causes the thread to stop for a while. Here is a more detailed explanation –

Choreographer lets apps to connect themselves to the vsync, and properly time things to improve performance.

Android view animations internally uses Choreographer for the same purpose: to properly time the animations and possibly improve performance.

Since Choreographer is told about every vsync events, I can tell if one of the Runnables passed along by the Choreographer.post* apis doesnt finish in one frame’s time, causing frames to be skipped.

In my understanding Choreographer can only detect the frame skipping. It has no way of telling why this happens.

The message “The application may be doing too much work on its main thread.” could be misleading.

source :  http://stackoverflow.com/questions/11266535/meaning-of-choreographer-messages-in-logcat

Why you should be concerned
When this message pops up on android emulator and the number of frames skipped are fairly small (<100) then you can take a safe bet of the emulator being slow – which happens almost all the times. But if the number of frames skipped and large and in the order of 300+ then there can be some serious trouble with your code. Android devices come in a vast array of hardware unlike ios and windows devices. The RAM and CPU varies and if you want a reasonable performance and user experience on all the devices then you need to fix this thing. When frames are skipped the UI is slow and laggy, which is not a desirable user experience.

How to fix it
Fixing this requires identifying nodes where there is or possibly can happen long duration of processing. The best way is to do all the processing no matter how small or big in a thread separate from main UI thread. So be it accessing data form SQLite Database or doing some hardcore maths or simply sorting an array – Do it in a different thread

Now there is a catch here, You will create a new Thread for doing these operations and when you run your application, it will crash saying “Only the original thread that created a view hierarchy can touch its views“. You need to know this fact that UI in android can be changed by the main thread or the UI thread only. Any other thread which attempts to do so, fails and crashes with this error. What you need to do is create a new Runnable inside runOnUiThread and inside this runnable you should do all the operations involving the UI. Find an example here.

So we have Thread and Runnable for processing data out of main Thread, what else? There is AsyncTask in android which enables doing long time processes on the UI thread. This is the most useful when you applications are data driven or web api driven or use complex UI’s like those build using Canvas. The power of AsyncTask is that is allows doing things in background and once you are done doing the processing, you can simply do the required actions on UI without causing any lagging effect. This is possible because the AsyncTask derives itself from Activity’s UI thread – all the operations you do on UI via AsyncTask are done is a different thread from the main UI thread, No hindrance to user interaction.

So this is what you need to know for making smooth android applications and as far I know every beginner gets this message on his console.