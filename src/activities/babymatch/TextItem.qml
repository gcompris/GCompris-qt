/* GCompris - TextItem.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
