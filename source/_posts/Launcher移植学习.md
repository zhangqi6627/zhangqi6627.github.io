---
title: Launcher移植学习
date: 2018-03-08 09:50:39
tags:
---
1.移植R5的Tecno_Launcher2????

解决:
移植完毕

2.添加接口setStatusBarBg()？？？

解决:
需要修改以下几个文件
``` Java
//frameworks/base/core/java/android/app/StatusBarManager.java
public void setStatusBarBg(int statusBarBg) {					//添加 setStatusBarBg(int color) 方法
    try {
        final IStatusBarService svc = getService();
        if (svc != null) {
            mService.setStatusBarBg(statusBarBg);
        }
    } catch (RemoteException ex) {
        /// M: system process is dead anyway.
        throw new RuntimeException(ex);
    }
}

//frameworks/base/core/java/com/android/internal/statusbar/IStatusBarService.aidl
void setStatusBarBg(int color);									//添加 IStatusBarService.aidl 中的 setStatusBarBg(int color)接口

//frameworks/base/services/java/com/android/server/StatusBarManagerService.java
public void setStatusBarBg(int statusBarBg) {					//实现 IStatusBarService.aidl 中的 setStatusBarBg(int color)接口
    if (mBar != null) {
        try {
            mBar.setStatusBarBg(statusBarBg);
        } catch (RemoteException ex) {
            ex.printStackTrace();
        }
    }
}

//frameworks/base/core/java/com/android/internal/statusbar/IStatusBar.aidl
void setStatusBarBg(int color);									//添加 IStatusBar.aidl 中的 setStatusBarBg(int color)接口

//frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/CommandQueue.java
public void setStatusBarBg(int statusBarBg) {
    synchronized (mList) {
        mHandler.obtainMessage(MSG_SET_STATUSBAR, statusBarBg, 0, null).sendToTarget();
    }
}
//在H(Handler)中添加对MSG_SET_STATUSBAR的处理
case MSG_SET_STATUSBAR:
    mCallbacks.setStatusBarBg(msg.arg1);
    break;
//在 CommandQueue.Callbacks 接口中添加 setStatusBarBg() 接口
setStatusBarBg(int color)

//frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/BaseStatusBar.java
public void setStatusBarBg(int color){}				//在这里实现 CommandQueue.Callbacks 中的 setStatusBarBg()接口

//frameworks\base\packages\systemui\src\com\android\systemui\statusbar\phone\PhoneStatusBar.java	extends BaseStatusBar
public void setStatusBarBg(int color) {
    mStatusBarView.setBackgroundColor(color);		//这里也有对 CommandQueue.Callbacks 中的 setStatusBarBg()接口的实现
}

//frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/PhoneStatusBarView.java	中有对 setBackgroundColor()的实现
@RemotableViewMethod
public void setBackgroundColor(int color) {
    if (mBackground instanceof ColorDrawable) {
        ((ColorDrawable) mBackground.mutate()).setColor(color);
        computeOpaqueFlags();
        mBackgroundResource = 0;
    } else {
        setBackground(new ColorDrawable(color));
    }
}
```

3.修改 Apps 和 Widgets 字体的大小和宽度？？？

解决:
在 AppsCustomizeTabHost.java 文件的 onFinishInflate() 方法中修改
``` Java
//Apps
tabView.setTextSize(TypedValue.COMPLEX_UNIT_PX, 25);
tabView.setWidth(129);
//Widgets
widgettabView.setTextSize(TypedValue.COMPLEX_UNIT_PX, 25);
widgettabView.setWidth(250);
```

4.AppsCustomizerTabHost 上右边的两个按钮 market_button 和 tecno_order_button ？？？

解决:
将 apps_customize_pane.xml 中的 RelativeLayout中的 android:layout_marginLeft 改为 187dp 就能在tab下面显示一条完美的横线了
market_button还是没有显示出来

5.如何将 AppsCustomizerTabHost 下面蓝色的 indicator 替换为 三角箭头????

解决:
只要将 values/styles.xml 文件中的 TabIndicator 的
``` xml
<item name="android:background">@drawable/tab_widget_indicator_selector</item>
修改为
<item name="android:background">@drawable/buttonbarbackground</item>
```

6.修改Launcher里面应用图标大小，应用字体大小？？？

解决:
PagedViewIcon.java中添加 setTextSize(12); 设置应用标题的字体
在 dimens.xml 文件中修改如何参数来修改图标的大小
``` xml
<dimen name="app_icon_size">54dp</dimen>				
<dimen name="apps_customize_cell_width">100dp</dimen>
<dimen name="apps_customize_cell_height">140dp</dimen>
```

7.有些应用的图标显示会比较大，如《梦宝谷》？？？

解决:
已去掉该应用，去掉该应用的方法参考《问题55》

8.apps_customize_pane.xml 上的 market_button 按钮还是没有显示出来？？？

解决:
只要预置了Goole Play store就会显示出来

9.在widget列表界面每一项的右下角添加一个指示 n * m 的 图标？？？

解决:
添加一个DimsView自定义View

10. widget 列表的绘制？？？

解决:
在 PagedViewGridLayout.java的 dispatchDraw()方法中绘制 widget 列表的横线和竖线
``` Java
//mFirstLine = 240;												//这个变量可以去掉的，因为在cellWidth中控制widget的高度和宽度之后就可以控制 mFirstLine 的大小了
canvas.drawLine(0, mFirstLine, 480, mFirstLine, mPaint);		//在这里只需要将 720 改为 480 ，将 360 改为 240 就可以了
canvas.drawLine(0, mFirstLine*2, 480, mFirstLine*2, mPaint);
canvas.drawLine(0, mFirstLine*3, 480, mFirstLine*3, mPaint);
canvas.drawLine(240, 0, 240, mFirstLine*3, mPaint);
```

11. 控制每一个widget列表项的大小？？？

解决:
在 apps_customize_widget_add.xml 文件中有每一个列表项的布局		//注意这里用的是 apps_customize_widget_add.xml 而不是 apps_customize_widget.xml
在 AppsCustomizePagedView.java 的 syncWidgetPageItems()方法中将每一个 widget 添加到列表中
final int cellWidth = 217;		//用于控制每一个widget的显示宽度				
final int cellHeight = 190;		//用于控制每一个widget的显示高度			这样控制是不是不太好，是不是应该控制每一个 cellHeight 计算公式中的变量来控制比较好

12.apps列表下面的 indicator ????

解决:
在 AllAppPageControlView.java 文件中有 pageID = { R.drawable.page_unit_nor, R.drawable.page_unit_active };	//这两张图片就是下面的indicator图片
在 PagedView.java 中使用 AllAppPageControlView

13.widget列表下面的 indicator 不会随页数的变化而变化？？？

