---
title: 如何解析voicemail-conf.xml文件
date: 2017-09-22 11:16:02
tags:
---
frameworks/opt/telephony/src/java/com/android/internal/telephony/gsm/VoiceMailConstants.java
``` Java
private void loadVoiceMail() {
    FileReader vmReader;
    final File vmFile = new File(Environment.getRootDirectory(),PARTNER_VOICEMAIL_PATH);
    try {
        vmReader = new FileReader(vmFile);
    } catch (FileNotFoundException e) {
        Log.w(LOG_TAG, "Can't open " + Environment.getRootDirectory() + "/" + PARTNER_VOICEMAIL_PATH);
        return;
    }
    try {
        XmlPullParser parser = Xml.newPullParser();
        parser.setInput(vmReader);
        XmlUtils.beginDocument(parser, "voicemail");
        while (true) {
            XmlUtils.nextElement(parser);
            String name = parser.getName();
            if (!"voicemail".equals(name)) {
                break;
            }
            String[] data = new String[SIZE];
            String numeric = parser.getAttributeValue(null, "numeric");
            data[NAME] = parser.getAttributeValue(null, "carrier");
            data[NUMBER] = parser.getAttributeValue(null, "vmnumber");
            data[TAG] = parser.getAttributeValue(null, "vmtag");
            CarrierVmMap.put(numeric, data);
        }
    } catch (XmlPullParserException e) {
        Log.w(LOG_TAG, "Exception in Voicemail parser " + e);
    } catch (IOException e) {
        Log.w(LOG_TAG, "Exception in Voicemail parser " + e);
    } finally {
        try {
            if (vmReader != null) {
                vmReader.close();
            }
        } catch (IOException e) {}
    }
}
```