/* GCompris - AnswerArea.qml
*
* SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0
import "enumerate.js" as Activity

import "../../core"

Rectangle {
    id: answerBackground
    width: Math.min(140 * ApplicationInfo.ratio, background.width / 4)
    height: width / 2
    radius: 10
    border {
        width: activeFocus && state === "default" ?  5 : 1
        color: "#373737"
    }

    states: [
        State {
            name: "badAnswer"
            PropertyChanges {target: answerBackground ; color: "#ea5454"} //red
        },
        State {
            name: "goodAnswer"
            PropertyChanges {target: answerBackground ; color: "#54ea54"} //green
        },
        State {
            name: "default"
            PropertyChanges {target: answerBackground ; color: activeFocus ? "#63ede5" : "#eeeeee"} //light blue, grey
        }
    ]

    property string imgPath

    // True when the value is entered correctly
    property bool valid: false

    Component.onCompleted: Activity.registerAnswerItem(answerBackground)

    onValidChanged: valid ? Activity.playAudio() : null

    // A top gradient
    Rectangle {
        anchors.fill: parent
        anchors.margins: parent.activeFocus ?  5 : 1
        radius: 10
        visible: answerBackground.state === "default"
        gradient: Gradient {
            GradientStop { position: 0.0; color: valid ? "#ff54ea54" : "#CCFFFFFF" }
            GradientStop { position: 0.5; color: valid ? "#ff54ea54" : "#80FFFFFF" }
            GradientStop { position: 1.0; color: valid ? "#ff54ea54" : "#00000000" }
        }
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

        if(Activity.lockKeyboard === false) {
            userEntry.text = text;
            Activity.resetAnswerAreaColor();
        }
        if(Activity.answersMode === 1 && Activity.lockKeyboard === false) {
            valid = Activity.setUserAnswer(imgPath, parseInt(userEntry.text));
            Activity.checkAnswersAuto();
        } else {
            Activity.setUserAnswer(imgPath, parseInt(userEntry.text));
            Activity.enableOkButton();
            }
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
