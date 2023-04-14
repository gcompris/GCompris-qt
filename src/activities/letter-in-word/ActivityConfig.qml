/* GCompris - ActivityConfig.qml
 *
* SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
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
    property string locale: "system"
    property alias normalModeConfig: normalModeConfig
    property int savedMode: 11
    property alias letterCaseBox: letterCaseBox
    property int savedLetterCase: 0
    width: flick.width
    height: childrenRect.height
    property alias availableLangs: langs.languages

    LanguageList {
        id: langs
    }

    Column {
        id: column
        spacing: 10
        width: activityConfiguration.width

        GCDialogCheckBox {
            id: normalModeConfig
            text: qsTr("All the words")
            checked: savedMode === 11 ? true : false
            onCheckedChanged: easyModeConfig.checked = !normalModeConfig.checked;
        }

        GCDialogCheckBox {
            id: easyModeConfig
            text: qsTr("Only 5 words")
            checked: savedMode === 5 ? true : false
            onCheckedChanged: normalModeConfig.checked = !easyModeConfig.checked;
        }

        GCComboBox {
            id: letterCaseBox
            label: qsTr("Select the case for the letters to search")
            background: activityConfiguration.background
            model: [
            {"text": qsTr("Mixed Case"), "value": Font.MixedCase},
            {"text": qsTr("Upper Case"), "value": Font.AllUppercase},
            {"text": qsTr("Lower Case"), "value": Font.AllLowercase}
            ]
            currentText: model[savedLetterCase].text
            currentIndex: savedLetterCase
        }

        GCComboBox {
            id: localeBox
            model: langs.languages
            background: activityConfiguration.background
            label: qsTr("Select your locale")
        }
    }

    function setLocale(localeToSet) {
        // Store the locale as-is to be displayed in menu
        activityConfiguration.locale = Core.resolveLocale(localeToSet);
    }

    property var dataToSave
    function setDefaultValues() {
        var localeUtf8 = dataToSave.locale;
        if(localeUtf8 !== "system") {
            localeUtf8 += ".UTF-8";
        }

        if(dataToSave.locale) {
            setLocale(localeUtf8);
        } else {
            activityConfiguration.localeBox.currentIndex = 0;
            setLocale(activityConfiguration.availableLangs[0].locale);
        }

        if(dataToSave.savedMode) {
            activityConfiguration.savedMode = dataToSave.savedMode;
        } else {
            activityConfiguration.savedMode = 11;
        }

        if(dataToSave.savedLetterCase) {
            activityConfiguration.savedLetterCase = dataToSave.savedLetterCase;
        } else {
            activityConfiguration.savedLetterCase = 0;
        }

        for(var i = 0 ; i < activityConfiguration.availableLangs.length ; i ++) {
            if(activityConfiguration.availableLangs[i].locale === localeUtf8) {
                activityConfiguration.localeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newLocale =
        activityConfiguration.availableLangs[activityConfiguration.localeBox.currentIndex].locale;
        // Remove .UTF-8
        if(newLocale.indexOf('.') != -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'));
        }

        activityConfiguration.savedMode = activityConfiguration.normalModeConfig.checked ? 11 : 5;
        activityConfiguration.savedLetterCase = activityConfiguration.letterCaseBox.currentIndex;

        setLocale(newLocale);

        dataToSave = {"locale": newLocale,
                      "savedMode": activityConfiguration.savedMode,
                      "savedLetterCase": activityConfiguration.savedLetterCase};
    }
}
