---
title: ubuntu下cocos2dx学习
date: 2017-09-25 15:36:46
tags:
---
1. 编译cocos2dx整个工程的时候编译不过？？？

解决:
a.../CocoStudio/Reader/WidgetReader/LabelReader/LabelReader.cpp:54: error: ‘transform’ is not a member of ‘std’
只要在LabelReader.cpp文件中添加#include <algorithm> 就可以
b.会报Lua编译不过的异常
只要将cocos2dx根目录下的Makefile文件中编译Lua的部分去掉就可以了

2. 如何创建工程之后如何编译？？？

解决:
只需要执行 cocos2d-x-2.2.5/projects/FlappyBird/proj.linux/build.sh 这个脚本就可以了

3. cocos2d-x-2.2.5/projects/FlappyBird/proj.linux/../Classes/HelloWorldScene.cpp:88: undefined reference to `GameScene::scene()' 报错?????

解决:
没有将GameScene.cpp文件编进去，找不到GameScene::scene()函数的引用
需要在 Makefile 文件中添加编译 GameScene.cpp就行了

4. ../Classes/HelloWorldScene.cpp:5: error: expected unqualified-id before ‘using’？？？？

解决:
类定义的时候的问题，只需要在 GameScene.h 头文件中类定义的结尾添加";"就可以了