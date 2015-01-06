/* GCompris - ColorButton.qml
*
* Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.0

import "../../core"

Rectangle {
    id: button
    height: parent.height / 4
    width: height
    z: 3
    radius: width / 2
    border.color: "black"

    property alias text: buttonText.text

    signal clicked

    GCText {
        id: buttonText
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: Math.max(parent.height * 0.8, 10)
    }

    MouseArea {
        id: mouseArea
        anchors.centerIn: parent
        height: 3 * parent.height
        width: 3 * parent.width
        hoverEnabled: true
        onClicked: button.clicked()
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: button
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: button
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: button
                scale: 1.2
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
