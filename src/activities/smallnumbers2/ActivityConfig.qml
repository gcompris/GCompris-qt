/* GCompris - ActivityConfig.qml
 *
* Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
    height: columnContent.height
    width: if(background) background.width

    Column {
        id: columnContent
        spacing: 10
        Flow {
            spacing: 5
            width: activityConfiguration.width
            GCComboBox {
                id: modeBox
                model: availableModes
                background: activityConfiguration.background
                label: qsTr("Select Domino Representation")
            }
            GCText {
                id: speedSliderText
                text: qsTr("Speed")
                fontSize: mediumSize
                wrapMode: Text.WordWrap
                height: 100
            }
            Flow {
                width: activityConfiguration.width
                spacing: 5
                GCSlider {
                    id: speedSlider
                    width: 250 * ApplicationInfo.ratio
                    value: speedSetting
                    maximumValue: 10
                    minimumValue: 1
                    scrollEnabled: false
                }
            }
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
