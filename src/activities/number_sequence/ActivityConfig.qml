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
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property bool highlightEnabled: highlightBox.checked
    property alias modeBox: modeBox
    width: flick.width
    property var availableModes: [
        { "text": qsTr("Automatic"), "value": 1 },
        { "text": qsTr("Manual"), "value": 2 }
    ]
    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Go to the next level")
        }
        GCDialogCheckBox {
            id: highlightBox
            text: qsTr("Highlight next point")
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

        if(dataToSave["highlight"] === undefined) {
            dataToSave["highlight"] = "true";
        }
        highlightBox.checked = (dataToSave.highlight === "true")
    }

    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        dataToSave = {"mode": newMode, "highlight" : "" + highlightEnabled};
    }
}