解决:
主要在 AllAppPageControlView.java 中添加
``` Java
public void bindWidgetView(AppsCustomizePagedView allapppage) {
    Log.v("sw98","bindPageView allapppage.mCurrentPage == "+allapppage.mCurrentPage);
    Log.v("sw98","bindPageView allapppage.mNumAppsPages() == "+allapppage.mNumAppsPages);
    this.count = allapppage.mNumWidgetPages;
    mPagedView = allapppage;
}
```

14.app列表和widget列表的黑色背景怎么改？？？

解决:
只要将 TECNO_THEME_SUPPORT 的宏打开为yes就可以了

15.修改Hotseat上图标的大小？？？

解决:
将values/dimens.xml文件中的hotseat_cell_width改为64dp
将layout-port/hotseat.xml文件中的android:layout_width改为match_parent

16.去掉widget列表上第一个小部件《应用》小部件的缩略图？？？

17.点击Menu键的时候会右移一大块？？？

解决:
//packages/apps/Tecno_Launcher2/src/com/android/launcher2/Hotseat.java 文件中把 720 都改为 480 即可

18.修改Folder的布局？？？

解决:
修改 packages/apps/Tecno_Launcher2/src/com/android/launcher2/Folder.java 文件中的 centerAboutIcon()方法中的
``` Java
lp.width = 480;
lp.height = 800;
lp.x = 80;
lp.y = 100;
修改 packages/apps/Tecno_Launcher2/src/com/android/launcher2/Folder.java 文件中的 onMeasure()方法中
int contentWidthSpec = MeasureSpec.makeMeasureSpec(430, MeasureSpec.EXACTLY);
int contentHeightSpec = MeasureSpec.makeMeasureSpec(650, MeasureSpec.EXACTLY);
```

19.Folder文件夹中可以存放的应用数量在哪里设定？？？

解决:
// packages/apps/Tecno_Launcher2/src/com/android/launcher2/Folder.java 的构造函数 public Folder() 中有如下数值
``` Java
mMaxCountX = 3;//res.getInteger(R.integer.folder_max_count_x);
mMaxCountY = 5;//res.getInteger(R.integer.folder_max_count_y);
mMaxNumItems = 15;
```

20.修改桌面下方页面控制pageControl的显示位置？？？

解决:
只要修改 packages/apps/Tecno_Launcher2/res/layout-port/launcher.xml 中的 PageControlView(R.id.pageControl) 的 android:layout_marginBottom="80dp" 即可

21.修改上 Folder 文件夹图标的大小？？？Folder文件夹的大小和app的大小不太一致????????

解决:
``` xml
<dimen name="folder_preview_size">48dp</dimen>
```

22.替换主页面上应用列表按钮的资源图片？？？

解决:
//只要替换下面这两张图片就行了
packages/apps/Tecno_Launcher2/res/drawable-hdpi/ic_allapps.png
packages/apps/Tecno_Launcher2/res/drawable-hdpi/ic_allapps_pressed.png		//这张图片还需要替换

23.修改编辑屏幕的布局？？？

解决:
替换为 R5 的 Tecno_Launcher 就可以了

24.Folder 文件夹在编辑的时候没有显示删除图标？？

25.GlobalDialog关机对话框中的图片资源乱，需要编译哪些模块？？

解决:
在修改了frameworks/base/core/res/res/下的资源后GlobalDialog关机对话框中的图片资源乱掉了
首先应该将 out/target/common/obj/APPS/framework-res_intermediates 文件夹彻底删除
再重新编译push ./mk -t mm frameworks/base/core/res/res
再重新编译push ./mk -t mm frameworks/base
再重新编译push ./mk -t mm frameworks/base/policy

26.左边的Hotseat启动不了 Theme 和 Wallpaper ？？？

解决:
Unable to find explicit activity class {com.android.launcher/com.android.launcher2.ThemeChooser}; have you declared this activity in your AndroidManifest.xml?
Theme启动不了:重新添加一个ThemeChooserTest
真正有效的解决方法:
``` Java
在LauncherApplication.java中将 PackageManager.COMPONENT_ENABLED_STATE_DISABLED 改为 PackageManager.COMPONENT_ENABLED_STATE_ENABLED	再运行一次,再改回去
static final ComponentName DISABLED_ACTIVITY_COMPONENTNAME = new ComponentName("com.android.launcher", "com.android.launcher2.ThemeChooser");
mPackageManager.setComponentEnabledSetting(DISABLED_ACTIVITY_COMPONENTNAME, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, 0);		//启用ThemeChooser
mPackageManager.setComponentEnabledSetting(DISABLED_ACTIVITY_COMPONENTNAME, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, 0);	//禁用ThemeChooser
```
上面的代码只要运行一次之后就永久生效，不管是否重启，由于一开始TECNO_THEME_SUPPORT的宏没有打开，导致运行了一次禁用 ThemeChooser 的代码，把ThemeChooser永远禁用了，需要再运行一次启用ThemeChooser的代码才能把应用给显示出来

wallpaper 启动不了:将 Tecno_Wallpaper 应用拷贝过来编译push就行了

27.设置了主题之后，动态壁纸没有替换？？？

解决:
需要将R5上的packages/wallpaper/ 目录下的动态壁纸的应用也一起移植过来

《简约》风格的主题没有设置之后没起作用？？？？
需要修改frameworks/base/core/res/res/drawable-nodip/default_wallpaper.jpg 默认壁纸
需要添加《问题29》所修改的主题图标功能

28.workspace 上的 widget 列表没有显示出来？？？需要稍微调一下布局

解决:
//代码中有
``` Java
widgettabView.setText("");
widgettabView.setClickable(false);
widgettabView.setLayoutParams(new LinearLayout.LayoutParams(0, LayoutParams.WRAP_CONTENT, 5));	//widget列表显示是有显示的，但没有标题Widgets,显示出来之后也不能跳转到widget列表页
```

29.workspace 上的应用的图标没有跟着主题的变化而变化？？？

解决:
``` Java
//声明接口
//在frameworks/base/core/java/android/content/pm/PackageManager.java	 中添加 getFancyDrawable()接口
public abstract Drawable getFancyDrawable(String packageName, int resid,ApplicationInfo appInfo);

//声明api
//在frameworks/base/api/current.txt 文件需要添加api接口声明
method public abstract android.graphics.drawable.Drawable getFancyDrawable(java.lang.String, int, android.content.pm.ApplicationInfo);
method public android.graphics.drawable.Drawable getFancyDrawable(java.lang.String, int, android.content.pm.ApplicationInfo);

//实现接口
//在frameworks/base/core/java/android/app/ApplicationPackageManager.java 中实现getFancyDrawable()接口
//在frameworks/base/test-runner/src/android/test/mock/MockPackageManager.java 中也需要实现getFancyDrawable()接口

//调用接口
//在frameworks/base/core/java/android/content/pm/PackageItemInfo.java中的调用这个方法
public Drawable loadIcon(PackageManager pm) {
    if (icon != 0) {
        Drawable dr = null;		
        if(FeatureOption.TECNO_THEME_SUPPORT) {
            dr = pm.getFancyDrawable(packageName,icon,getApplicationInfo());		//在这里调用getFancyDrawable()方法
        } else {
            dr = pm.getDrawable(packageName, icon, getApplicationInfo());
        }
        if (dr != null) {
            return dr;
        }
    }
    return loadDefaultIcon(pm);
}
```

