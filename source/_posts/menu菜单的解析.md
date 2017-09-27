---
title: menu菜单的解析
date: 2017-09-21 17:08:54
tags:
---
``` Java
private void parseMenu(XmlPullParser parser, AttributeSet attrs, Menu menu) throws XmlPullParserException, IOException {
    MenuState menuState = new MenuState(menu);

    int eventType = parser.getEventType();
    String tagName;
    boolean lookingForEndOfUnknownTag = false;
    String unknownTagName = null;

    // This loop will skip to the menu start tag
    do {
        if (eventType == XmlPullParser.START_TAG) {
            tagName = parser.getName();
            if (tagName.equals(XML_MENU)) {                                 //"menu"
                // Go to next tag
                eventType = parser.next();
                break;
            }
            throw new RuntimeException("Expecting menu, got " + tagName);
        }
        eventType = parser.next();
    } while (eventType != XmlPullParser.END_DOCUMENT);

    boolean reachedEndOfMenu = false;
    while (!reachedEndOfMenu) {
        switch (eventType) {
            case XmlPullParser.START_TAG:
                if (lookingForEndOfUnknownTag) {
                    break;
                }

                tagName = parser.getName();
                if (tagName.equals(XML_GROUP)) {                            //"group"
                    menuState.readGroup(attrs);
                } else if (tagName.equals(XML_ITEM)) {                      //"item"
                    menuState.readItem(attrs);
                } else if (tagName.equals(XML_MENU)) {                      //"menu"
                    // A menu start tag denotes a submenu for an item
                    SubMenu subMenu = menuState.addSubMenuItem();

                    // Parse the submenu into returned SubMenu
                    parseMenu(parser, attrs, subMenu);
                } else {
                    lookingForEndOfUnknownTag = true;
                    unknownTagName = tagName;
                }
                break;

            case XmlPullParser.END_TAG:
                tagName = parser.getName();
                if (lookingForEndOfUnknownTag && tagName.equals(unknownTagName)) {
                    lookingForEndOfUnknownTag = false;
                    unknownTagName = null;
                } else if (tagName.equals(XML_GROUP)) {
                    menuState.resetGroup();
                } else if (tagName.equals(XML_ITEM)) {
                    // Add the item if it hasn't been added (if the item was
                    // a submenu, it would have been added already)
                    if (!menuState.hasAddedItem()) {
                        if (menuState.itemActionProvider != null &&
                                menuState.itemActionProvider.hasSubMenu()) {
                            menuState.addSubMenuItem();
                        } else {
                            menuState.addItem();
                        }
                    }
                } else if (tagName.equals(XML_MENU)) {
                    reachedEndOfMenu = true;
                }
                break;

            case XmlPullParser.END_DOCUMENT:
                throw new RuntimeException("Unexpected end of document");
        }
        eventType = parser.next();
    }
}
```