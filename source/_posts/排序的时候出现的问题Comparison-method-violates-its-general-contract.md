---
title: 排序的时候出现的问题Comparison method violates its general contract!
date: 2018-04-26 10:09:56
tags:
---
# 问题：排序的时候出现的问题Comparison method violates its general contract!
``` Java
Collections.sort(list, new Comparator<Integer>() {
    @Override
    public int compare(Integer o1, Integer o2) {
        return o1 > o2 ? 1 : -1;// 错误的方式  
    }
});
```
## 解决方案
先说如何解决，解决方式有两种。
### 修改代码
上面代码写的本身就有问题，第4行没有考虑o1 == o2的情况，再者说我们不需要自己去比较，修改为如下代码即可：
``` Java
Collections.sort(list, new Comparator<Integer>() {  
    @Override  
    public int compare(Integer o1, Integer o2) {  
        // return o1 > o2 ? 1 : -1;  
        return o1.compareTo(o2);// 正确的方式  
    }  
});  
```
### 不修改代码

那么问题来了。为什么上面代码在JDK6中运行无问题，而在JDK7中却会抛异常呢？这是因为JDK7底层的排序算法换了，如果要继续使用JDK6的排序算法，可以在JVM的启动参数中加入如下参数：
``` Java
-Djava.util.Arrays.useLegacyMergeSort=true  
```

### 分析

在我以前的认知中，高版本的JDK是可以兼容之前的代码的，与同事讨论了一番另加搜索了一番，事实证明，JDK6到JDK7确实存在兼容问题（不兼容列表）。在不兼容列表中我们可以找到关于Collections.sort的不兼容说明，如下：
```
Area: API: Utilities  
Synopsis: Updated sort behavior for Arrays and Collections may throw an IllegalArgumentException  
Description: The sorting algorithm used by java.util.Arrays.sort and (indirectly) by java.util.Collections.sort has been replaced.   
The new sort implementation may throw an IllegalArgumentException if it detects a Comparable that violates the Comparable contract.   
The previous implementation silently ignored such a situation.  
If the previous behavior is desired, you can use the new system property, java.util.Arrays.useLegacyMergeSort,   
to restore previous mergesort behavior.  
Nature of Incompatibility: behavioral  
RFE: 6804124  
```
描述的意思是说，java.util.Arrays.sort(java.util.Collections.sort调用的也是此方法)方法中的排序算法在JDK7中已经被替换了。如果违法了比较的约束新的排序算法也许会抛出llegalArgumentException异常。JDK6中的实现则忽略了这种情况。

再回过头来看我们开篇有问题的实现：
``` Java
return x > y ? 1 : -1;
```
当x == y时，sgn(compare(x, y))  = -1，-sgn(compare(y, x)) = 1，这违背了sgn(compare(x, y)) == -sgn(compare(y, x))约束，所以在JDK7中抛出了本文标题的异常。

### 结论

那么现在是否可以盖棺定论了，按照上面的分析来看，使用这种比较方式（return x > y ? 1 : -1;），只要集合或数组中有相同的元素，就会抛出本文标题的异常。实则不然，什么情况下抛出异常，还取决于JDK7底层排序算法的实现，也就是大名鼎鼎的TimSort。后面文章会分析TimSort。本文给出一个会引发该异常的Case，以便有心人共同研究，如下：
``` Java
Integer[] array =   
{0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   
0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 2, 1, 0, 0, 0, 2, 30, 0, 3};  
```

## 实际应用
在输入法中选择多中语言的键盘之后，到短信或其他编辑界面上长按空格切换输入法，会发现报错重启，抓log之后发现是 Comparison method violates its general contract 的错误。
### 修改一
alps/frameworks/base/core/java/com/android/internal/inputmethod/InputMethodSubtypeSwitchingController.java
``` Java
System.setProperty("java.util.Arrays.useLegacyMergeSort", "true");
```
在代码中动态设置 java.util.Arrays.useLegacyMergeSort 这个值的属性，发现没有效果。

