---
title: 修改默认Launcher
date: 2017-09-21 15:35:40
tags:
---
https://onlinesso.mediatek.com/FAQ/SW/FAQ03426

[DESCRIPTION]
> 
开机完成并解锁后，如果系统存在多个Launcher，系统会弹出一个选择框让用户选择进入某个Launcher。如果用户不想选择，而是想直接进入某一个默认的Launcher，要怎么修改？

[SOLUTION]
> 
注意:此修改方法对Google Now Launcher(GoogleHome.apk)无效。 
如果没有预置GMS，只需按照步骤一修改，如果预置了GMS请按照步骤一、二修改。

一、修改ActivityManagerService.java的startHomeActivityLocked方法

``` Java
boolean startHomeActivityLocked(int userId, String reason) {
    if (mFactoryTest == FactoryTest.FACTORY_TEST_LOW_LEVEL && mTopAction == null) {
        // We are running in factory test mode, but unable to find
        // the factory test app, so just sit around displaying the
        // error message and don't try to start anything.
        return false;
    }

    //mtk add start
    final PackageManager mPm = mContext.getPackageManager();
    Intent homeIntent=new Intent();
    homeIntent.addCategory(Intent.CATEGORY_HOME);
    homeIntent.setAction(Intent.ACTION_MAIN);
    homeIntent.addCategory(Intent.CATEGORY_DEFAULT);
    ResolveInfo info = mPm.resolveActivity(homeIntent, PackageManager.MATCH_DEFAULT_ONLY);
    if("android".equals(info.activityInfo.packageName)){ //if there is a default Launcher?
        ComponentName DefaultLauncher=new ComponentName("com.android.launcher3","com.android.launcher3.Launcher"); //here set the package name and class name of default launcher.
        ArrayList<ResolveInfo> homeActivities = new ArrayList<ResolveInfo>();
        ComponentName currentDefaultHome = mPm.getHomeActivities(homeActivities);
        ComponentName[] mHomeComponentSet = new ComponentName[homeActivities.size()];
        for (int i = 0; i < homeActivities.size(); i++) {
            final ResolveInfo candidate = homeActivities.get(i);
            Log.d(TAG,"homeActivitie: candidate = "+candidate);
            final ActivityInfo activityInfo= candidate.activityInfo;
            ComponentName activityName = new ComponentName(activityInfo.packageName, activityInfo.name);
            mHomeComponentSet[i] = activityName;
        }
        IntentFilter mHomeFilter = new IntentFilter(Intent.ACTION_MAIN);
        mHomeFilter.addCategory(Intent.CATEGORY_HOME);
        mHomeFilter.addCategory(Intent.CATEGORY_DEFAULT);
        List<ComponentName>Activities=new ArrayList();
        mPm.replacePreferredActivity(mHomeFilter, IntentFilter.MATCH_CATEGORY_EMPTY,mHomeComponentSet, DefaultLauncher);
    }

	//mtk add end

    Intent intent = getHomeIntent();
    ActivityInfo aInfo = resolveActivityInfo(intent, STOCK_PM_FLAGS, userId);
    ......
}
```

二、如果预置了GMS，还需要按照下面的方法修改:

请找到PackageManagerService.java的systemReady方法，在这个方法的最后增加以下示例代码:
``` Java
//mtk add start
if(isFirstBoot()) {
    String examplePackageName = "com.android.launcher3";  //default  package name of launcher
    String exampleActivityName = "com.android.launcher3.Launcher"; //default  activity name of  launcher   
    Intent intent=new Intent(Intent.ACTION_MAIN);
    intent.addCategory(Intent.CATEGORY_HOME);
    final int callingUserId = UserHandle.getCallingUserId();
    
    List<ResolveInfo> resolveInfoList = queryIntentActivities(intent,null, PackageManager.GET_META_DATA,callingUserId);
    if(resolveInfoList != null){
        int size = resolveInfoList.size();
        for(int j=0;j<size;){
            final ResolveInfo r = resolveInfoList.get(j);
            if(!r.activityInfo.packageName.equals(examplePackageName)) { 
                resolveInfoList.remove(j);
                size -= 1;
            } else {
                j++;
            }
        } 
       ComponentName[] set = new ComponentName[size];
       ComponentName defaultLauncher=new ComponentName(examplePackageName, exampleActivityName);
       int defaultMatch=0;
       for(int i=0;i<size;i++){
           final ResolveInfo resolveInfo = resolveInfoList.get(i);
           Log.d(TAG,"resolveInfo = " + resolveInfo.toString());
           set[i] = new ComponentName(resolveInfo.activityInfo.packageName,resolveInfo.activityInfo.name);
           if(defaultLauncher.getClassName().equals(resolveInfo.activityInfo.name)){
               defaultMatch = resolveInfo.match;
           }
       }
       Log.d(TAG,"defaultMatch="+Integer.toHexString(defaultMatch));
       IntentFilter filter=new IntentFilter();
       filter.addAction(Intent.ACTION_MAIN);
       filter.addCategory(Intent.CATEGORY_HOME);
       filter.addCategory(Intent.CATEGORY_DEFAULT);
      
       addPreferredActivity2(filter, defaultMatch, set, defaultLauncher);
    }
}
//mtk add end
```
 
