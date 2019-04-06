/* GCompris - LightBulb.qml
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com>
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
import GCompris 1.0
import "binary_bulb.js" as Activity

Item {
    id: bulb
    anchors.verticalCenter: parent.verticalCenter
    state: "off"
    focus: true

    property alias valueVisible: valueText.visible

    Rectangle {
        color: "transparent"
        width: parent.width + 10
        height: parent.height + 10
        border.color: "red"
        border.width: 3
        anchors.centerIn: bulbImage
        radius: 5
        visible: index == items.currentSelectedBulb
    }
    Image {
        id: bulbImage
        width: parent.width
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: "resource/bulb_off.svg"
    }
    property string bit: ""
    readonly property int value: Math.pow(2, items.numberOfBulbs - index - 1)

    GCText {
        id: valueText
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: value
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Activity.changeState(index)
    }

    GCText {
        anchors.top: bulb.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: bit
        color: "white"
    }

    states: [
        State {
            name: "off"
            PropertyChanges {
                target: bulb
                bit: "0"
            }
            PropertyChanges {
                target: bulbImage
                source: "resource/bulb_off.svg"
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: bulb
                bit: "1"
            }
            PropertyChanges {
                target: bulbImage
                source: "resource/bulb_on.svg"
            }
        }
    ]
}
