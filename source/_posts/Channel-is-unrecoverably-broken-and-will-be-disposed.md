---
title: Channel is unrecoverably broken and will be disposed
date: 2018-04-09 10:24:45
tags:
---
Channel is unrecoverably broken and will be disposed

# 第一篇
今天遇到了一个头疼的问题，就是本来程序昨天都是好好的，但是今天在该页面退出的时候就报通道破碎错误了，直接闪屏，头大，上网搜了一下资料，再结合昨晚写的代码，预估可能是网络请求的问题，搞了半天解决了，记录一下。
报错记录

```
05-25 10:52:21.125 491-528/system_process E/InputDispatcher: channel '4a8b59f4 activity.MainActivity (server)' ~ Channel is unrecoverably broken and will be disposed!
05-25 10:52:21.125 491-528/system_process E/InputDispatcher: channel '4a9790c4 activity.ShoppingCartActivity (server)' ~ Channel is unrecoverably broken and will be disposed!
```
### 出错位置
``` Java
private Handler mHandler = new Handler(){
    @Override
    public void handleMessage(Message msg) {
        super.handleMessage(msg);
        switch (msg.what){
            case KEY:
                if (ispay) {
                    Map<String, String> param = new HashMap<>();
                    String orderId = SharePreferenceUtils.readString(PayActivity.this, "user", "orderId");
                    param.put("orderId",orderId);
                    PayActivity.this.post(Api.PayResult,param, PayResultBean.class);
                }
                break;
            default:
                break;
        }
    }
};
```
这行网络请求（这是我写的一个xutils封装类里的post请求方法）出了问题：
``` Java
PayActivity.this.post(Api.PayResult,param, PayResultBean.class);
```
具体原因就是因为页面在退出的时候，该行代码依然在执行，所以报错，紧急之下也没做其他的处理，只是写了一个标志位，在页面退出的时候设置为false，这个方法其实不太好，暂时先这样，后期改进。
``` Java
@Override
protected void onDestroy() {
    super.onDestroy();
    ispay = false;
}
```

### 解决问题思路

改正后，就不在报那个错了，从报这个错误消息的情况来看，如果程序报Channel is unrecoverably broken and will be disposed!时，首先可以考虑是不是代码中某个有数据输入或是有数据输出的地方，写错了代码。

### 稍做补充

下午又遇到这个问题了，看了一下，原来是后台接口数据做了改动，我重新生成bean对象的时候，有个为long类型的数据变成了String类型我也没注意到，改正过来就好了。写代码细心很重要，引以为戒，下不为例。



# 第二篇

刚才测试代码时，报了如下的错误消息：
```
04-23 14:09:18.608: E/InputDispatcher(99): channel '405fd468 cn.jbit.NewsManager/cn.jbit.NewsManager.NewsManagerActivity (server)' ~Channel is unrecoverably broken and will be disposed!
```

由于前面写代码时，遇到过类似的错误消息，这次遇到就得心应手了，从错误的消息来看，可以确定是代码中某个有数据输入的地方写错了，于是，找到我刚才的代码中，有数据输入的地方，详见下边：

``` Java
/***
*   利用GET方式 提交 数据
* @param strtitle
* @param strauthor
* @param string
* @return
* @throws Exception 
*/
public static boolean saveByGET(String strtitle, String strauthor) throws Exception {
    StringBuffer buffer  =new StringBuffer();  
    buffer.append("?title=").append(URLEncoder.encode(strtitle, "UTF-8")+"&author=").append(URLEncoder.encode(strauthor, "UTF-8"));
    URL url  =new URL("http://192.168.137.1/JspUnit2/NewsAddServlet"+buffer.toString());
    HttpURLConnection conn =(HttpURLConnection)url.openConnection();
    conn.setConnectTimeout(5000);
    conn.setRequestMethod("GET");
    if(conn.getResponseCode()==200){
    	return true;
    }
    return false;
}
```

一看，上面的代码中，红色部分中少了:8080,不知道，自己当时是怎么了，把这个给写漏了，正确的代码应该是：
``` Java
URL url  = new URL("http://192.168.137.1:8080/JspUnit2/NewsAddServlet" + buffer.toString());
```

改正后，就不在报那个错了，从这几次，报这个错误消息的情况来看，如果程序报Channel is unrecoverably broken and will be disposed!时，首先可以考虑是不是代码中某个有数据输入或是有数据输出的地方，写错了代码。


以上是两篇 Channel is unrecoverably broken and will be disposed 的解决思路,仅供参考!