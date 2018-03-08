---
title: Java的编译时多态和运行时多态
date: 2018-03-08 12:57:48
tags:
---
java的编译时多态和运行时多态

### 运行时多态和编译时多态的区别?
> 
编译时的多态,是指参数列表的不同, 来区分不同的函数, 在编译后, 就自动变成两个不同的函数名. 在运行时谈不上多态

---
> 
运行时多态:用到的是后期绑定的技术, 在程序运行前不知道,会调用那个方法, 而到运行时, 通过运算程序,动态的算出被调用的地址. 动态调用在继承的时候,方法名 参数列表完全相同时才出现运行时多态!
运行时多态,也就是动态绑定,是指在执行期间(而非编译期间)判断所引用对象的实际类型,根据实际类型判断并调用相应的属性和方法.看看下面这个例子:

``` Java
abstract class Animal {
  private String name;
  Animal(String name) {this.name = name;}
  /*
  public void enjoy(){
    System.out.println("叫声......");//父类方法,下面的子类对该方法不满意,重写.
  }
  */
  public abstract void enjoy();//该方法没有实现的必要(所以我们一般声明为静态方法),但有定义的必要.
}
class Cat extends Animal {
  private String eyesColor;
  Cat(String n,String c) {super(n); eyesColor = c;}
  public void enjoy() {
    System.out.println("猫叫声......");
  }
  
  //public abstract void enjoy();//如果不想实现父类静态方法,可将此方法声明为静态的,该类也同时为abstract
}
class Dog extends Animal {
  private String furColor;
  Dog(String n,String c) {super(n); furColor = c;}
  public void enjoy() {
    System.out.println("狗叫声......");
  }
}
class Bird extends Animal {
         Bird() {
                  super("bird");
         }
         public void enjoy() {
    System.out.println("鸟叫声......");
  }
}
class Lady {
    private String name;
    private Animal pet;
    Lady(String name,Animal pet) {
        this.name = name; this.pet = pet;
    }
    public void myPetEnjoy(){pet.enjoy();}
}
public class Test {
    public static void main(String args[]){
        Cat c = new Cat("catname","blue");
        Dog d = new Dog("dogname","black");
        Bird b = new Bird();
        //Lady l1 = new Lady("l1",c);
        Lady l2 = new Lady("l2",d);
        Lady l3 = new Lady("l3",b);
       //l1.myPetEnjoy();
        l2.myPetEnjoy();
        l3.myPetEnjoy();
    }
}
```
动态绑定的底层实现是指针,我们知道程序中的方法是一段代码,存放在专门的内存区域中(code segment---代码区),当我们在程序执行期间new 出一个对象后调用enjoy方法的时候,JVM动态的把指针指向实际的对象重写的方法,从而实现了动态绑定.
动态绑定的最大好处就是给我们的程序的可扩展性带来了相当大的提高(上面的例子中我们可以继续添加子类或是在main方法中new  lady,),如果没有动态绑定,我们一般情况下的做法是在子类中用instanceof判断一个对象是不是我们需要的当前具体对象,但当我们定义好多个子类的时候,每次都要判断,现在有了动态绑定,我们不需要再去判断,而是JVM动态给我们指向具体的对象并调用相应的属性和方法.