在PackageManagerService.java中增加addPreferredActivity2方法：
``` Java
//mtk add start
public void addPreferredActivity2(IntentFilter filter, int match,ComponentName[] set, ComponentName activity) {
    synchronized (mPackages) {     
        filter.dump(new LogPrinter(Log.INFO, TAG), "  ");
        mSettings.editPreferredActivitiesLPw(0).addFilter(new PreferredActivity(filter, match, set, activity, true));
        scheduleWriteSettingsLocked();     
    }
}
//mtk add end
```
 
请修改PackageManagerService.java的findPreferredActivity方法，将以下代码：
``` Java
if (removeMatches) {
    pir.removeFilter(pa);
    if (DEBUG_PREFERRED) {
    	Slog.v(TAG, "Removing match " + pa.mPref.mComponent);
    }
    break;
}

// Okay we found a previously set preferred or last chosen app.
// If the result set is different from when this
// was created, we need to clear it and re-ask the
// user their preference, if we're looking for an "always" type entry.
if (always && !pa.mPref.sameSet(query, priority)) {
    Slog.i(TAG, "Result set changed, dropping preferred activity for " + intent + " type " + resolvedType);
    if (DEBUG_PREFERRED) {
    	Slog.v(TAG, "Removing preferred activity since set changed " + pa.mPref.mComponent);
    }
    pir.removeFilter(pa);
    // Re-add the filter as a "last chosen" entry (!always)
    PreferredActivity lastChosen = new PreferredActivity(pa, pa.mPref.mMatch, null, pa.mPref.mComponent, false);
    pir.addFilter(lastChosen);
    mSettings.writePackageRestrictionsLPr(userId);
    return null;
}
```
修改为:
``` Java
//mtk add start
if(!(intent.getAction() != null && intent.getAction().equals(intent.ACTION_MAIN) && intent.getCategories()!=null &&
    intent.getCategories().contains(intent.CATEGORY_HOME))) {       
    Log.d(TAG,"Home");      
}else {
    if (removeMatches) {
        pir.removeFilter(pa);
        if (DEBUG_PREFERRED) {
        	Slog.v(TAG, "Removing match " + pa.mPref.mComponent);
        }
        break;
    }
}

// Okay we found a previously set preferred or last chosen app.
// If the result set is different from when this
// was created, we need to clear it and re-ask the
// user their preference, if we're looking for an "always" type entry.
if (always && !pa.mPref.sameSet(query)) {                           
    if(!(intent.getAction() != null && intent.getAction().equals(intent.ACTION_MAIN) && intent.getCategories()!=null && 
        intent.getCategories().contains(intent.CATEGORY_HOME))) {
        Slog.i(TAG, "Result set changed, dropping preferred activity for " + intent + " type " + resolvedType);
        if (DEBUG_PREFERRED) {
        	Slog.v(TAG, "Removing preferred activity since set changed " + pa.mPref.mComponent);
        }
        pir.removeFilter(pa);
        // Re-add the filter as a "last chosen" entry (!always)
        PreferredActivity lastChosen = new PreferredActivity(pa, pa.mPref.mMatch, null, pa.mPref.mComponent, false);
        pir.addFilter(lastChosen);
        mSettings.writePackageRestrictionsLPr(userId);
        return null;
    }
}
//mtk add end
```