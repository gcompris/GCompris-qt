/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property int answerMode: answerModeBox.currentIndex
    width: flick.width
    height: childrenRect.height

    readonly property var availableModes: [
        { "text": qsTr("Automatic"), "value": 1 },
        { "text": qsTr("OK button"), "value": 2 }
    ]

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: answerModeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Validate answers")
        }
    }

    property var dataToSave

    function setDefaultValues() {
        if(dataToSave["answerMode"] === undefined) {
            dataToSave["answerMode"] = 1;
        }

        for( var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value == dataToSave["answerMode"]) {
                answerModeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        dataToSave = {
            "answerMode": availableModes[answerMode].value
        };
    }
}
