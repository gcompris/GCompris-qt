/* GCompris - Domino.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick 2.2
import GCompris 1.0

Flipable {
    id: flipable

    property alias value1: number1.value
    property alias value2: number2.value
    property int valueMax: 9

    // Domino style
    property color color: "white"
    property color borderColor: "black"
    property int borderWidth: 2
    property int radius: width * 0.05
    property color backColor: "white"
    property color pointColor: "black"

    property bool flipEnabled: false
    property bool flipped: true

    property bool isClickable: true

    front: Rectangle {
        anchors.fill: parent
        smooth: true;
        color: flipable.color
        border.color: "black"
        border.width: flipable.borderWidth
        radius: flipable.radius

        DominoNumber {
            id: number1
            width: parent.width / 2
            height: parent.height
            color: flipable.pointColor
            borderColor: "black"
            borderWidth: 0
            radius: parent.height * 0.25
            valueMax: flipable.valueMax
            onValueChanged: if(flipEnabled) flipable.flipped = !flipable.flipped
            isClickable: flipable.isClickable
        }

        // Separation
        Rectangle {
            x: parent.width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 2
            height: parent.height * 0.7
            color: flipable.borderColor
        }

        DominoNumber {
            id: number2
            x: parent.width / 2
            width: parent.width / 2
            height: parent.height
            color: flipable.pointColor
            borderColor: "black"
            borderWidth: 0
            radius: parent.height * 0.25
            valueMax: flipable.valueMax
            onValueChanged: if(flipEnabled) flipable.flipped = !flipable.flipped
            isClickable: flipable.isClickable
        }
    }

    back: Rectangle {
        anchors.fill: parent
        smooth: true;
        color: flipable.backColor
        border.width: flipable.borderWidth
        radius: flipable.radius
    }

    transform: Rotation {
        id: rotation
        origin.x: flipable.width/2
        origin.y: flipable.height/2
        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
        angle: 0    // the default angle
    }

    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180 }
        when: flipable.flipped
        onCompleted: flipable.flipped = false
    }

    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: 250 }
    }
}
