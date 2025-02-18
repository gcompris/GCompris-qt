/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item configBackground
    property alias speedSlider: speedSlider
    property int speedSetting: 5
    width: flick.width
    height: childrenRect.height

    Column {
        spacing: GCStyle.baseMargins
        width: activityConfiguration.width
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
            from: 1
            to: 5
            wheelEnabled: false
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
