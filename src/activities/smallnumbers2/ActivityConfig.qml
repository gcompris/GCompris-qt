/* GCompris - ActivityConfig.qml
 *
* SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
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
    property var availableModes: [
        { "text": qsTr("Dots"), "value": "dot" },
        { "text": qsTr("Arabic numbers"), "value": "number" },
        { "text": qsTr("Roman numbers"), "value": "roman" },
        { "text": qsTr("Images"), "value": "image" }
    ]
    property alias speedSlider: speedSlider
    property int speedSetting: 10
    width: flick.width

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: activityConfiguration.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Select Domino Representation")
        }
        GCText {
            id: speedSliderText
            width: parent.width
            text: qsTr("Speed")
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }
        GCSlider {
            id: speedSlider
            width: 250 * ApplicationInfo.ratio
            value: speedSetting
            to: 10
            from: 1
            wheelEnabled: false
        }
    }

    property var dataToSave
    function setDefaultValues() {
        speedSlider.value = Qt.binding(function() {return activityConfiguration.speedSetting;})
        for(var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value === dataToSave["mode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
        if(dataToSave["mode"] === undefined) {
            dataToSave["mode"] = "dot";
            modeBox.currentIndex = 0
        }
        if(dataToSave.speedSetting) {
            activityConfiguration.speedSetting = dataToSave.speedSetting
        }
        else {
            activityConfiguration.speedSetting = 10
        }
    }
    function saveValues() {
        var newMode = availableModes[modeBox.currentIndex].value;
        speedSetting = speedSlider.value
        dataToSave = {"mode": newMode, "speedSetting": speedSetting}
    }
}
