---
title: Android--PackageManagerService中LI/LP等函数后缀的含义
date: 2019-12-31 16:37:12
tags:
---
PackageManagerService中有很多函数带有LI，LP，或者LPr，LPw的后缀，表示什么意思？

LI  -- 该函数被调用时需要持有mInstallLock这把锁
LP  -- 该函数被调用时需要持有mPackages这个HashMap对象
LPr -- 表示读
LPw -- 表示写

343     // Lock for state used when installing and doing other long running
344     // operations.  Methods that must be called with this lock held have
345     // the prefix "LI".
346     final Object mInstallLock = new Object();

360     // Keys are String (package name), values are Package.  This also serves
361     // as the lock for the global state.  Methods that must be called with
362     // this lock held have the prefix "LP".
363     final HashMap<String, PackageParser.Package> mPackages =
364             new HashMap<String, PackageParser.Package>();
