/* GCompris - ActivityConfig.qml
 *
* Copyright (C) 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
    property alias speedSlider: speedSlider
    property int speedSetting: 5
    width: if(background) background.width

    Flow {
        spacing: 5
        width: activityConfiguration.width
        GCText {
            id: speedSliderText
            text: qsTr("Speed")
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }
        Flow {
            width: activityConfiguration.width
            spacing: 5
            GCSlider {
                id: speedSlider
                width: 250 * ApplicationInfo.ratio
                value: speedSetting
                maximumValue: 5
                minimumValue: 1
                scrollEnabled: false
            }
        }
    }

    property var dataToSave
    function setDefaultValues() {
        if(dataToSave && dataToSave.speedSetting) {
            activityConfiguration.speedSetting = dataToSave.speedSetting
        }
    }
    function saveValues() {
        var oldSpeed = activityConfiguration.speedSetting
        speedSetting = speedSlider.value
        dataToSave = {"speedSetting": speedSetting}
    }
}
