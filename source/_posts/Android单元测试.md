---
title: Android单元测试
date: 2017-09-22 12:48:21
tags:
---
## 1.测试Activity?
``` Java
public class ActivityTest extends ActivityInstrumentationTestCase2<HelloWorldActivity>{
    private Activity activity;
    private TextView textView;
    public ActivityTest(){
        super("com.qust.zq.math.test",HelloWorldActivity.class);
    }
    protected void setUp() throws Exception{
        super.setUp();
        activity = this.getActivity();
        textView = (TextView)activity.findViewById(R.id.textView);
    }
    public void testTextContent() throws Exception{
        assertEquals("hello world",textView.getText().toString());
    }
    public void testTextComponent() throws Exception{
        assertNotNull(textView);
    }
}
```

## 2.测试ContentProvider?
``` Java
public class ContentProviderTest extends ProviderTestCase2<FriendProvider>{
    private Cursor cursor;
    private String name;
    public ContentProviderTest(){
        super(FriendProvider.class,"com.qust.zq.math.test");
    }
    protected void setUp() throws Exception{
        super.setUp();
        try{
            cursor = getProvider().query(Uri.parse("content://com.qust.zq.math.test/friend/"),null,null,null,null);
            if(cursor.moveToFirst()){
                name = cursor.getString(cursor.getColumnIndex("name"));
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public void testCursor() throws Exception{
        assertNotNull(cursor);
    }
    public void testName(){
        assertEquals("xiaozhang",name);        //这里的查询结果的记录条数为0???????
    }
}
```

## 3.测试Service?

``` Java
public class ServiceTest extends ServiceTestCase<MyService>{
    private MyService service;
    public ServiceTest(){
        super(MyService.class);
    }
    protected void setUp() throws Exception{
        super.setUp();
        Intent intent = new Intent(mContext,MyService.class);        //这里的mContext是ServiceTestCase中的成员变量
        startService(intent);
        service = getService();
    }
    public void testService(){
        assertNotNull(service);
    }
    public void testResource(){
        assertEquals("test service",service.getString(R.string.app_name));
    }
}
```

## 4.测试普通类?

``` Java
public class MyClass{
    private String name = "Android";
    public String getName(){
        return name;
    }
}

public class Test extends AndroidTestCase{
    private MyClass myClass;
    protected void setUp() throws Exception{
        super.setUp();
        myClass = new MyClass();
    }
    public void testName(){
        assertEquals("Android",myClass.getName());
    }
}
```