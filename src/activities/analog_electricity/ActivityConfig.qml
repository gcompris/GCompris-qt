/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2021 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "analog_electricity.js" as Activity

Item {
    id: activityConfiguration
    property Item configBackground
    property alias modeBox: modeBox
    width: flick.width
    height: childrenRect.height
    property var availableModes: [
        { "text": qsTr("Tutorial Mode"), "value": "tutorial" },
        { "text": qsTr("Free Mode"), "value": "free" }
    ]
    Column {
        spacing: GCStyle.baseMargins
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            boxBackground: activityConfiguration.configBackground
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