### 修改二
alps/frameworks/base/core/java/com/android/internal/inputmethod/InputMethodSubtypeSwitchingController.java
查看代码发现主要是对 ImeSubtypeListItem 这个类的集合进行排序，而 ImeSubtypeListItem 本身就实现了 Comparable 排序的方法：
``` Java
public static class ImeSubtypeListItem implements Comparable<ImeSubtypeListItem> {
    public final CharSequence mImeName;
    public final CharSequence mSubtypeName;
    public final InputMethodInfo mImi;
    public final int mSubtypeId;
    public final boolean mIsSystemLocale;
    public final boolean mIsSystemLanguage;

    public ImeSubtypeListItem(CharSequence imeName, CharSequence subtypeName,
            InputMethodInfo imi, int subtypeId, String subtypeLocale, String systemLocale) {
        mImeName = imeName;
        mSubtypeName = subtypeName;
        mImi = imi;
        mSubtypeId = subtypeId;
        if (TextUtils.isEmpty(subtypeLocale)) {
            mIsSystemLocale = false;
            mIsSystemLanguage = false;
        } else {
            mIsSystemLocale = subtypeLocale.equals(systemLocale);
            if (mIsSystemLocale) {
                mIsSystemLanguage = true;
            } else {
                // TODO: Use Locale#getLanguage or Locale#toLanguageTag
                final String systemLanguage = parseLanguageFromLocaleString(systemLocale);
                final String subtypeLanguage = parseLanguageFromLocaleString(subtypeLocale);
                mIsSystemLanguage = systemLanguage.length() >= 2 &&
                        systemLanguage.equals(subtypeLanguage);
            }
        }
    }

    /**
     * Returns the language component of a given locale string.
     * TODO: Use {@link Locale#getLanguage()} instead.
     */
    private static String parseLanguageFromLocaleString(final String locale) {
        final int idx = locale.indexOf('_');
        if (idx < 0) {
            return locale;
        } else {
            return locale.substring(0, idx);
        }
    }

    @Override
    public int compareTo(ImeSubtypeListItem other) {
        if (TextUtils.isEmpty(mImeName)) {
            return 1;
        }
        if (TextUtils.isEmpty(other.mImeName)) {
            return -1;
        }
        if (!TextUtils.equals(mImeName, other.mImeName)) {
            return mImeName.toString().compareTo(other.mImeName.toString());
        }
        if (TextUtils.equals(mSubtypeName, other.mSubtypeName)) {
            return 0;
        }
        if (mIsSystemLocale) {
            return -1;
        }
        if (other.mIsSystemLocale) {
            return 1;
        }
        if (mIsSystemLanguage) {
            return -1;
        }
        if (other.mIsSystemLanguage) {
            return 1;
        }
        if (TextUtils.isEmpty(mSubtypeName)) {
            return 1;
        }
        if (TextUtils.isEmpty(other.mSubtypeName)) {
            return -1;
        }
        return mSubtypeName.toString().compareTo(other.mSubtypeName.toString());
    }

    @Override
    public String toString() {
        return "ImeSubtypeListItem{"
                + "mImeName=" + mImeName
                + " mSubtypeName=" + mSubtypeName
                + " mSubtypeId=" + mSubtypeId
                + " mIsSystemLocale=" + mIsSystemLocale
                + " mIsSystemLanguage=" + mIsSystemLanguage
                + "}";
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        if (o instanceof ImeSubtypeListItem) {
            final ImeSubtypeListItem that = (ImeSubtypeListItem)o;
            if (!Objects.equals(this.mImi, that.mImi)) {
                return false;
            }
            if (this.mSubtypeId != that.mSubtypeId) {
                return false;
            }
            return true;
        }
        return false;
    }
}
```
修改了 compareTo() 方法之后，还是没有效果，可能是我修改的方法不对，在compareTo() 方法中打log发现没有走到里面的方法。

### 修改三
``` Java
public List<ImeSubtypeListItem> getSortedInputMethodAndSubtypeList(
        boolean includeAuxiliarySubtypes, boolean isScreenLocked) {
    ...
    //------------modified begin-------------
    System.setProperty("java.util.Arrays.useLegacyMergeSort", "true");
    //Collections.sort(imList);
    Collections.sort(imList, new Comparator<ImeSubtypeListItem>() {
        @Override
        public int compare(ImeSubtypeListItem arg0, ImeSubtypeListItem arg1) {
            if (arg0 == null && arg1 == null) {
                return 0;
            }
            if (arg0 == null) {
                return -1;
            }
            if (arg1 == null) {
                return 1;
            }
            // ImeName
            if (arg0.mImeName == null && arg1.mImeName == null){
                return 0;
            }
            if (TextUtils.isEmpty(arg0.mImeName)) {
                return -1;
            }
            if (TextUtils.isEmpty(arg1.mImeName)) {
                return 1;
            }
            String mImeName0 = arg0.mImeName.toString().trim();
            String mImeName1 = arg1.mImeName.toString().trim();
            if (TextUtils.isEmpty(mImeName0)) {
                return -1;
            }
            if (TextUtils.isEmpty(mImeName1)) {
                return 1;
            }
            if (!TextUtils.equals(mImeName0, mImeName1)) {
                return mImeName0.compareTo(mImeName1);
            }
            // SubtypeName
            if (arg0.mSubtypeName == null && arg1.mSubtypeName == null){
                return 0;
            }
            if(TextUtils.isEmpty(arg0.mSubtypeName)){
                return -1;
            }
            if(TextUtils.isEmpty(arg1.mSubtypeName)){
                return 1;
            }
            String mSubtypeName0 = arg0.mSubtypeName.toString().trim();
            String mSubtypeName1 = arg1.mSubtypeName.toString().trim();
            if(TextUtils.equals(mSubtypeName0, mSubtypeName1)){
                return 0;
            }
            return mSubtypeName0.compareTo(mSubtypeName1);
        }
    });
    //------------modified end-------------
    return imList;
}
```
最终通过把 Collections.sort(imList); 替换为 Collections.sort(imList, new Comparator<ImeSubtypeListItem>() 方法之后验证生效。
