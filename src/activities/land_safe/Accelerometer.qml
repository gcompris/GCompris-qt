/* GCompris - Accelerometer.qml
 *
 * Copyright (C) 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
