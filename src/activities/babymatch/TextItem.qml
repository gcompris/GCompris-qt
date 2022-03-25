/* GCompris - TextItem.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../../core"

Item {
    id: displayText

    property double posX
    property double posY
    property double textWidth
    property double textHeight
    property string showText

    x: posX * parent.width
    y: posY * parent.height
    width: 1
    height: 1

    GCText {
        id: displayTxt
        anchors {
            horizontalCenter: displayText.horizontalCenter
            verticalCenter: displayText.verticalCenter
        }
        fontSizeMode: Text.Fit
        minimumPointSize: 7
        fontSize: mediumSize
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: textWidth * displayText.parent.width
        height: textHeight * displayText.parent.height
        wrapMode: TextEdit.WordWrap
        z: 2
        text: showText
    }

    Rectangle {
        id: displayTxtContainer
        anchors {
            horizontalCenter: displayText.horizontalCenter
            verticalCenter: displayText.verticalCenter
        }
        width: displayTxt.width + 10
        height: displayTxt.height + 10
        z: 1
        radius: 10
        color: "#373737"
    }
}
