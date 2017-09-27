---
title: Observer观察者模式
date: 2017-09-22 13:17:51
tags:
---
``` Java
public class Invarient{                                        //相当于View
    private Observer observer;
    public void template_method(){                            //相当于点击了一下按钮
        observer.hook_varient();
    }
    protected void attach(Observer observer){                //相当于setOnClickListener(OnClickListener onClickListener)方法
        this.observer = observer;
    }
}
public abstract class Observer{                                //相当于OnClickListener
    public abstract void hook_varient();                    //相当于onClick(View v)方法
}
public class ConcreteObserver_Varient extends Observer{        //相当于OnClickListener的实现类
    public void hook_varient(){
        System.out.println("hook_varient...");
    }
}
public class Main{
    public static void main(String[] args){
        Invarient iv = new Invarient();                        
        iv.attach(new ConcreteObserver_Varient());            
        iv.template_method();
    }
}
```