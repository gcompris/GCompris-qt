/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2019 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property alias modeBox: modeBox
    width: flick.width
    property var availableModes: [
        { "text": qsTr("Dots"), "value": "dot" },
        { "text": qsTr("Arabic numbers"), "value": "number" },
        { "text": qsTr("Roman numbers"), "value": "roman" },
        { "text": qsTr("Images"), "value": "image" }
    ]
    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Select Domino Representation")
        }
    }

    property var dataToSave
    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = "dot";
            modeBox.currentIndex = 0
        }
        for(var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value === dataToSave["mode"]) {
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
