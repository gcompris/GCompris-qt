/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: activityConfiguration
    property Item configBackground
    property alias localeBox: localeBox
    property string locale: "system"
    property string configurationLocale: "system"
    width: flick.width
    height: childrenRect.height
    property alias availableLangs: langs.languages
    LanguageList {
        id: langs
    }

    Column {
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
            activityConfiguration.localeBox.currentIndex = 0
            setLocale(activityConfiguration.availableLangs[0].locale)
        }

        for(var i = 0 ; i < activityConfiguration.availableLangs.length ; i ++) {
            if(activityConfiguration.availableLangs[i].locale === localeUtf8) {
                activityConfiguration.localeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newLocale = activityConfiguration.availableLangs[activityConfiguration.localeBox.currentIndex].locale;
        // Remove .UTF-8
        if(newLocale.indexOf('.') != -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'))
        }

        setLocale(newLocale);

        // Only change the locale to not erase the progress which is
        // stored on dataToSave in the onSaveData on Lang.qml file
        dataToSave["locale"] = newLocale;
        dataToSave["activityLocale"] = activityConfiguration.locale
    }
}