30.下拉状态栏StatusBar上通知栏的布局怎么修改？？

解决:
``` xml
//symbols.xml
<java-symbol type="id" name="img_back" />
<java-symbol type="drawable" name="notify_panel_notification_icon_bg" />
<java-symbol type="drawable" name="notify_panel_notification_icon_bg2" />
```

``` Java
//Notification.java 在 RemoteViews applyStandardTemplate()方法上添加
contentView.setImageViewResource(R.id.img_back, R.drawable.notify_panel_notification_icon_bg2);
//上面这几个貌似不需要添加，添加了之后很多应用程序会报错？？？？？？？？？？？？？？？

//notification_template_base.xml文件中添加 img_frame 和 img_back

//在drawable-hdpi下添加替换如下图片
frameworks/base/core/res/res/drawable-hdpi/notification_bg_low_normal.9.png
frameworks/base/core/res/res/drawable-hdpi/notification_bg_low_pressed.9.png
frameworks/base/core/res/res/drawable-hdpi/notification_bg_normal.9.png
frameworks/base/core/res/res/drawable-hdpi/notification_bg_normal_pressed.9.png
frameworks/base/core/res/res/drawable-hdpi/notify_panel_notification_icon_bg.png
frameworks/base/core/res/res/drawable-hdpi/notify_panel_notification_icon_bg2.png
```

31.workspace 上的 Folder 文件夹里面放上15个快捷方式的时候没有显示完全???

解决:
``` xml
//在 user_folder.xml 中有
<com.android.launcher2.CellLayout
...
launcher:cellWidth="@dimen/folder_cell_width"		//这个参数控制Folder文件夹中每一个item的宽度
launcher:cellHeight="@dimen/folder_cell_height"/>	//这个参数控制Folder文件夹中每一个item的高度
//在 dimens.xml 中有
<dimen name="folder_cell_width">74dp</dimen>
<dimen name="folder_cell_height">85dp</dimen>		//要修改每一个Folder中Item的高度只需要修改这个参数为 80dp 就可以了
```

32.StatusBar上的某些字符串没有翻译,在中文下也显示英文???

解决:
//在frameworks/base/packages/SystemUI/res/values-zh/strings.xml文件中添加如下字符串即可
``` xml
<string name="torch">手电筒</string>
<string name="calculator">计算器</string>
<string name="camera">相机</string>
<string name="recorder">录音机</string>
<string name="stopWatch">计时器</string>
<string name="notify">通知</string>
<string name="onoff">开关</string>
<string name="wifihotspot">WLAN热点</string>
<string name="delete_all">移除所有应用</string>
<string name="app_manager">管理应用</string>
```

33.通知栏上的每一条通知的标题没有显示黑色???每一条通知的圈圈里面的图片在哪里替换????

解决:
//标题黑色:
//frameworks/base/core/res/res/values/styles.xml
``` xml
<style name="TextAppearance.StatusBar.EventContent.Title">
    <item name="android:textColor">#ffffff</item>		//把 #ffffff 修改为 #000000 就可以了
</style>
```
//圈圈里面的图片:
这个貌似需要在每个发送通知的地方修改

34.如何修改Notification上的黑色背景???

解决:
//frameworks/base/packages/SystemUI/res/colors.xml
``` xml
<color name="notification_panel_solid_background">#ffffffff</color>	//把这里原来的#ff000000修改为#ffffffff就行了
```

35.某些APK打开之后会报错???如时钟,settings中的某些地方???貌似有ActionBar的地方都会报错？？？

解决:
修改Notification引起的报错
还不知道是什么原因引起的报错，但知道怎么修改可以让它不报错，只要将《问题30》中frameworks/base/core/res下的修改全部还原之后就可以了

36.Folder上的四个小图标是怎么画出来的?????

37.修改 innertheme1 主题中的默认壁纸？？？

解决:
``` Java
//在 packages/apps/TECNO_Launcher2/src/com/android/launcher2/ThemePreview.java 中有
InputStream is = context.getResources().openRawResource(com.android.internal.R.drawable.default_wallpaper);
//需要将innertheme1的默认壁纸改为从innertheme1的文件夹中获取吗？？可以修改代码如下
try{
    is = context.getAssets().open("innertheme1/wallpaper.png");
}catch(Exception e){
    e.printStackTrace();
    is = context.getResources().openRawResource(com.android.internal.R.drawable.default_wallpaper);			
}
```
//默认壁纸所在路径，默认壁纸貌似必须使用.jpg格式的图片
frameworks/base/core/res/res/drawable-nodip/default_wallpaper.jpg
	
38.如何添加TECNO主题上的动态壁纸？？？？

解决:
需要将R5上的packages/wallpaper下的 Leaves 和 WorldCup 主题应用拷贝过来，并编译push到手机上，在ProjectConfig.mk和common.mk文件中添加宏控

39.预置 Tecno_Launcher2 的时候需不需要先编译Launcher2然后再编译Tecno_Launcher2????

解决:
不需要，只要在TECNO_Launcher2的Android.mk文件中添加 LOCAL_OVERRIDES_PACKAGES := Home Launcher2 Launcher3 就OK了

40.时钟Widget添加到桌面上之后显示不正常？？？？

解决:
在DigitalAppWidgetProvider.java中的updateClock()方法中有
``` Java
float ratio = WidgetUtils.getScaleRatio(context, newOptions, appWidgetId);
WidgetUtils.setClockSize(context, widget, ratio);				//只要把最后一个参数ratio改为1就可以显示正常了
density:1.5 minHeight:24 lblBox:28.35 widget_height:193.5		//或者可以修改这里的minHeight
ratio:((1.5 * 24) - 28.35) / (193.5 - 28.35) = 0.046321526
```

41.研究一下动态壁纸是如何添加的？？？

解决:
请参考《08月29日学习笔记》

42.将StatusBar切换到Switch页面的时候会出现"只能拨打紧急呼救电话"字符串被遮挡的现象？？？

解决:
只要在PhoneStatusBar.java中修改
``` Java
mSettingsButtonListener 	监听器中添加代码隐藏该字符串即可 mCarrierLabelGemini.setVisibility(View.GONE);
mNotificationButtonListener 监听器中添加代码显示该文本框即可 mCarrierLabelGemini.setVisibility(View.VISIBLE);
```

43.Notification通知栏上的左边的小圆圈图标显示不正常，下面有一小段显示不全？？？

解决:
//在frameworks/base/packages/SystemUI/res/values/dimens.xml
``` xml
<dimen name="notification_divider_height">3dp</dimen>	//只要将这里的3dp修改为0dp就行了
```

44.Wallpaper如何选中当前壁纸？？？

