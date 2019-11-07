/* GCompris - tutorial1.qml
 *
 * Copyright (C) 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
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
import GCompris 1.0

import "../../../core"
import "../../../activities"


Rectangle {
    id: tutorial2

    Component.onCompleted: {
        tutorial2.state = ''
            tutorial2.state === '' ? tutorial2.state = 'other' : tutorial2.state = ''
        console.log("test")
    }

    Rectangle {
        x:100
        y:100
        width: 100
        height: 1000
        color: "red"
        border.color: "black"
        border.width: 5
        radius: 10
    }

    anchors.fill: parent
    color: "#80FFFFFF"

    states: [
        // This adds a second state to the container where the rectangle is farther to the right

        State { name: "other"

            PropertyChanges {
                target: numberWeightDragElements.itemAt(0)
                x: 200
            }
        }
    ]
    transitions: [
        // This adds a transition that defaults to applying to all state changes

        Transition {

            // This applies a default NumberAnimation to any changes a state change makes to x or y properties
            NumberAnimation { properties: "x,y" }
        }
    ]

}
