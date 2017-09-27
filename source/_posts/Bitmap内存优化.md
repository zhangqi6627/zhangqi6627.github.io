---
title: Bitmap内存优化
date: 2017-09-25 15:35:36
tags:
---
1.将加载Bitmap的地方都改为加载Drawable，Drawable应该不属于常驻内存的对象,因为解析Bitmap比较消耗内存，而且Bitmap的内存不容易被系统回收
参考：http://blog.sina.com.cn/s/blog_696bcf8f0101etkd.html
例如：
获取Drawable的几种方法
((BitmapDrawable) Drawable.createFromStream(is, "test.png")).getBitmap();

2.在必须使用Bitmap的地方
a.使用BitmapFactory.Options指定解码选项
BitmapFactory.Options opts = new BitmapFactory.Options();
opts.inPurgeable = true;													//设置Options.inPurgeable和inInputShareable：让系统能及时回收内存。
//1）inPurgeable：设置为True时，表示系统内存不足时可以被回 收，设置为False时，表示不能被回收。
//2）inInputShareable：设置是否深拷贝，与inPurgeable结合使用，inPurgeable为false时，该参数无意义True：  
//share  a reference to the input data(inputStream, array,etc) 。 False ：a deep copy。
opts.inPreferredConfig = Bitmap.Config.ARGB_4444;		//这个属性可以减少图片占用的内存大小,节约一半内存

b.将Bitmap用WeakReference或SoftReference包装起来，方便系统回收

c.将一些常用的Bitmap（如主题应用图标中的foreground和background）缓存到Map中，方便再次获取，而不需要再次解析

d.在使用流的地方，一点要在finally里面讲流关闭，因为流也会占用一些内存

e.在需要使用Paint画图的地方，在确保不失真的情况下，可以将paint的anti_alias属性关闭

f.要及时回收Bitmap内存，并将bitmap设置为null
Bitmap类的构造方法都是私有的，所以开发者不能直接new出一个Bitmap对象，只能通过BitmapFactory类的各种静态方法来实例化一个Bitmap。
仔细查看BitmapFactory的源代码可以看到，生成Bitmap对象最终都是通过JNI调用方式实现的。
所以，加载 Bitmap到内存里以后，是包含两部分内存区域的。简单的说，一部分是Java部分的，一部分是C部分的。
这个Bitmap对象是由Java部分分配的，不用的时候系统就会自动回收了，但是那个对应的C可用的内存区域，虚拟机是不能直接回收的，这个只能调用底层的功能释放。
所以需要调用 recycle()方法来释放C部分的内存。从Bitmap类的源代码也可以看到，recycle()方法里也的确是调用了JNI方法了的。
例如：
if(bitmap != null && !bitmap.isRecycled()){ 
        // 回收并且置为null
        bitmap.recycle(); 
        bitmap = null; 
} 
System.gc();

g.在解析图片内存溢出的时候捕获Error重新解析

例如：
private void decodeBitmap(String path){
	Bitmap bitmap = null;
	try {
		// 实例化Bitmap
		bitmap = BitmapFactory.decodeFile(path);
	} catch (OutOfMemoryError e) {
		e.printStackTrace();
		System.gc();
		decodeBitmap(path);
		
	}
}

h.尝试使用cocos2dx做《WorldCup》的动态壁纸？

i.查看是否有内存泄露

可以使用Eclipse中的DDMS视图查看
先在Device中选择一个进行，点击上面的update heap按钮，在点击heap中的cause gc按钮，就会在下面显示某个进程的内存使用情况了
如果存在内存泄露，gc之后内存不会有明显变化，内存还是会一直增加

j.将解析图片的方法放在子线程中进行，防止主线程阻塞出现ANR

k.研究一下gallery加载图片的方法

l.使用多分辨率图片设计[hdpi,mdpi,ldpi,xhdpi]。UI图片分别设计hdpi,mdpi,ldpi,xhdpi等多种规格，这也是官方推荐的方式，
使用这种方式，还有好处就是可以降低峰值内存，优先避免内存溢出。在android中图片的加载会根据分辨率来自动缩放【缩放的过程会额外消耗内存】
 
m.如何在WallpaperService.Engine中使用Animation???

n.使用decodeStream代替其他decodeResource,setImageResource,setImageBitmap等方法：
//decodeStream直接调用 JNI>>nativeDecodeAsset()来完成decode，无需再使用java层的createBitmap，也不使用java空间进行分辨率适配，虽节省dalvik内存，但需要在hdpi和mdpi，ldpi中配置相应的 图片资源，否则在不同分辨率机器上都是同样大小（像素点数量）。其他方法如setImageBitmap、setImageResource、 BitmapFactory.decodeResource在完成decode后，最终都是通过java层的 createBitmap来完成的，需要消耗更多内存。

o.通过程序设定增强内存处理效率和自定义堆内存大小。