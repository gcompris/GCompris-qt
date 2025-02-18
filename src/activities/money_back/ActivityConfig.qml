/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2024 Mostafa Aboalkasim <mostafa.aboalkasim.offical@gmail.com>
 *
 * Authors:
 *   Mostafa Aboalkasim <mostafa.aboalkasim.offical@gmail.com>
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
        { "text": qsTr("Automatic"), "value": 1 },
        { "text": qsTr("OK button"), "value": 2 }
    ]

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            boxBackground: activityConfiguration.configBackground
            label: qsTr("Validate answers")
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = 1;
            modeBox.currentIndex = 0
        }
        for(var i = 0 ; i < availableModes.length ; i ++) {
            if(availableModes[i].value == dataToSave["mode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        dataToSave = {"mode": newMode};
    }
}
