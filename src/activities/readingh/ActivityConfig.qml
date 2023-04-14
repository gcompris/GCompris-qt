/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: activityConfiguration
    property Item background
    property alias localeBox: localeBox
    property alias speedSlider: speedSlider
    property int speedSetting: 10
    property string locale: "system"
    property string configurationLocale: "system"
    width: flick.width
    height: childrenRect.height
    property alias availableLangs: langs.languages
    LanguageList {
        id: langs
    }

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: activityConfiguration.width
        GCComboBox {
            id: localeBox
            model: langs.languages
            background: activityConfiguration.background
            label: qsTr("Select your locale")
        }
        GCText {
            id: speedSliderText
            width: parent.width
            text: qsTr("Speed")
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }
        GCSlider {
            id: speedSlider
            width: 250 * ApplicationInfo.ratio
            value: speedSetting
            to: 10
            from: 1
            wheelEnabled: false
        }
    }

    function setLocale(localeToSet) {
        // Store the locale as-is to be displayed in menu
        configurationLocale = localeToSet
        activityConfiguration.locale = Core.resolveLocale(localeToSet)
    }

    property var dataToSave
    function setDefaultValues() {
        // Recreate the binding
        speedSlider.value = Qt.binding(function() {return activityConfiguration.speedSetting;})

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

        if(dataToSave.speedSetting) {
            activityConfiguration.speedSetting = dataToSave.speedSetting
        }
        else {
            activityConfiguration.speedSetting = 10
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

        speedSetting = speedSlider.value

        setLocale(newLocale);
        dataToSave = {"locale": newLocale, "speedSetting": speedSetting, "activityLocale": activityConfiguration.locale}
    }
}
