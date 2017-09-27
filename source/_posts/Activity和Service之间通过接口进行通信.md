---
title: Activity和Service之间通过接口进行通信
date: 2017-09-22 13:19:22
tags:
---
``` Java
public class MainActivity extends Activity{
    public void onCreate(Bundle savedInstanceState){
        startService(new Intent(MainActivity.this,MainService.class));
        MainService.setListener(new IListener(){
            public void updateTitle(String title){
                setTitle(title);
            }
        });
    }
    public interface IListener{
        public void updateTitle();
    }
}

public class MainService extends Service{
    public void onCreate(){
        super.onCreate();
        if(listener!=null){
            listener.updateTitle("hello");
        }
    }
    public IBinder onBind(Intent intent){
        return null;
    }
    private static IListener listener;
    public static void setListener(IListener listener){
        this.listener = listener;
    }
}
```