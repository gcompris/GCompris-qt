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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import GCompris 1.0
import "enumerate.js" as Activity

import "../../core"

Rectangle {
    id: answerBackground
    width: Math.min(140 * ApplicationInfo.ratio, background.width / 4)
    height: width / 2
    radius: 10
    border {
        width: activeFocus ?  3 : 1
        color: "black"
    }

    states: [
        State {
            name: "badAnswer"
            PropertyChanges {target: answerBackground ; color: "red"}
        },
        State {
            name: "goodAnswer"
            PropertyChanges {target: answerBackground ; color: "green"}
        },
        State {
            name: "default"
            PropertyChanges {target: answerBackground ; color: activeFocus ? "#ff07fff2" : "#cccccccc"}
        }
    ]

    property string imgPath

    // True when the value is entered correctly
    property bool valid: false

    property GCSfx audioEffects

    Component.onCompleted: Activity.registerAnswerItem(answerBackground)

    onValidChanged: valid ? audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav") : null

    // A top gradient
    Rectangle {
        anchors.fill: parent
        anchors.margins: activeFocus ?  3 : 1
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: valid ? "#CC00FF00" : "#CCFFFFFF" }
            GradientStop { position: 0.5; color: valid ? "#8000FF00" : "#80FFFFFF" }
            GradientStop { position: 1.0; color: valid ? "#8000F000" : "#00000000" }
        }
    }

    // The OK feedback
    Image {
        source: "qrc:/gcompris/src/core/resource/apply.svg";
        fillMode: Image.PreserveAspectFit
        anchors {
            right: parent.left
            verticalCenter: parent.verticalCenter
        }
        sourceSize.height: parent.height * 0.8
        anchors.margins: 10
        opacity: valid ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            Activity.registerAnswerItem(answerBackground)
            Activity.resetAnswerAreaColor();
        }
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
        appendText(event.text)
    }

    function appendText(text) {
        var number = parseInt(text)
        if(isNaN(number))
            return

        if(userEntry.text === "?") {
            userEntry.text = ""
        }

        userEntry.text = text
        Activity.resetAnswerAreaColor();
        Activity.setUserAnswer(imgPath, parseInt(userEntry.text))
        Activity.enableOkButton()
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
        fontSize: 28
        style: Text.Outline
        styleColor: "white"
    }

}
