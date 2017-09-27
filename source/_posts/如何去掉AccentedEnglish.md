---
title: 如何去掉AccentedEnglish
date: 2017-09-22 14:01:34
tags:
---
KK:
[Developer] Accented English是一种虚拟mapping出来的语言，source code的resource中并没有实际的values-zz-rZZ 的resource与之对应。
切换到该语言也是仅仅Setting UI的字串发生变化.这是为开发者模式设计的，对于使用者没有多大作用。
添加这个语言项具体为如下红色部分:
``` Java
LocalePicker.java (frameworks\base\core\java\com\android\internal\app)
public static ArrayAdapter<LocaleInfo> constructAdapter(Context context, final int layoutId, final int fieldId, final boolean isInDeveloperMode) {
    final Resources resources = context.getResources();
    ArrayList<String> localeList = new ArrayList<String>(Arrays.asList(Resources.getSystem().getAssets().getLocales()));
    if (isInDeveloperMode) {
        if (!localeList.contains("zz_ZZ")) {
            localeList.add("zz_ZZ");    //把这段代码去掉就可以了
        }
        /** - TODO: Enable when zz_ZY Pseudolocale is complete
         *  if (!localeList.contains("zz_ZY")) {
         *      localeList.add("zz_ZY");
         * }
         */
    }
}
```
只有在开发模式下才有,如果要去掉该项，可以把 localeList.add("zz_ZZ") 注释掉。