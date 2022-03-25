/* GCompris - Accelerometer.qml
 *
 * SPDX-FileCopyrightText: 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"

Item {
    id: root

    property double max: 1
    property double min: -1
    property double current: min
    property alias currentRect: currentRect.anchors

    Rectangle {
        id: rect
        width: parent.width
        height: parent.height
        anchors.fill: parent
        border.width: root.width / 10
        border.color: "lightgray"
        radius: root.width / 3

        gradient: Gradient {
            GradientStop { position: 0.0; color: "green" }
            GradientStop { position: 1-(-root.min/(root.max-root.min)); color: "yellow" }
            GradientStop { position: 1.0; color: "red" }
        }

        Rectangle {
            id: baseline
            height: 2
            width: rect.width
            anchors.left: rect.left
            anchors.leftMargin: 0
            anchors.bottom: rect.bottom
            anchors.bottomMargin: -root.min/(root.max-root.min) * rect.height
            color: "steelblue"
        }

        Rectangle {
            id: currentRect
            width: rect.width * 1.1
            height: root.width / 10
            anchors.left: rect.left
            anchors.leftMargin: -rect.width * 0.05
            anchors.bottom: rect.bottom
            anchors.bottomMargin: Math.max(0, (-root.min + root.current)/(root.max-root.min) * rect.height - height)
            color: "white"

            Behavior on anchors.bottomMargin {
                PropertyAnimation  {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
