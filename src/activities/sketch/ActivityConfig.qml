/* GCompris - ActivityConfig.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: activityConfiguration
    property Item configBackground
    property alias undoSlider: undoSlider
    property int undoSetting: ApplicationInfo.isMobile ? 5 : 10
    width: flick.width
    height: childrenRect.height

    Column {
        spacing: GCStyle.baseMargins
        width: activityConfiguration.width
        GCText {
            id: undoSliderText
            text: qsTr("Number of undo: %1").arg(undoSlider.value)
            width: parent.width
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }
        GCSlider {
            id: undoSlider
            width: 250 * ApplicationInfo.ratio
            value: activityConfiguration.undoSetting
            to: 20
            from: 1
            wheelEnabled: false
        }
        GCText {
            id: warningText
            text: qsTr("Warning: setting the number of undo too high can make the application crash if your device doesn't have enough memory.")
            width: parent.width
            fontSize: smallSize
            wrapMode: Text.WordWrap
        }
    }

    property var dataToSave
    function setDefaultValues() {
        // Recreate the binding
        undoSlider.value = Qt.binding(function() {return activityConfiguration.undoSetting;})

        if(dataToSave.undoSetting) {
            activityConfiguration.undoSetting = dataToSave.undoSetting
        }
        else {
            activityConfiguration.undoSetting = ApplicationInfo.isMobile ? 5 : 10
        }
    }

    function saveValues() {
        undoSetting = undoSlider.value

        dataToSave = { "undoSetting": undoSetting }
    }
}
