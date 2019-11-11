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

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property alias localeBox: localeBox
    property alias uppercaseBox: uppercaseBox
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
            width: activityConfiguration.width
            GCComboBox {
                id: localeBox
                visible: true
                model: langs.languages
                background: activityConfiguration.background
                label: qsTr("Select your locale")
            }
        }
        GCDialogCheckBox {
            id: uppercaseBox
            visible: true
            width: parent.width
            text: qsTr("Uppercase only mode")
            checked: activityConfiguration.uppercaseOnly
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
        dataToSave = {"locale": newLocale, "uppercaseMode": "" + activityConfiguration.uppercaseOnly}

        if(oldLocale !== newLocale || oldUppercaseMode !== activityConfiguration.uppercaseOnly) {
            configHasChanged = true;
        }
        activityConfiguration.uppercaseOnly = activityConfiguration.uppercaseBox.checked
        activityConfiguration.locale = newLocale;

        // Restart the activity with new information
        if(configHasChanged) {
            background.stop();
            background.start();
        }
    }
}
