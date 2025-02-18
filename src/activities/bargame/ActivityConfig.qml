/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <shivam828787@gmail.com>
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
    width: flick.width
    height: childrenRect.height
    property var availableModes: [
        { "text": qsTr("Easy"), "value": 1 },
        { "text": qsTr("Medium"), "value": 2 },
        { "text": qsTr("Difficult"), "value": 3 }
    ]
    Column {
        spacing: GCStyle.baseMargins
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            boxBackground: activityConfiguration.configBackground
            label: qsTr("Select your difficulty")
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = 1;
            modeBox.currentIndex = 0
        }
        for(var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value == dataToSave["mode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        if (newMode != dataToSave["mode"]) {
            dataToSave["mode"] = newMode;
            dataToSave = {"mode": dataToSave["mode"]};
        }
    }
}
