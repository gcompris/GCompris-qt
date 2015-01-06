/* GCompris - Arrows.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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

Rectangle {
    border.color: "black"
    border.width: 2
    radius: 5

    Component {
        id: anArrow
        Image {
            source: "qrc:/gcompris/src/activities/gnumch-equality/resource/arrow.svg"

            anchors.fill:parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Loader {
        id: bottom
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(2)
        }
    }

    Loader {
        id: left
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(1)
        }

        transform: Rotation {origin.x: left.width/2; origin.y: 0 ;angle: 90}
    }

    Loader {
        id: top
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(3)
        }

        transform: Rotation {origin.x: left.width/2; origin.y: 0 ;angle: 180}
    }

    Loader {
        id: right
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(0)
        }

        transform: Rotation {origin.x: left.width/2; origin.y: 0 ;angle: 270}
    }
}
 