解决:
//MyLocalGridViewAdapter.java
``` Java
PreferencesService service = new PreferencesService(mContext);
if(service.getPreferencesPosition() == position){			//这里的
    holder.current_setted.setVisibility(View.VISIBLE);
}else{
    holder.current_setted.setVisibility(View.INVISIBLE);
}

//PreferencesService.java
public int getPreferencesPosition(){
    int WallpaperPosition;
    SharedPreferences preferences = context.getSharedPreferences("TecnoWallpaper", Context.MODE_PRIVATE);
    WallpaperPosition = preferences.getInt("WallpaperPosition", Constants.Extra.defaultsLocalWallpaper);	//public static final int defaultsLocalWallpaper = 1;
    return WallpaperPosition;		//这里的位置需要和当前壁纸相对应,只需要修改这个地方就可以了
}
```

45.状态栏上的Torch打不开？？？

解决:
在 PhoneStatusBar.java 上有 context.sendBroadcast(new Intent("TorchDirectOpen"));		//这个地方发送了一个广播打开Torch
将R5上的FlashLight直接移植过来就可以了

46.状态栏上的机主信息显示不全，有图片的时候不显示机主名称？？？

解决:
因为R.id.user_textview文本框显示太小了
只需要在 quick_settings_tile_user.xml 中将 R.id.user_imageview 的属性修改为如下即可
android:layout_height="0dp"
android:layout_weight="1"

47. adb shell如何按照进程名称杀死进程com.android.systemui？？？

48.锁屏界面上的闹钟显示不全？？？

解决:
keyguard_status_view.xml 中有 R.id.alarm_status 这个控件显示闹钟信息

49.主题列表界面来蓝牙配对请求等通知的时候背景显示主界面？？？

解决:
去掉ThemeChooser的
android:launchMode="singleTask"

50.添加了 img_back 和 img_frame 之后很多应用都会报错？？？

51.点击主界面菜单上的《搜索》菜单项报错？？？

解决:
``` Java
//这里我添加了捕获异常的处理
try {
    startActivity();
} catch(ActivityNotFoundException e) {
    Toast.makeText(mContext,"There is no app found to support this action!").show();
}
Launcher.java
case MENU_SEARCH:
    ComponentName componentNameSearch = new ComponentName("com.google.android.googlequicksearchbox", "com.google.android.googlequicksearchbox.SearchActivity");		//添加google包之后就不会报错了
    Intent mintentSearch = new Intent();
    mintentSearch.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    mintentSearch.setComponent(componentNameSearch);
    startActivity(mintentSearch);
    break;
```

52.点击主界面菜单上的《分享》菜单项报错？？？

解决:
``` Java
Launcher.java
case MENU_SHARE:
    ComponentName componetName1 = new ComponentName("com.zzd.share", "com.zzd.share.ShareTestActivity");		//这个应用是哪一个？？ShareTest
    Intent mintent1 = new Intent();
    mintent1.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    mintent1.setComponent(componetName1);
    startActivity(mintent1);
    break;
```
在 packages/apps 下添加上 ShareTest 应用就可以了

53.卸载应用的时候会显示两个背景？？？桌面和主菜单界面？？？？

分析:
《卸载》按钮:
//DeleteDropTarget.java 中有
``` Java
setText(isUninstall ? R.string.delete_target_uninstall_label : R.string.delete_target_label);
//DeleteDropTarget.java文件中有
private void completeDrop(DragObject d) {
    ...
    if (isAllAppsApplication(d.dragSource, item)) {
        mLauncher.startApplicationUninstallActivity((ApplicationInfo) item);		//卸载应用的方法
    }
    ...
}
```
《应用详情》按钮:
//InfoDropTarget.java 中有
``` Java
public boolean acceptDrop(DragObject d) {
    ...
    if (componentName != null) {
        mLauncher.startApplicationDetailsActivity(componentName);					//查看应用详情的方法
    }
    ...
}
```
《workspace/hotseat没有空间》
//Workspace.java 中有
``` Java
public boolean acceptDrop(DragObject d) {
    ...
    mLauncher.showOutOfSpaceMessage(isHotseat);										//弹出Toast显示没空间的方法
    ...
}
```
解决:
只要在上面3个地方都添加上 mLauncher.hideWorkspace(); 方法将workspace/hotseat/pagecontrol 都隐藏了就可以了
现在替换为最新版的TECNO_Launcher2就OK了

54.状态栏透明效果没有修改好？？？Message界面会跳闪？？？Bug16824

解决:
直接在Launcher.java的onStop()方法中添加 mStatusBarManager.setStatusBarBg(0xff000000);		//直接添加，不要添加任何判断
//改为在startActivity()方法中判断，再设置背景

55.《梦宝谷》应用在什么地方？？？

解决:
应用在 mediatek/platform/mt6572/binary/3rd-party/free/Mobage/Mobage.apk
在 ProjectConfig.mk文件中 有 MTK_DENA_MOBAGE_APP 宏用来控制是否编译这个应用

56.点击进入应用列表界面的时候加载较慢？？？？

解决:
经过内存优化之后稍微有点改善

57.切换语言或主题之后会很卡？？？

解决:
经过内存优化之后稍微有点改善

58.USB connected通知前面的标签图标显示白色？？？

分析:
``` Java
Intent intent = new Intent();
intent.setClass(mContext, com.android.systemui.usb.UsbStorageActivity.class);
intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
PendingIntent pi = PendingIntent.getActivity(mContext, 0, intent, 0);
//发送通知
setUsbStorageNotification(com.android.internal.R.string.usb_storage_notification_title com.android.internal.R.string.usb_storage_notification_message, com.android.internal.R.drawable.stat_sys_data_usb,false, true, pi);
在 Notification.java 中的 applyStandardTemplate() 方法中添加 contentView.setInt(R.id.icon, "setBackgroundResource", R.drawable.notify_panel_notification_icon_bg2);
```
解决:
//这个只需要将frameworks/base/core/res/res/layout/notification_template_*.xml的icon的android:background都改为蓝色的圆圈就行了

59.研究一下FlashLight的直接打开闪光灯的Receiver的代码？？？

60.Bug16662 [BUG](主菜单)操作过程中主菜单排序错误????

61.App列表的行数和列数在哪里确定？？？

解决:
``` Java
//在workspace.java文件中有
private static final int DEFAULT_CELL_COUNT_Y = 4;						//默认列数
int cellCountY = DEFAULT_CELL_COUNT_Y;									//这里默认就为4，这里的4是 workspace 上的4，而不是 AppsCustomizePagedView 上的 4
cellCountY = a.getInt(R.styleable.Workspace_cellCountY, cellCountY);	//在config.xml文件中有    <integer name="cell_count_y">4</integer>
//APP列表:		PagedViewCellLayout.java
?????????????????????

//Widget列表:	PagedViewGridLayout.java
AppsCustomizePagedView.java 文件中有
//syncWidgetPageItems()方法中有
if(mLauncher.isAddMode){
	mWidgetCountY = 2;	//添加模式
} else {
	mWidgetCountY = 3;	//正常模式
}
//syncPages()方法中有
PagedViewGridLayout layout = new PagedViewGridLayout(context, mWidgetCountX, mWidgetCountY);
```

