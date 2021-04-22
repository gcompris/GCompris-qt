/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2021 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "analog_electricity.js" as Activity

Item {
    id: activityConfiguration
    property Item background
    property alias modeBox: modeBox
    width: if(background) background.width
    property var availableModes: [
        { "text": qsTr("Tutorial Mode"), "value": "tutorial" },
        { "text": qsTr("Free Mode"), "value": "free" }
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
            dataToSave["mode"] = "tutorial";
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
        Activity.reset();
    }
}
