/* GCompris - ControlButton.qml
 *
 * SPDX-FileCopyrightText: 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

/**
* A QML to use as button
*
* Currently used in land_safe and gravity activities
*/

Image {
    id: root
    state: "notclicked"
    sourceSize.width: 54 * ApplicationInfo.ratio

    signal clicked
    signal pressed
    signal released

    /** How much the mousearea should exceed the visible item on each border */
    property double exceed: 0

    MouseArea {
        id: mouseArea
        anchors.left: parent.left
        anchors.leftMargin: -root.exceed
        anchors.top: parent.top
        anchors.topMargin: -root.exceed
        width: root.width + 2*root.exceed
        height: root.height + 2*root.exceed
        hoverEnabled: !ApplicationInfo.isMobile
        onClicked: root.clicked()
        onPressed: root.pressed()
        onReleased: root.released()
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: root
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: root
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: root
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
}