62.截屏的时候显示通知栏还是正方形的？？

分析:
``` Java
在 GlobalScreenShot.java文件中有
mNotificationBuilder
.setContentTitle(r.getString(R.string.screenshot_saved_title))
.setContentText(r.getString(R.string.screenshot_saved_text))
.setContentIntent(PendingIntent.getActivity(params.context, 0, launchIntent, 0))
.setWhen(System.currentTimeMillis())
.setAutoCancel(true);
```

解决:
还是需要在 frameworks/base/core/res/res/layout/notification_template_big_picture.xml 中将 R.id.icon 的 background 修改为 notify_panel_notification_icon_bg

63.Bug16901 创建直接拨号或直接发短信快捷方式的时候，快捷方式图标显示不正常？？？

解决:
``` Java
M:packages/apps/ContactsCommon/src/com/android/contacts/common/list/ShortcutIntentBuilder.java
private Bitmap generatePhoneNumberIcon(){
    ...
    dst.set(iconWidth - ((int) (80 * density)) - 30, 29, iconWidth - 30, ((int) (80 * density)) + 30);		//微调这里的参数就行了
    ...
}
```

64.在设置主题的时候左右滑动数组越界报错的问题？？？

解决:
``` Java
//在ThemePreview.java的getView()方法中判断themePreviewList的元素是否为0，若为0则重新加载一遍 loadThemes()
if(themePreviewList.size() == 0){
    loadThemes(mCurrentThemeName);
}
```

65.在 Launcher.java的 onPause()中状态栏设置背景颜色的时候有问题？？？

解决:
``` Java
//onPause()方法
ActivityManager am = (ActivityManager)this.getSystemService(Context.ACTIVITY_SERVICE);
ComponentName cn = am.getRunningTasks(1).get(0).topActivity;
//将上面的方法移植到boolean startActivity()方法中就可以解决大部分，如mms,phone等
```

66.Settings热底座上的add按钮？？？

分析:
``` Java
Hotseat.java
addButton.setOnClickListener(new View.OnClickListener() {
	public void onClick(View v) {}
});
Hotseat.java
allAppButton.setOnClickListener(new OnClickListener(){
	public void onClick(View v) {
		mLauncher.onClickAllAppsButton(v);
	}
});

Launcher.java
public void onClickAllAppsButton(View v) {
	if(isArrange){
		return;
	}
	mAppsCustomizeTabHost.selectAppsTab();
	showAllApps(true);
	mAppsCustomizeTabHost.getContentTypeForTabTag(AppsCustomizeTabHost.APPS_TAB_TAG);
}
```

67.Launcher.addMode模式下添加widget列表显示3行？？？

分析:
//复现方法
1.进入到Direct message widget选择联系人，连续按两次返回键，widget列表没有消失
2.点击AppsCustomizeTabHost上的apps选项卡，进入到app列表
3.按返回键退出add mode,再进入到add mode就会直接显示3行widget列表

68.将主题设置为《world cup》之后启动《RF 2013》world cup会意外停止？？？《WorldCup》主题和《Leaves》主题的效果都有待优化？？？

```
Log:
E/AndroidRuntime(12461): FATAL EXCEPTION: Thread-470
E/AndroidRuntime(12461): Process: com.android.worldcup, PID: 12461
E/AndroidRuntime(12461): java.lang.NullPointerException
E/AndroidRuntime(12461): 	at android.graphics.Canvas.throwIfCannotDraw(Canvas.java:1083)
E/AndroidRuntime(12461): 	at android.graphics.Canvas.drawBitmap(Canvas.java:1139)
E/AndroidRuntime(12461): 	at com.android.worldcup.WallpaperService$LiveWallpaperPainting.drawPaillette(WallpaperService.java:283)						//这里会有问题？？？
E/AndroidRuntime(12461): 	at com.android.worldcup.WallpaperService$LiveWallpaperPainting.draw(WallpaperService.java:318)
E/AndroidRuntime(12461): 	at com.android.worldcup.WallpaperService$LiveWallpaperPainting.doDraw(WallpaperService.java:405)
E/AndroidRuntime(12461): 	at com.android.worldcup.WallpaperService$LiveWallpaperPainting.run(WallpaperService.java:349)

原因:在 WallpaperService.java 的 drawPaillette() 方法中有一个 BitmapFactory.decodeStream(getClass().getResourceAsStream(path));		//这个地方解析的时候会出错，就会导致解析出来的图片为空，导致NullPointerException
只要将 WallpaperService.java 的 drawPaillette() 方法中添加一个图片非空的判断就行了，具体修改代码如下
解决:
if(paillette_array[0] != null){							//添加非空判断
    canvas.drawBitmap(paillette_array[0],0,0,null);
}
```

69.状态栏上的亮度调节栏应该在设置为非自动模式之后设置为不可用？？？？

解决:
``` Java
//在 frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/PhoneStatusBar.java中的监听器和初始化seekBar的地方添加
mSeekbar.setEnabled(nAutomatic == 1 ? false : true);
```

70.从 Notification 界面跳转到 《FM Radio》 界面，状态栏还是会闪？？？

解决:
同《问题75》

71.在删除应用的时候出现问题？？？内存溢出？？？

```
分析:
01-01 08:02:40.468685   964  1021 W System.err: Caused by: java.lang.OutOfMemoryError
01-01 08:02:40.469218   964  1021 W System.err: 	at android.graphics.BitmapFactory.nativeDecodeAsset(Native Method)
01-01 08:02:40.469362   964  1021 W System.err: 	at android.graphics.BitmapFactory.decodeStream(BitmapFactory.java:609)
01-01 08:02:40.469441   964  1021 W System.err: 	at android.graphics.BitmapFactory.decodeResourceStream(BitmapFactory.java:444)
01-01 08:02:40.469510   964  1021 W System.err: 	at android.graphics.drawable.Drawable.createFromResourceStream(Drawable.java:840)
01-01 08:02:40.469579   964  1021 W System.err: 	at android.content.res.Resources.loadDrawable(Resources.java:2166)
01-01 08:02:40.469664   964  1021 W System.err: 	at android.content.res.Resources.getDrawable(Resources.java:710)
01-01 08:02:40.469748   964  1021 W System.err: 	at android.app.ApplicationPackageManager.getDrawable(ApplicationPackageManager.java:946)				//这里会有问题？？？
01-01 08:02:40.469826   964  1021 W System.err: 	at com.android.launcher2.AppsCustomizePagedView.getWidgetPreview(AppsCustomizePagedView.java:2033)			
01-01 08:02:40.469902   964  1021 W System.err: 	at com.android.launcher2.AppsCustomizePagedView.loadWidgetPreviewsInBackground(AppsCustomizePagedView.java:2340)
01-01 08:02:40.469991   964  1021 W System.err: 	at com.android.launcher2.AppsCustomizePagedView.access$200(AppsCustomizePagedView.java:212)
01-01 08:02:40.470071   964  1021 W System.err: 	at com.android.launcher2.AppsCustomizePagedView$8.run(AppsCustomizePagedView.java:1906)
01-01 08:02:40.470252   964  1021 W System.err: 	at com.android.launcher2.AppsCustomizeAsyncTask.doInBackground(AppsCustomizePagedView.java:180)
01-01 08:02:40.470338   964  1021 W System.err: 	at com.android.launcher2.AppsCustomizeAsyncTask.doInBackground(AppsCustomizePagedView.java:168)
01-01 08:02:40.470427   964  1021 W System.err: 	at android.os.AsyncTask$2.call(AsyncTask.java:288)
01-01 08:02:40.470497   964  1021 W System.err: 	at java.util.concurrent.FutureTask.run(FutureTask.java:237)
01-01 08:02:40.470558   964  1021 W System.err: 	... 3 more

Resources r = getResourcesForApplication(appInfo);
dr = r.getDrawable(resid);							//log显示是在这里出现的问题？？
```

