---
title: android-res下资源命名规则
date: 2017-09-25 15:40:07
tags:
---
1、 命名规范
1. 可用的命名属性
在文档1中的表格“Table 2. Configuration qualifier names. ”中有说明(表格太大，不方便在此张贴)，表格中的&quot;Configuration&quot;项集就是Android全体可用命名属性集，表格此项的排列顺序即是各个属性的优先级别顺序。

2. 命名方法与要求
1) 命名不区分大小写；
2) 命名形式：资源名-属性1-属性2-属性3-属性4-属性5.....
资源名就是资源类型名，包括:drawable, values, layout, anim, raw, menu, color, animator, xml；
属性1-属性2-属性3-属性4-属性5.....就是上述的属性集内的属性，如:-en-port-hdpi；
注意：各属性的位置顺序必须遵守优先级从高到低排列！否则编译不过

3. 实例说明
1) 把全部属性都用上的例子(各属性是按优先级先后排列出来的)
values-mcc310-en-sw320dp-w720dp-h720dp-large-long-port-car-night-ldpi-notouch-keysexposed-nokeys-navexposed-nonav-v7
2) 上述例子属性的中文说明
values-mcc310(sim卡运营商)-en(语言)-sw320dp(屏幕最小宽度)-w720dp(屏幕最佳宽度)-h720dp(屏幕最佳高度)-large(屏幕尺寸)-long(屏幕长短边模式)-port(当前屏幕横竖屏显示模式)-car(dock模式)-night(白天或夜晚)-ldpi(屏幕最佳dpi)-notouch(触摸屏模类型)-keysexposed(键盘类型)-nokey(硬按键类型)-navexposed(方向键是否可用)-nonav(方向键类型)-v7(android版本)

2、 定位最佳文件夹
1. 定位算法

providingResource
特殊说明：关于屏幕大小size相关的属性不在步骤１的过滤清除条件里（dpi属性和screen size属性）：
1) 对于dpi属性系统的选择方法是&quot;best match&quot;－－－即如果没有找到准确的属性，可以接着寻找最接近的属性文件夹。例如：我的g7手机，应该是values-hdpi,但如果没有values-hdpi，则可以找出最接近的文件夹（先找values-xhdpi到values-mdpi到values最后到values-ldpi,注意values在values-ldpi之前先找到，系统认为values比values-ldpi更接近我的values-hdpi属性）;

2) 对于screen size属性系统的选择方法是&quot;向下best match&quot;，即如果没找到准确的属性，只可以接着在比自身属性小的文件夹里找最接近的属性文件夹。例如：我的g7手机，应该是values-normal,但如果没有values-normal,则可以找出最接近的文件夹(先找values再到values-small,注意，系统认为values比values-small更接近我的values-normal属性，但之后就不会再找values-large与values-xlarge了，因为是&quot;向下best match&quot;，large与xlarge都比normal大)。
2. 实例说明
工程有如下文件夹：
drawable/
drawable-en/
drawable-fr-rCA/
drawable-en-port/
drawable-en-notouch-12key/
drawable-port-ldpi/
drawable-port-notouch-12key/
手机属性：
Locale = en-GB 
Screen orientation = port 
Screen pixel density = hdpi 
Touchscreen type = notouch 
Primary text input method = 12key

1) 清除包含任何与手机配置有冲突的属性的资源文件夹（蓝色字体表现被清除）
drawable/
drawable-en/
drawable-fr-rCA/
drawable-en-port/
drawable-en-notouch-12key/
drawable-port-ldpi/
drawable-port-notouch-12key/
注意：因为dpi属性使用&quot;best match&quot;选择，所以drawable-port-ldpi/
没被清除。
2) 选择文档1中的表格“Table 2. Configuration qualifier names. ”最高优先级的属性（MCC最高，然后依次向下选择）。
3)  有包含上述属性的文件夹吗？
如果没有，跳转步骤２，选择下一优先级高的属性；
如果有，继续步骤４；
4) 清除不包含此属性的所有文件夹
drawable/
drawable-en/
drawable-en-port/
drawable-en-notouch-12key/
drawable-port-ldpi/
drawable-port-notouch-12key/
5) 重复步骤２和３，直到步骤４中只剩下一个文件夹则返回。例子中，屏幕方向是下一个最高优先级的属性，所以可以清除两个文件夹：
drawable-en/
drawable-en-port/
drawable-en-notouch-12key/

最终找到的文件夹就是drawable-en-port/

由上述过程可看出，匹配是看最高优先级别的属性，而不是一共匹配到的属性数量，例如：values-en-normal-hdpi的手机，values-en匹配比vaues-normal-hdpi更合适。

3、 备注
1. 文档1中的表格“Table 2. Configuration qualifier names. ”列出的属性集并不是一直不变的，有些新属性是在高级的android version才加入的，系统在识别到此新属性时会自动加上支持新属性的android最低版本属性，例如：xhdpi是android 2.2(sdk[img]/images/smiles/icon_cool.gif&quot; alt=&quot;[/img]新加入的，则values-xhdpi系统会自动认为是values-xhdpi-v8,这样新属性一定不会在android旧版本中匹配到了;
2. 对于指定分辨率的属性（例如：values-hdpi-1024x600，values-hdpi-960x540，values-mdpi-1024x600），指定分辨率属性并没出现在官网的匹配属性集里，也没找到对于分辨率属性的详细说明，经测试，这个分辨率属性匹配并不准确，例如Galaxy Nexus(1280x720 ),却可以匹配到values-hdpi-1024x600，因此希望最好不使用分辨率属性。