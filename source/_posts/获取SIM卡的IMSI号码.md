---
title: 获取SIM卡的IMSI号码
date: 2017-09-22 10:38:33
tags:
---
//强哥的方法
``` Java
TelephonyManager tm = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
String mIMSI = tm.getSubscriberIdGemini(PhoneConstants.GEMINI_SIM_1);
```
//MTK的方法
``` Java
import com.android.internal.telephony.Phone;
import com.android.internal.telephony.PhoneFactory;
import com.android.internal.telephony.RIL;
private static final int EVENT_GET_IMSI_DONE = 1;

Phone phone = PhoneFactory.getDefaultPhone();
phone.mCM.getIMSI(obtainMessage(EVENT_GET_IMSI_DONE));
public void handleMessage(Message msg) {
    switch (msg.what){
        case EVENT_GET_IMSI_DONE:
            isRecordLoadResponse = true;
            ar = (AsyncResult)msg.obj;
            if (ar.exception != null) {
                Log.e(LOG_TAG, "Exception querying IMSI, Exception:" + ar.exception);
                break;
            }
            imsi = (String) ar.result;
            Log.d(LOG_TAG, "IMSI: " + imsi.substring(0, 6) + "xxxxxxx");
            break;
        default:
            break;
    }
}
```
