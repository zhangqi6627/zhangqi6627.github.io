---
title: 两个Activity之间通过接口进行通信
date: 2017-09-22 13:18:42
tags:
---
``` Java
public class MainActivity extends Activity{
    public void onCreate(Bundle savedInstanceState){
        startActivity(new Intent(MainActivity.this,SecondActivity.class));
        SecondActivity.setListener(new IListener(){
            public void updateTitle(String title){
                setTitle(title);
            }
        });
    }
    public interface IListener{
        public void updateTitle(String title);
    }
}

public class SecondActivity extends Activity{
    public void onCreate(Bundle savedInstanceState){
        findViewById(R.id.btn_update).setOnClickListener(new OnClickListener(){
            public void onClick(View v){
                listener.updateTitle("hello");        //这里调用接口中的方法
            }
        });
    }
    private static IListener listener;
    public static void setListener(IListener listener){
        this.listener = listener;
    }
}
```