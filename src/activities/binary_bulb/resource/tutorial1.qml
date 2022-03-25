/* GCompris - tutorial1.qml
 *
 * SPDX-FileCopyrightText: 2018 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
