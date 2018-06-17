/* GCompris - TextInputTool.qml
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
import GCompris 1.0
import QtQuick.Controls 1.5
import "../../core"

Rectangle {
    id: inputTextFrame
    color: background.color
    width: inputText.width + okButton.width + inputText.height + 10
    height: inputText.height * 1.1
    anchors.centerIn: parent
    radius: height / 2
    z: 1000
    opacity: 0
    property alias inputText: inputText
    TextField {
        id: inputText
        anchors.left: parent.left
        anchors.leftMargin: height / 1.9
        anchors.verticalCenter: parent.verticalCenter
        height: 50
        width: 300
        placeholderText: qsTr("Type here")
        font.pointSize: 32
    }

    // ok button
    Image {
        id: okButton
        source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
        sourceSize.height: inputText.height
        fillMode: Image.PreserveAspectFit
        anchors.left: inputText.right
        anchors.leftMargin: 10
        anchors.verticalCenter: inputText.verticalCenter

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: inputTextFrame.opacity == 1 ? true : false
            onClicked: {
                onBoardText.text = inputText.text
                // hide the inputTextFrame
                inputTextFrame.opacity = 0
                inputTextFrame.z = -1

                // show the text
                onBoardText.opacity = 1
                onBoardText.z = 100

                onBoardText.x = area.realMouseX
                onBoardText.y = area.realMouseY - onBoardText.height * 0.8

                // start the movement
                moveOnBoardText.start()
            }
        }
    }
}
