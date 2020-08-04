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

Item {
    id: activityConfiguration
    property Item background
    property alias modeBox: modeBox
    property alias enableVoicesBox: enableVoicesBox
    property bool voicesEnabled: enableVoicesBox.checked
    width: if(background) background.width
    property var availableModes: [
        { "text": qsTr("Arabic numerals"), "value": 1 },
        { "text": qsTr("Dots"), "value": 2 },
        { "text": qsTr("Fingers"), "value": 3 }
    ]
    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Digits representation")
        }
        GCDialogCheckBox {
            id: enableVoicesBox
            text: qsTr("Enable voices")
            checked: voicesEnabled
        }
    }

    property var dataToSave

    function setDefaultValues() {
        // Recreate the binding
        enableVoicesBox.checked = Qt.binding(function(){return activityConfiguration.voicesEnabled;});

        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = 1;
            modeBox.currentIndex = 0;
        }
        if(dataToSave["voicesEnabled"] === undefined) {
            dataToSave["voicesEnabled"] = "true";
            enableVoicesBox.checked = true;
        }
        for(var i = 0 ; i < availableModes.length ; i ++) {
            if(availableModes[i].value == dataToSave["mode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
        voicesEnabled = (dataToSave.voicesEnabled === "true")
    }

    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        voicesEnabled = enableVoicesBox.checked
        dataToSave = {"mode": newMode, "voicesEnabled": "" + voicesEnabled};
    }
}

