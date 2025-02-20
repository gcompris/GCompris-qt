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
import core 1.0 

import "../../../core"

Rectangle {
    anchors.fill: parent
    color: "#80FFFFFF"
    
    GCText {
        id: firstList
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: GCStyle.baseMargins
        }
        text: 
        "0 = 0000\n1 = 0001\n2 = 0010\n3 = 0011\n4 = 0100\n5 = 0101\n6 = 0110\n7 = 0111\n"
        fontSize: mediumSize
        color: GCStyle.darkerText
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        width: 0.5 * parent.width - 3 * GCStyle.halfMargins
        height: parent.height - 2 * GCStyle.baseMargins
        z: 2
    }
    
    GCText {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: GCStyle.baseMargins
        }
        text: 
        "08 = 1000\n09 = 1001\n10 = 1010\n11 = 1011\n12 = 1100\n13 = 1101\n14 = 1110\n15 = 1111"
        fontSize: mediumSize
        color: GCStyle.darkerText
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        width: firstList.width
        height: firstList.height
        z: 2
    }
}
