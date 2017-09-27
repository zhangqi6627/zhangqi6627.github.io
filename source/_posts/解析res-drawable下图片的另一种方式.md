---
title: 解析res/drawable下图片的另一种方式
date: 2017-09-25 14:42:58
tags:
---
``` Java
if(width == 540) {
    path = "/res/drawable-960x540/paillette_" + pailletteIndex + ".png"; 
}else if(width == 480){
    path = "/res/drawable-800x480/paillette_" + pailletteIndex + ".png"; 
}else if(width == 720){
    path = "/res/drawable-1280x720/paillette_" + pailletteIndex + ".png";
}else{
    path = "/res/drawable/paillette_" + pailletteIndex + ".png"; 
}    
paillette_array[0] = BitmapFactory.decodeStream(getClass().getResourceAsStream(path));
```