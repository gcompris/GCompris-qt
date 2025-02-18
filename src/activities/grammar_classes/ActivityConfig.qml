/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: activityConfiguration
    property Item configBackground
    property string locale: "system"
    property string configurationLocale: "system"
    height: childrenRect.height
    width: if(configBackground) configBackground.width * 0.9
    property alias availableLangs: langs.languages
    LanguageList {
        id: langs
    }

    Column {
        id: innerColumn
        spacing: GCStyle.baseMargins
        width: activityConfiguration.width
        GCComboBox {
            id: localeBox
            model: langs.languages
            boxBackground: activityConfiguration.configBackground
            label: qsTr("Select your locale")
        }
    }

    function setLocale(localeToSet: string) {
        // Store the locale as-is to be displayed in menu
        configurationLocale = localeToSet
        activityConfiguration.locale = Core.resolveLocale(localeToSet)
    }

    property var dataToSave

    function setDefaultValues() {
        var localeUtf8 = dataToSave.locale;
        if(localeUtf8 !== "system") {
            localeUtf8 += ".UTF-8";
        }

        if(dataToSave.locale) {
            setLocale(localeUtf8)
        }
        else {
            localeBox.currentIndex = 0
            setLocale(activityConfiguration.availableLangs[0].locale)
        }

        for(var i = 0 ; i < activityConfiguration.availableLangs.length ; i ++) {
            if(activityConfiguration.availableLangs[i].locale === localeUtf8) {
                localeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newLocale = activityConfiguration.availableLangs[localeBox.currentIndex].locale;
        // Remove .UTF-8
        if(newLocale.indexOf('.') !== -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'))
        }

        setLocale(newLocale);

        dataToSave = {"locale": newLocale, "activityLocale": activityConfiguration.locale}
    }
}
