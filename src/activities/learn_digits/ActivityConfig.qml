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
import core 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item configBackground
    property alias modeBox: modeBox
    property alias enableVoicesBox: enableVoicesBox
    property bool voicesEnabled: enableVoicesBox.checked
    width: flick.width
    height: childrenRect.height
    property var availableModes: [
        { "text": qsTr("Arabic numerals"), "value": 1 },
        { "text": qsTr("Dots"), "value": 2 },
        { "text": qsTr("Fingers"), "value": 3 }
    ]
    Column {
        spacing: GCStyle.baseMargins
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            boxBackground: activityConfiguration.configBackground
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

