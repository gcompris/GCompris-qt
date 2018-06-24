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
    property bool horizontalMode: background.width > background.height
    color: background.color
    width: horizontalMode ? background.width * 0.40 : background.width * 0.60
    height: horizontalMode ? background.height * 0.40 : background.height * 0.30
    anchors.centerIn: parent
    radius: 10
    z: 1000
    opacity: 0

    property alias inputText: inputText
    property string fontSize: "8px "
    property string isBold: boldText.checked ? "bold " : ""
    property string isItalic: italicText.checked ? "italic " : ""
    property string fontFamily: ApplicationSettings.font + ", serif"
    property string font: isBold + isItalic + fontSize + fontFamily

    TextField {
        id: inputText
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        height: 50
        width: parent.width * 0.70
        placeholderText: qsTr("Type here")
        font.pointSize: 32
    }

    // ok button
    Image {
        id: okButton
        source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
        sourceSize.height: inputText.height * 1.3
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

    //bold text option
    GCDialogCheckBox {
        id: boldText
        anchors.top: inputText.bottom
        anchors.left: inputText.left
        anchors.topMargin: 10
        labelTextFontSize: horizontalMode ? 16 : 10
        indicatorImageHeight: horizontalMode ? 40 * ApplicationInfo.ratio : 20 * ApplicationInfo.ratio
        onCheckedChanged: {
            canvas.updateDemoText()
            onBoardText.font.bold = checked
        }
        text: qsTr("Bold")
    }

    // Italic text option
    GCDialogCheckBox {
        id: italicText
        anchors.top: boldText.bottom
        anchors.topMargin: 10
        anchors.left: inputText.left
        labelTextFontSize: boldText.labelTextFontSize
        indicatorImageHeight: boldText.indicatorImageHeight
        onCheckedChanged: {
            canvas.updateDemoText()
            onBoardText.font.italic = checked
        }
        text: qsTr("Italic")
    }

    // Font-size slider
    GCSlider {
        id: fontSizeSlider
        width: parent.width * 0.60
        anchors.top: italicText.bottom
        anchors.topMargin: 10
        anchors.left: inputText.left

        //Initial font size
        value: 16

        //Minimum font size allowed
        minimumValue: 8

        //Maximum font size allowed
        maximumValue: 60

        onValueChanged: {
            fontSize = value.toString() + "px "
            canvas.updateDemoText()
            onBoardText.font.pointSize = value
        }
        stepSize: 8
    }

    // Text settings visualization
    Canvas {
        id: canvas
        width: parent.width * 0.20
        height: parent.height * 0.30
        anchors.horizontalCenter: okButton.horizontalCenter
        anchors.top: okButton.bottom
        anchors.topMargin: 20
        onPaint: updateDemoText()
        function updateDemoText() {
            var ctx = canvas.getContext("2d")
            ctx.fillStyle = "white"
            ctx.fillRect(0, 0, width, height)
            ctx.font = inputTextFrame.font
            ctx.fillStyle = "black"
            ctx.fillText("Aa", width/2 - fontSizeSlider.value/2, height - fontSizeSlider.value/2)
            canvas.requestPaint()
        }
    }
}
