/* GCompris - AnswerArea.qml
*
* Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
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
import GCompris 1.0
import "enumerate.js" as Activity

import "../../core"

Rectangle {
    id: answerBackground
    width: 140 * ApplicationInfo.ratio
    height: 70 * ApplicationInfo.ratio
    color: activeFocus ? "#ff07fff2" : "#cccccccc"
    radius: 10
    border {
        width: activeFocus ?  3 : 1
        color: "black"
    }

    property string imgPath
    // The backspace code comming from the vitual keyboard
    property string backspaceCode

    Component.onCompleted: Activity.registerAnswerItem(answerBackground)

    // A top gradient
    Rectangle {
        anchors.fill: parent
        anchors.margins: activeFocus ?  3 : 1
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#CCFFFFFF" }
            GradientStop { position: 0.5; color: "#80FFFFFF" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: Activity.registerAnswerItem(answerBackground)

    }

    Image {
        id: img
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        height: parent.height * 0.75
        width: height
        source: imgPath
        fillMode: Image.PreserveAspectFit
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Backspace) {
            backspace()
        }
        appendText(event.text)
    }

    function backspace() {
        userEntry.text = userEntry.text.slice(0, -1)
        if(userEntry.text.length === 0) {
            userEntry.text = "?"
            Activity.setUserAnswer(imgPath, -1)
            return
        } else {
            Activity.setUserAnswer(imgPath, parseInt(userEntry.text))
            return
        }
    }

    function appendText(text) {
        if(text === answerBackground.backspaceCode) {
            backspace()
            return
        }

        var number = parseInt(text)
        if(isNaN(number))
            return

        if(userEntry.text === "?") {
            userEntry.text = ""
        }

        if(userEntry.text.length >= 2) {
            return
        }

        userEntry.text += text
        Activity.setUserAnswer(imgPath, parseInt(userEntry.text))
    }

    GCText {
        id: userEntry
        anchors {
            left: img.right
            verticalCenter: img.verticalCenter
            leftMargin: 10
        }
        text: "?"
        color: "black"
        font.pointSize: 28
        style: Text.Outline
        styleColor: "white"
    }
}
