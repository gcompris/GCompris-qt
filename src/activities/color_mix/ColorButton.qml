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
import GCompris 1.0

Item {
    id: button
    width: parent.width * 0.15
    height: width

    property alias source: buttonImage.source

    signal clicked

    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: width
        radius: width * 0.5
        color: "#E2E2E2"
        border.color: "#2a2a2a"
        border.width: 2 * ApplicationInfo.ratio
    }

    Image {
        id: buttonImage
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: width
        sourceSize.width: width
        sourceSize.height: height
    }

    MouseArea {
        id: mouseArea
        anchors.centerIn: parent
        enabled: !items.buttonsBlocked
        anchors.fill: parent
        hoverEnabled: true

        onClicked: button.clicked()
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                button {
                    scale: 1.0
                }
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                button {
                    scale: 0.9
                }
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                button {
                    scale: 1.1
                }
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
