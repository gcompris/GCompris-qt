/* GCompris - ActivityConfig.qml
 *
 * Copyright (C) 2019 Johnny Jazeix <jazeix@gmail.com>
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
    Flow {
        id: flow
        spacing: 5
        width: parent.width
        GCComboBox {
            id: modeBox
            model: availableModes
            background: activityConfiguration.background
            label: qsTr("Select Domino Representation")
        }
    }

    property var dataToSave
    function setDefaultValues() {
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
    }
}