72.优化《WorldCup》主题和《Leaves》主题的显示效果和内存？？？？

解决:
在使用BitmapFactory.decodeStream()方法加载图片之后效果好了一点

73.在开机的时候如何禁止一些服务的启动？？？

74.一些三方apk的名称和控制方法？？？

解决:
点心省电		Tecno_DUBattery						TECNO_DUBATTERY_APP
电影工作室	packages/apps/VideoEditor			MTK_ENABLE_VIDEO_EDITOR
手机管家		Tencent_Mobile_Manager_Slim			MTK_TENCENT_MOBILE_MANAGER_SLIM_SUPPORT
待办事项		mediatek/packages/apps/Todos
梦宝谷		Mobage								MTK_DENA_MOBAGE_APP
墨迹天气国际	Tecno_MoWeather						Tecno_MoWeather_APP
安卓优化大师	Tecno_DUSpeed						Tecno_DUSpeed_APP

75.从通知状态栏上进入到某个应用的时候状态栏会跳闪？？？

解决:
``` Java
//在 frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/BaseStatusBar.java 文件中有
protected class NotificationClicker implements View.OnClickListener {
    public void onClick(View v){			//通知栏某一项的点击事件
        ...
        StatusBarManager mStatusBarManager = (StatusBarManager)mContext.getSystemService(Context.STATUS_BAR_SERVICE);
        mStatusBarManager.setStatusBarBg(0xff000000);	//将状态栏的颜色修改为黑色
        ...
    }
}
```

76.在主页面删除应用或查看应用详细信息的时候状态栏会跳闪？？？

解决:
``` Java
//在packages/apps/TECNO_Launcher2/src/com/android/launcher2/Launcher.java上有
void startApplicationDetailsActivity(ComponentName componentName) {
    String packageName = componentName.getPackageName();
    Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.fromParts("package", packageName, null));
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
    startActivitySafely(null, intent, "startApplicationDetailsActivity");
    mStatusBarManager.setStatusBarBg(0xff000000);		//在这里将状态栏设置为黑色
}
```

77.从下拉状态栏跳转到《Data usage》状态栏也会跳闪？？？

解决:
``` Java
//在frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/QuickSettings.java文件中有
private void startSettingsActivity(Intent intent, boolean onlyProvisioned) {
    if (onlyProvisioned && !getService().isDeviceProvisioned()) return;
    try {
        // Dismiss the lock screen when Settings starts.
        ActivityManagerNative.getDefault().dismissKeyguardOnNextActivity();
    } catch (RemoteException e) {
    }
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
    mContext.startActivityAsUser(intent, new UserHandle(UserHandle.USER_CURRENT));
    //Bug17319 modified for statusbarbg 2014/09/17:begin
    ((android.app.StatusBarManager)mContext.getSystemService(Context.STATUS_BAR_SERVICE)).setStatusBarBg(0xff000000);	//在这里将状态栏的背景设置为黑色
    //Bug17319 modified for statusbarbg 2014/09/17:end
    collapsePanels();
}
```

78.先进入Message等应用,再按开关机键进入锁屏界面，锁屏界面状态栏会显示黑色？？？

解决:
在 frameworks/base/policy/src/com/android/internal/policy/impl/keyguard/KeyguardServiceDelegate.java 文件中添加代码将状态栏的颜色修改为透明
但解锁了之后在回到应用界面，状态栏又会跳闪，参考《问题81》在解锁之后将状态栏修改为黑色

79.在hotseat上切换fm/music功能的时候会出现divide by zero异常？？？

分析:
``` Java
//从Log中看应该是CellLayout.java文件中的997行有
result[0] = (x - hStartPadding) / (mCellWidth + mWidthGap);		//这里有个除0的异常，需要捕获异常
mCellWidth = a.getDimensionPixelSize(R.styleable.CellLayout_cellWidth, 10);
```

80.从hotseat上启动FM和Music的时候状态栏也会闪？？？

解决:
//Music的跳转在 MusicControl.java文件中
//FM的跳转在什么地方？？在 LauncherAppWidgetHostView.java 文件中

81.解锁成功在什么地方？？？

解决:
``` Java
//在 frameworks/base/packages/Keyguard/src/com/android/keyguard/KeyguardHostView.java文件中
private void showNextSecurityScreenOrFinish(boolean authenticated, boolean showBouncer) {
    //可以在这里将状态栏的背景颜色设置为黑色
    //这里可以添加代码判断一下是不是Launcher界面，如果不是Launcher界面就将状态栏设置为黑色
}
```

82.在 AppsCustomizePagedView.java 文件中的2055行会报内存溢出的异常？？？

分析:
同《问题71》

83."Setup Wizard has stopped" ?????

```
Log:
No Activity found to handle Intent{act=android.intent.action.MAIN cat=[android.intent.category.HOME]}
解决:
push完Launcher之后重启一下就可以了
```

84.workspace 上 folder文件夹好像太小了，包不住两个应用？？？

解决:
用R5的新的Launcher就可以了

85.在添加widget的时候，状态栏背景会变黑？？？

解决:
```
//在 Launcher.java 文件的 setWorkspaceBackground() 方法中有
mStatusBarManager.setStatusBarBg(0x75000000);	//把这里改为0xff000000就行了
```

86.状态栏跳变总结？？？

