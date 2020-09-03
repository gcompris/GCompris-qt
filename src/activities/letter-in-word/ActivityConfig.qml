/* GCompris - ActivityConfig.qml
 *
* Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
    width: if(background) background.width;
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
            width: column.width - 50
            text: qsTr("All the words")
            checked: savedMode === 11 ? true : false
            onCheckedChanged: easyModeConfig.checked = !normalModeConfig.checked;
        }

        GCDialogCheckBox {
            id: easyModeConfig
            width: column.width - 50
            text: qsTr("Only 5 words")
            checked: savedMode === 5 ? true : false
            onCheckedChanged: normalModeConfig.checked = !easyModeConfig.checked;
        }

        Flow {
            spacing: 5
            width: activityConfiguration.width
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
        }

        Flow {
            spacing: 5
            width: activityConfiguration.width
            GCComboBox {
                id: localeBox
                model: langs.languages
                background: activityConfiguration.background
                label: qsTr("Select your locale")
            }
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
