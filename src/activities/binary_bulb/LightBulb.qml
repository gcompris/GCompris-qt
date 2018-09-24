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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import "../../core"
import GCompris 1.0
import "binary_bulb.js" as Activity

Image {
    id: bulb
    anchors.verticalCenter: parent.verticalCenter
    sourceSize.height: 60 * ApplicationInfo.ratio
    source: "resource/bulb_off.svg"
    state: "off"
    focus: true

    property string bit: ""
    readonly property int value: Math.pow(2,items.numberOfBulbs-index-1)

    GCText {
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: value
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Activity.changeState(index, value)
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
                source: "resource/bulb_off.svg"
                bit: "0"
            }
        },
        State {
            name: "on"
            PropertyChanges {
                target: bulb
                source: "resource/bulb_on.svg"
                bit: "1"
            }
        }
    ]
}
