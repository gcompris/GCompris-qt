/* GCompris - Thickness.qml
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
 *               2018 Amit Sagtani <asagtani06@gmail.com>
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

Rectangle {
    id: frame

    property bool horizontalScreen: background.width > background.height

    color: items.sizeS == Math.floor(lineSize * 15) ? "#ffff66" : "#ffffb3"
    width: horizontalScreen ? 40 : 20
    height: width
    radius: horizontalScreen ? 8 : 4
    border.color: "#cccc00"
    border.width: 2
    opacity: items.sizeS == Math.floor(lineSize * 15) ? 1 : 0.7

    anchors.verticalCenter: parent.verticalCenter

    property real lineSize: 0.5

    Rectangle {
        id: thickness
        color: items.paintColor
        radius: horizontalScreen ? 30 : 10
        width: horizontalScreen ? lineSize * 25 : lineSize * 10
        height: width
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            items.sizeS = parent.lineSize * 18
            print("frame.lineSize " + Math.floor(frame.lineSize * 15))
            print("items.sizeS: " + items.sizeS)
        }

        states: State {
            name: "scaled"; when: mouseArea.containsMouse
            PropertyChanges {
                target: frame
                opacity: 1
                scale: 1.2
           }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
        }
    }
}
