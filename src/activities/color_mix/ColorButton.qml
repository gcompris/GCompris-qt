/* GCompris - ColorButton.qml
*
* SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import "../../core"

Item {
    id: button
    height: parent.height / 4
    width: height
    z: 3

    property alias source: buttonImage.source

    signal clicked

    Image {
        id: buttonImage
        anchors.centerIn: parent
        sourceSize.width: parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.centerIn: parent
        height: 2.3 * parent.height
        width: 2.3 * parent.width
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
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
