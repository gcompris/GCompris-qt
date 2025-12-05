/* GCompris - ColorButton.qml
*
* SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick
import core 1.0
import "../../core"

Item {
    id: button
    width: parent.width * 0.2
    height: parent.height

    property alias source: buttonImage.source
    property bool buttonsBlocked
    signal clicked

    Rectangle {
        id: buttonBg
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: width
        radius: width * 0.5
        color: GCStyle.paperWhite
        border.color: GCStyle.darkBorder
        border.width: GCStyle.thinBorder

        Image {
            id: buttonImage
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
            sourceSize.width: width
            sourceSize.height: height
        }
    }

    MouseArea {
        id: mouseArea
        enabled: !button.buttonsBlocked
        anchors.fill: parent
        hoverEnabled: true

        onClicked: button.clicked()
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                buttonBg {
                    scale: 1.0
                }
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                buttonBg {
                    scale: 0.9
                }
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                buttonBg {
                    scale: 1.1
                }
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
