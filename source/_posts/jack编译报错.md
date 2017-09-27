---
title: 编译报错 Out of memory error (version 1.2-rc4 'Carnac'
date: 2017-09-19 14:34:29
tags:
---
Starting build with ninja
ninja: Entering directory `.' 
[  0% 8/30301] Ensure Jack server is installed and started
Jack server already installed in "/home/guochongxin/.jack-server"
Launching Jack server java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir=/tmp -Dfile.encoding=UTF-8 -XX:+TieredCompilation -cp /home/guochongxin/.jack-server/launcher.jar com.android.jack.launcher.ServerLauncher
[  0% 10/30301] Building with Jack: out/target/common/obj/JAVA_LIBRARIES/libprotobuf-java-micro_intermediates/classes.jack
[  0% 12/30301] Building with Jack: out/target/common/obj/JAVA_LIBRARIES/framework_intermediates/with-local/classes.dex
FAILED: /bin/bash out/target/common/obj/JAVA_LIBRARIES/framework_intermediates/with-local/classes.dex.rsp
Out of memory error (version 1.2-rc4 'Carnac' (298900 f95d7bdecfceb327f9d201a1348397ed8a843843 by android-jack-team@google.com)).
GC overhead limit exceeded.
Try increasing heap size with java option '-Xmx<size>'.
Warning: This may have produced partial or corrupted output.
[  0% 12/30301] Compiling SDK Stubs with Jack: out/target/comm...AVA_LIBRARIES/android_stubs_current_intermediates/classes.jack
ninja: build stopped: subcommand failed.
make: *** [ninja_wrapper] Error 1
按照提示修改prebuilts/sdk/tools/jack-admin文件，找到如下内容：
JACK_SERVER_COMMAND="java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir
=$TMPDIR $JACK_SERVER_VM_ARGUMENTS -cp $LAUNCHER_JAR $LAUNCHER_NAME"

将其修改为：
>
JACK_SERVER_COMMAND="java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir
=$TMPDIR $JACK_SERVER_VM_ARGUMENTS -Xmx4096m -cp $LAUNCHER_JAR $LAUNCHER_NAME"
然后在源码根目录下执行如下命令：
./prebuilts/sdk/tools/jack-admin stop-server
./prebuilts/sdk/tools/jack-admin start-server
重启下jack-admin服务，此时再重新执行编译命令就能编译通过ninja了。
参考网址：
http://www.cnblogs.com/dinphy/p/6138803.html
http://blog.csdn.net/u014386544/article/details/53287861
http://berniechenopenvpn.blogspot.jp/2016/07/hikey-board-android.html