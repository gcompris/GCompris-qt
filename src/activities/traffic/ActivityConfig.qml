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
        { "text": qsTr("Colors"), "value": "COLOR" },
        { "text": qsTr("Images"), "value": "IMAGE" }
    ]
    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Select your mode")
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = "IMAGE";
            modeBox.currentIndex = 0
        }
        for(var i = 0 ; i < availableModes.length ; i ++) {
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