解决:
《问题02》	添加setStatusBarBg()接口
《问题54》	状态栏透明效果没有修改好？？？Message界面会跳闪？？？Bug16824
《问题65》	在Launcher.java的onPause()中状态栏设置背景颜色的时候有问题？？？
《问题70》	从 Notification 界面跳转到 《FM Radio》 界面，状态栏还是会闪？？？
《问题75》	从通知状态栏上进入到某个应用的时候状态栏会跳闪？？？
《问题76》	在主页面删除应用或查看应用详细信息的时候状态栏会跳闪？？？
《问题77》	从下拉状态栏跳转到《Data usage》状态栏也会跳闪？？？
《问题78》	先进如Message等应用,再按开关机键进入锁屏界面，锁屏界面状态栏会显示黑色？？？
《问题80》	从hotseat上启动FM和Music的时候状态栏也会闪？？？
《问题81》	解锁成功之后将状态栏设置为黑色？？？
《问题85》	在添加widget的时候，状态栏背景会变黑？？？
《问题91》	点击Home键的时候状态栏跳变？？？
最后只要在 Launcher.java 的 onPause() 方法中添加 setStatusBarBg(0xff000000); 就行了

最终解决方法:
只要将 frameworks/base/services/java/com/android/server/StatusBarManagerService.java 中 setStatusBarBg() 的方法实现给去掉就都ok了
public void setStatusBarBg(int statusBarBg) {
}


87.《Sound Recorder》在通知栏上的背景小图标还是白色的？？？

解决:
参考《问题98》

88.在 frameworks/base/core/java/android/app/ApplicationPackageManager.java 的946行会报OOM错？？？

```
分析:
//ApplicationPackageManager.java
Resources r = getResourcesForApplication(appInfo);
dr = r.getDrawable(resid);							//这里报错？？
同《问题71》
```

89.在锁屏界面添加《Message》短信widget之后，再从锁屏界面跳转到《Message》就会出现状态栏跳闪？？？

解决:
参考《问题86最终解决方法》

90.在添加 Driver 的 widget 的时候报错？？？

分析:
```
Log:
01-01 23:44:42.768: E/AndroidRuntime(25435): Caused by: java.lang.NullPointerException
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at com.android.launcher2.Workspace.estimateItemPosition(Workspace.java:392)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at com.android.launcher2.Workspace.getFinalPositionForDropAnimation(Workspace.java:3536)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at com.android.launcher2.Workspace.animateWidgetDrop(Workspace.java:3573)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at com.android.launcher2.Launcher.completeTwoStageWidgetDrop(Launcher.java:1686)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at com.android.launcher2.Launcher.onActivityResult(Launcher.java:1619)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at android.app.Activity.dispatchActivityResult(Activity.java:5456)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	at android.app.ActivityThread.deliverResults(ActivityThread.java:3549)
01-01 23:44:42.768: E/AndroidRuntime(25435): 	... 11 more
```

91.点击Home键的时候状态栏跳变？？？

分析:
貌似点击Home键的时候就会调用Launcher上的onPause()方法
解决:
参考《问题86最终解决方法》

92.添加widget跳转的方法在什么地方？？？

解决:
添加widget跳转	在 Launcher.java 上有 addAppWidgetImpl()方法
添加shortcut跳转	在 Launcher.java 上有 processShortcut()方法

93.AppsCustomizePagedView 上的《Edit》菜单有时会不显示？？？

解决:
设计如此，只有在《Own order》排序模式下才会显示

94.R5的不同点？？？

TabHost上的google play图标显示不太清楚			已修改（替换为R5的Launcher就行了）
主题不同，主题列表不同，主题数量不同（多了两个主题）	已修改（替换为R5的Launcher就行了）
AppsCustomizePagedView的加载动画不太一样		已修改（替换为R5的Launcher就行了）
在AddMode的时候的背景不透明						已修改（替换为R5的Launcher就行了）
锁屏界面的壁纸不一致							已修改（替换为R5的Launcher就行了）
在状态栏上的FlashLight的图标不会改变？？				这个貌似需要修改很多代码

95.为什么H5的Settings/Apps/Running 中 RAM 的使用率这么高？？？

解决:
因为R5是1G内存，H5是512M内存，在代码中写死了，
RunningProcessView.java

96.Bug20323 锁屏界面解锁的时候背景是黑色的？？？

解决:
M:frameworks/base/policy/src/com/android/internal/policy/impl/PhoneWindowManager.java
将 PhoneWindowManager.java 中的 doesForceHide() 函数的返回值改为 return false; 就ok了，谢谢鑫哥


97.主题预览界面的图片不是全屏的，左右有黑边？？？

解决:只要替换innertheme下的预览图片就可以了

98.《Sound Record》在状态栏上的通知前面的图标不一致????

分析:
这个是在<Sound Recorder>应用内部自己添加的通知布局，需要在《SoundRecorder》应用内部修改
解决:
只要在 packages/apps/SoundRecorder/res/layout/notification.xml 的 app_icon 的 background 改为 notify_panel_notification_icon_bg.png(这张图片在frameworks/base/core/res/res/drawable-hdpi下)
再替换两张图片
packages/apps/SoundRecorder/res/drawable-hdpi/notification_pause_am.png
packages/apps/SoundRecorder/res/drawable-hdpi/notification_stop_am.png

99.在壁纸->动态壁纸->WorldCup预览界面中横屏的时候会报错？？？

解决:
好像有人把动态壁纸的预览页面强制设置为竖屏的了

100.从《Recent App》上启动 App Manager 会报错？？？

```
Log:
01-01 08:00:18.991: E/AndroidRuntime(6474): android.content.res.Resources$NotFoundException: File res/layout/detail_dialog.xml from drawable resource ID #0x7f030000
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.content.res.Resources.loadDrawable(Resources.java:2152)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.content.res.Resources.getDrawable(Resources.java:710)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.app.ApplicationPackageManager.getFancyDrawable(ApplicationPackageManager.java:890)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.content.pm.PackageItemInfo.loadIcon(PackageItemInfo.java:144)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at com.android.settings.applications.ApplicationsState$AppEntry.ensureIconLocked(ApplicationsState.java:145)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at com.android.settings.applications.ApplicationsState$BackgroundHandler.handleMessage(ApplicationsState.java:1017)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.os.Handler.dispatchMessage(Handler.java:110)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.os.Looper.loop(Looper.java:193)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.os.HandlerThread.run(HandlerThread.java:61)
01-01 08:00:18.991: E/AndroidRuntime(6474): Caused by: org.xmlpull.v1.XmlPullParserException: Binary XML file line #40: invalid drawable tag ScrollView
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.graphics.drawable.Drawable.createFromXmlInner(Drawable.java:933)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.graphics.drawable.Drawable.createFromXml(Drawable.java:877)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	at android.content.res.Resources.loadDrawable(Resources.java:2148)
01-01 08:00:18.991: E/AndroidRuntime(6474): 	... 8 more
```

101.锁屏界面解锁的时候有问题？？？黑色的圈圈和花环对不起来

解决:莫名奇妙就好了

102.为什么在Hotseat上显示的phone会变成这个com.google.android.dialer/com.android.dialer.DialtactsActivity？？？

分析:
com.google.android.dialer/com.android.dialer.DialtactsActivity		//为什么在Hotseat上显示的phone会变成这个？？？
com.android.dialer/.DialtactsActivity
解决:
去掉Google包中的GoogleOneTimeInitializer就可以了

