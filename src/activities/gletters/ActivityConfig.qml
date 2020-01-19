/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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

Item {
    id: activityConfiguration
    property Item background
    property alias localeBox: localeBox
    property alias uppercaseBox: uppercaseBox
    property alias speedSlider: speedSlider
    property int speedSetting: 10
    property bool uppercaseOnly: false
    property string locale: "system"
    height: column.height
    width: if(background) background.width
    property alias availableLangs: langs.languages
    LanguageList {
        id: langs
    }

    Column {
        id: column
        spacing: 10
        Flow {
            spacing: 5
            width: dialogActivityConfig.width
            GCComboBox {
                id: localeBox
                model: langs.languages
                background: dialogActivityConfig
                label: qsTr("Select your locale")
            }
            
            GCDialogCheckBox {
                id: uppercaseBox
                width: dialogActivityConfig.width
                text: qsTr("Uppercase only mode")
                checked: uppercaseOnly
            }
            GCText {
                id: speedSliderText
                text: qsTr("Speed")
                fontSize: mediumSize
                wrapMode: Text.WordWrap
            }
            Flow {
                width: dialogActivityConfig.width
                spacing: 5
                GCSlider {
                    id: speedSlider
                    width: 250 * ApplicationInfo.ratio
                    value: speedSetting
                    maximumValue: 10
                    minimumValue: 1
                    scrollEnabled: false
                }
            }
        }
    }

    property var dataToSave

    function setDefaultValues() {
        // Recreate the binding
        uppercaseBox.checked = Qt.binding(function(){return activityConfiguration.uppercaseOnly;})

        var localeUtf8 = dataToSave.locale;
        if(localeUtf8 !== "system") {
            localeUtf8 += ".UTF-8";
        }

        for(var i = 0 ; i < activityConfiguration.availableLangs.length ; i ++) {
            if(activityConfiguration.availableLangs[i].locale === localeUtf8) {
                activityConfiguration.localeBox.currentIndex = i;
                break;
            }
        }
        activityConfiguration.locale = localeUtf8
        activityConfiguration.uppercaseOnly = (dataToSave.uppercaseMode === "true")
        activityConfiguration.speedSetting = dataToSave.speedSetting
    }

    function saveValues() {
        var configHasChanged = false
        var oldLocale = activityConfiguration.locale;
        var newLocale = activityConfiguration.availableLangs[activityConfiguration.localeBox.currentIndex].locale;
        // Remove .UTF-8
        if(newLocale.indexOf('.') != -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'))
        }

        var oldUppercaseMode = activityConfiguration.uppercaseOnly
        activityConfiguration.uppercaseOnly = activityConfiguration.uppercaseBox.checked

        var oldSpeed = activityConfiguration.speedSetting
        speedSetting = speedSlider.value

        dataToSave = {"locale": newLocale, "uppercaseMode": "" + activityConfiguration.uppercaseOnly, "speedSetting": speedSetting}
        activityConfiguration.locale = newLocale;

        if(oldLocale !== newLocale || oldUppercaseMode !== activityConfiguration.uppercaseOnly || oldSpeed !== speedSetting) {
            configHasChanged = true;
        }

        // Restart the activity with new information
        if(configHasChanged) {
            background.stop();
            background.start();
        }
    }
}
