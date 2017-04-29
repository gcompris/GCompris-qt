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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "../../core"

Item {
    id: displayText

    property double posX
    property double posY
    property double textWidth
    property string showText

    x: posX * parent.width
    y: posY * parent.height

    GCText {
        id: displayTxt
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        property bool firstTime: true
        fontSize: Math.max(Math.min(displayText.parent.width / 20 , 12), 5)
        color: "white"
        style: Text.Outline
        styleColor: "black"
        horizontalAlignment: Text.AlignHCenter
        width: Math.min(implicitWidth, textWidth * displayText.parent.width)
        wrapMode: TextEdit.WordWrap
        z: 2
        text: showText
        onHeightChanged: {
            if(firstTime) {
                displayTxtContainer.height = displayTxt.height * Math.ceil(displayTxt.implicitWidth / displayTxt.width)
                firstTime = false
            }
            else
                displayTxtContainer.height = displayTxt.height
        }
    }

    Rectangle {
        id: displayTxtContainer
        anchors.top: displayTxt.top
        anchors.horizontalCenter: displayTxt.horizontalCenter
        width: displayTxt.width + 10
        height: displayTxt.fontSize * 2.25 * Math.ceil(displayTxt.implicitWidth / displayTxt.width)
        z: 1
        opacity: 0.8
        radius: 10
        border.width: 2
        border.color: "black"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#000" }
            GradientStop { position: 0.9; color: "#666" }
            GradientStop { position: 1.0; color: "#AAA" }
        }
    }
}