103.添加App列表和widget列表翻页功能？？？

解决:
只要在 packages/apps/TECNO_Launcher2/src/com/android/launcher2/PagedView.java 的 onTouchEvent() 方法中的case 1,case 2中做一下处理就可以了

104.Bug19127修改锁屏界面上时钟的显示大小??

解决:
修改 frameworks/base/packages/Keyguard/res/layout-800x480/keyguard_status_view.xml 中的 clock_text 这个TextView的 textSize 从59dp 修改为55dp

105.在日历的快捷方式上显示日期？？？

分析:
如何实时更新
忽略:
客户已同意不做改功能

106.H5在SD卡上写东西的时候不成功？？Flash Share在接受文件的时候创建文件文件夹失败，接收文件失败？？？

107.近期任务中的图标好像不是主题里面的图标？？？？

解决:
修改 RecentTasksLoader.java 中的 getDrawable() 改为 getFancyDrawable() 就可以了

108.Bug19250 在不插卡的时候在状态栏上显示两个信号图标？？？

解决:
frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/SignalClusterView.java			//这个文件中添加用于控制显示两个信号图标
frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/policy/NetworkController.java	//这个文件中添加用于控制在不插卡的时候显示信号图标

109.Bug19333 修改下载的时候在状态栏显示的图标？？？

解决:
"Download complete" 字符串在 packages/providers/DownloadProvider/res/values/strings.xml	notification_download_complete
发送通知的地方:packages/providers/DownloadProvider/src/com/android/providers/downloads/DownloadNotifier.java	中有 builder.setSmallIcon(android.R.drawable.stat_sys_download);	//这个图片就是通知栏上看不清除的图片
//只要替换下面的这几张图片就可以了
frameworks/base/core/res/res/drawable-hdpi/stat_sys_download_anim0.png
frameworks/base/core/res/res/drawable-hdpi/stat_sys_download_anim1.png
frameworks/base/core/res/res/drawable-hdpi/stat_sys_download_anim2.png
frameworks/base/core/res/res/drawable-hdpi/stat_sys_download_anim3.png
frameworks/base/core/res/res/drawable-hdpi/stat_sys_download_anim4.png
frameworks/base/core/res/res/drawable-hdpi/stat_sys_download_anim5.png

110.Bug16669 去掉Settings/Action/Double click to wake up 选项？？？

解决:
packages/apps/ActionSettings/src/com/sagereal/actions/CustomPreferenceActivity.java	中将所有的 R.id.double_click_wake 都换成 0
packages/apps/ActionSettings/res/xml/preference_header.xml							中将	double_click_wake 注释掉

111.Bug19187 在FileManager中打开文本文件，横屏的时候字体变大？？？

解决:
packages/apps/HTMLViewer/AndroidManifest.xml	//将这个文件中的 HTMLViewerActivity 中添加 android:screenOrientation="portrait" 强制将这个Activity设置为竖屏，不让它可以横屏显示

112.TecnoBug262 Settings->Apps->App info 中下面的权限前面的图标显示不清楚？？？

解决:
frameworks/base/core/java/android/content/pm/PackageItemInfo.java 文件中有 loadNormalIcon() 方法
frameworks/base/core/java/android/widget/AppSecurityPermission.java 文件中的 loadGroupIcon() 方法中的 loadIcon() 方法替换成 loadNormalIcon() 方法
还需要将frameworks/base/core/res/res/drawable-hdpi/下面的以 perm_group_ 开头的图片替换为R5下面同名的29张图片

113.TecnoBug260 计算器横屏的时候删除按钮不显示C？？？

解决:
packages/apps/Calculator/res/layout-port/main.xml	在这个文件中 R.id.del 按钮中添加 android:text="@string/mtk_clear" 就行了

114.在RecentApp中短信的图标有时会显示不正常？？？

分析:
从Log中可以看出近期任务的短信图标有时候会显示成	com_android_mms_title_message.png	而有时候会显示成	com_android_mms_ic_launcher_mms.png		但这里还没有找到具体原因为什么会变成	com_android_mms_title_message.png
解决:
只要在innertheme下添加		com_android_mms_title_message.png	就可以了

115.Bug19523 开机出现报错？？？

分析:
从aee_exp的dbg文件中可以看出
java.lang.NullPointerException
at com.android.keyguard.KeyguardBubblesOperate$4.handleMessage(KeyguardBubblesOperate.java:571)
at android.os.Handler.dispatchMessage(Handler.java:110)
at android.os.Looper.loop(Looper.java:193)
at android.app.ActivityThread.main(ActivityThread.java:5299)
at java.lang.reflect.Method.invokeNative(Native Method)
at java.lang.reflect.Method.invoke(Method.java:515)
at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:825)
at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:641)
at dalvik.system.NativeStart.main(Native Method)
解决:
在 KeyguardBubblesOperate.java 中添加上非空判断

116.修改按键音？？

解决:
需要将 PhoneWindow.java 和 PhoneWindowManager.java 中修改

117.强度测试 《Ripple》和《Triangular space》动态壁纸会报错？？？

分析:
```
//Ripple
10-23 11:05:49.786 E/AndroidRuntime( 3834): FATAL EXCEPTION: main
10-23 11:05:49.786 E/AndroidRuntime( 3834): Process: com.vlife.wallpaper.resource.number5082, PID: 3834
10-23 11:05:49.786 E/AndroidRuntime( 3834): java.lang.NullPointerException
10-23 11:05:49.786 E/AndroidRuntime( 3834): at n.nq.i(Unknown Source)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at n.nq.g(Unknown Source)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at n.nq$2.run(Unknown Source)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at android.os.Handler.handleCallback(Handler.java:808)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at android.os.Handler.dispatchMessage(Handler.java:103)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at android.os.Looper.loop(Looper.java:193)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at android.app.ActivityThread.main(ActivityThread.java:5309)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at java.lang.reflect.Method.invokeNative(Native Method)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at java.lang.reflect.Method.invoke(Method.java:515)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:824)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:640)
10-23 11:05:49.786 E/AndroidRuntime( 3834): at dalvik.system.NativeStart.main(Native Method)
//Triangle
```
解决:
只要替换为上海提供的新的APK就可以了

118.notification panel will show 'Emergency calls only - rongweidi' ???

119.在锁屏界面上的FM widget上点击录音按钮界面会跳闪？？？

解决:
只要将录音的按钮的图标替换为透明的图标就可以了，不知道为什么？？
这里需要注意的是widget的布局文件在 layout-hdpi-800x480 文件夹中，图片在 drawable-hdpi-800x480 文件夹中，不要找错地方

120.卸载应用的对话框好像没有换肤？？？

121.将 Settings 中的 Security 修改为和其他的设置项都对齐？？？

解决:
M:packages/apps/Settings/res/layout/preference_header_button_item.xml
只要将 android:layout_marginEnd 去掉就可以了