/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item background
    property alias speedSlider: speedSlider
    property int speedSetting: 5
    width: if(background) background.width

    Column {
        spacing: 10 * ApplicationInfo.ratio
        width: activityConfiguration.width
        GCText {
            id: speedSliderText
            text: qsTr("Speed")
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }
        GCSlider {
            id: speedSlider
            width: 250 * ApplicationInfo.ratio
            value: speedSetting
            minimumValue: 1
            maximumValue: 5
            scrollEnabled: false
        }
    }

    property var dataToSave
    function setDefaultValues() {
        // Recreate the binding
        speedSlider.value = Qt.binding(function() {return activityConfiguration.speedSetting;})
        if(dataToSave.speedSetting) {
            activityConfiguration.speedSetting = dataToSave.speedSetting
        }
        else {
            activityConfiguration.speedSetting = 5
        }
    }

    function saveValues() {
        dataToSave = {"speedSetting": speedSlider.value}
    }
}
