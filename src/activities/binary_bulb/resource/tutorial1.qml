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

Rectangle {
    anchors.fill: parent
    color: "#80FFFFFF"
    
    GCText {
        id: firstList
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.height * 0.1
        }
        text: 
        "0 = 0000\n1 = 0001\n2 = 0010\n3 = 0011\n4 = 0100\n5 = 0101\n6 = 0110\n7 = 0111\n"
        font.pixelSize: parent.height / 15
        color: "black"
        horizontalAlignment: Text.AlignHLeft
        width: 0.4 * parent.width
        height: 0.9 * parent.height
        z: 2
    }
    
    GCText {
        anchors {
            left: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        text: 
        "08 = 1000\n09 = 1001\n10 = 1010\n11 = 1011\n12 = 1100\n13 = 1101\n14 = 1110\n15 = 1111"
        font.pixelSize: firstList.font.pixelSize
        color: "black"
        horizontalAlignment: Text.AlignHLeft
        width: 0.4 * parent.width
        height: 0.9 * parent.height
        z: 2
    }
}
