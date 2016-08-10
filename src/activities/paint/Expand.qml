/* GCompris - Expand.qml
 *
 * Copyright (C) 2016 Toncu Stefan <stefan.toncu29@gmail.com>
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

import QtQuick 2.1

Rectangle {
    id: expand

    property int sizeS

    anchors {
        leftMargin: 10
        left: parent.right
    }

    opacity: 0

    width: 245
    height: 55
    border.color: "black"
    border.width: 4
    color: "black"


    Flow {
        id: group
        width: 230
        height: 50
        anchors.centerIn: parent

        spacing: 10

        Repeater {
            id: repeater
            model: 4
//            anchors.centerIn: parent

            Rectangle {

                width: 50
                height: 50
                color: "grey"

                Rectangle {
                    id: option
                    width: index * 10 + 20
                    height: 50
                    anchors.centerIn: parent
                    color: "green"
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        //code
                        colorTools.z = 0
                        tool.opac = 0
                        expand.sizeS = index + 1
                    }
                }
            }
        }
    }
}
