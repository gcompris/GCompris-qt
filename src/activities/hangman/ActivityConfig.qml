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
    property string locale: "system"
    property string configurationLocale: "system"
    property bool easyModeImage: true
    property bool easyModeAudio: true
    height: childrenRect.height
    width: if(background) background.width * 0.9
    property alias availableLangs: langs.languages
    LanguageList {
        id: langs
    }

    Column {
        id: innerColumn
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
            text: qsTr("Display the image to find as hint")
            checked: easyModeImage
            onCheckedChanged: {
                easyModeImage = checked
            }
        }
        GCDialogCheckBox {
            id: easyModeAudioBox
            width: parent.width
            text: qsTr("Speak the words to find (if available) when three attempts are remaining")
            checked: easyModeAudio
            onCheckedChanged: {
                easyModeAudio = checked
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

        if(dataToSave["easyModeImage"] === undefined && dataToSave["easyMode"] === undefined) {
            dataToSave["easyModeImage"] = "true";
        }
        easyModeImageBox.checked = (dataToSave.easyModeImage ? dataToSave.easyModeImage === "true" : dataToSave.easyMode === "true")
        if(dataToSave["easyModeAudio"] === undefined) {
            dataToSave["easyModeAudio"] = "true";
        }
        easyModeAudioBox.checked = (dataToSave.easyModeAudio === "true")

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
        if(newLocale.indexOf('.') != -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'))
        }

        setLocale(newLocale);

        dataToSave = {"locale": newLocale, "activityLocale": activityConfiguration.locale,
                      "easyModeImage": "" + easyModeImage,
                      "easyModeAudio": "" + easyModeAudio}
    }
}
