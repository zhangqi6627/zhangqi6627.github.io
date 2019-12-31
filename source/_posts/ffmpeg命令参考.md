---
title: ffmpeg命令参考
date: 2019-12-31 16:13:00
tags:
---
``` bash
ffmpeg -f v4l2 -i /dev/video0 output.mp4        #ffmpeg 获取摄像头/dev/video0并输出.mp4文件
ffplay -f rawvideo -video_size 1920x1080 a.yuv  #ffplay播放yuv文件命令
ffprobe -v quiet -print_format json -show_format -show_streams video.mp4  #将视频中的音视频信息，以json格式返回
或
ffprobe -show_format -show_streams video.mp4
```
