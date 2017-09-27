---
title: adb shell input text源码分析
date: 2017-09-25 15:00:24
tags:
---
源码\system\core\toolbox目录和源码\frameworks\base\cmds目录。 
``` Java
public static void main(String[] args) {
    (new Input()).run(args);                            //在 main() 函数中运行 run() 方法
}

if (command.equals("text")) {                            //处理 text 命令
    if (length == 2) {
        inputSource = getSource(inputSource, InputDevice.SOURCE_KEYBOARD);
        sendText(inputSource, args[index+1]);
        return;
    }
}

private void sendText(int source, String text) {
    StringBuffer buff = new StringBuffer(text);
    boolean escapeFlag = false;
    for (int i=0; i<buff.length(); i++) {
        if (escapeFlag) {
            escapeFlag = false;
            if (buff.charAt(i) == 's') {
                buff.setCharAt(i, ' ');
                buff.deleteCharAt(--i);
            }
        }
        if (buff.charAt(i) == '%') {
            escapeFlag = true;
        }
    }
    char[] chars = buff.toString().toCharArray();
    KeyCharacterMap kcm = KeyCharacterMap.load(KeyCharacterMap.VIRTUAL_KEYBOARD);
    KeyEvent[] events = kcm.getEvents(chars);            //将字符转换为按键事件
    for(int i = 0; i < events.length; i++) {
        KeyEvent e = events[i];
        if (source != e.getSource()) {
            e.setSource(source);
        }
        injectKeyEvent(e);
    }
}
```