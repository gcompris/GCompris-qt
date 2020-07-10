/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
    property string configurationLocale: "system"
    property alias easyModeImageBox: easyModeImageBox
    property alias easyModeAudioBox: easyModeAudioBox
    property bool easyModeImage: false
    property bool easyModeAudio: false
    width: if(background) background.width
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
        GCDialogCheckBox {
            id: easyModeImageBox
            width: parent.width
            text: qsTr("Display image to find as hint")
            checked: activityConfiguration.easyModeImage
            onCheckedChanged: {
                activityConfiguration.easyModeImage = checked
            }
        }
        GCDialogCheckBox {
            id: easyModeAudioBox
            width: parent.width
            text: qsTr("Speak words to find (if available) when three attempts are remaining")
            checked: activityConfiguration.easyModeAudio
            onCheckedChanged: {
                activityConfiguration.easyModeAudio = checked
            }
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
        easyModeImageBox.checked = Qt.binding(function(){return activityConfiguration.easyModeImage;})
        easyModeAudioBox.checked = Qt.binding(function(){return activityConfiguration.easyModeAudio;})

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

        activityConfiguration.easyModeImage = (dataToSave.easyModeImage ? dataToSave.easyModeImage === "true" : dataToSave.easyMode === "true")
        activityConfiguration.easyModeAudio = (dataToSave.easyModeAudio === "true")

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

        activityConfiguration.easyModeImage = activityConfiguration.easyModeImageBox.checked
        activityConfiguration.easyModeAudio = activityConfiguration.easyModeAudioBox.checked
        dataToSave = {"locale": newLocale, "activityLocale": activityConfiguration.locale,
                      "easyModeImage": "" + activityConfiguration.easyModeImage,
                      "easyModeAudio": "" + activityConfiguration.easyModeAudio}
    }
}
