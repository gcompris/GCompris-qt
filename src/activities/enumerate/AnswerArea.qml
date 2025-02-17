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
    width: activityBackground.answersWidth
    height: width * 0.5
    radius: activityBackground.baseMargins
    border {
        width: activeFocus && state === "default" ?  3 * ApplicationInfo.ratio : Math.max(1, ApplicationInfo.ratio)
        color: "#373737"
    }

    states: [
        State {
            name: "badAnswer"
            PropertyChanges { answerBackground { color: "#D94444" } } //red
        },
        State {
            name: "goodAnswer"
            PropertyChanges { answerBackground { color: "#54ea54"} } //green
        },
        State {
            name: "default"
            PropertyChanges { answerBackground { color: activeFocus ? "#6bcbde" : "#fff"} } //lightblue, white
        }
    ]

    GCSoundEffect {
        id: winSound
        source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
    }

    property string imgPath

    // True when the value is entered correctly
    property bool valid: false

    Component.onCompleted: Activity.registerAnswerItem(answerBackground)

    onValidChanged: valid ? winSound.play() : null

    // A top gradient
    Rectangle {
        anchors.fill: parent
        anchors.margins: parent.border.width
        radius: parent.radius - parent.border.width
        visible: answerBackground.state === "default"
        gradient: Gradient {
                GradientStop { position: 0.0; color: valid ? "#54ea54" : "#CCFFFFFF" }
                GradientStop { position: 0.5; color: valid ? "#54ea54" : "#80FFFFFF" }
                GradientStop { position: 1.0; color: valid ? "#54ea54" : "#00000000" }
        }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !items.buttonsBlocked
        onClicked: {
            Activity.registerAnswerItem(answerBackground)
            Activity.resetAnswerAreaColor();
        }
    }

    Image {
        id: img
        anchors {
            left: parent.left
            leftMargin: activityBackground.baseMargins
            verticalCenter: parent.verticalCenter
        }
        height: parent.height - activityBackground.baseMargins
        width: height
        source: imgPath
        fillMode: Image.PreserveAspectFit
    }

    Keys.onPressed: (event) => {
        if(!items.buttonsBlocked)
            appendText(event.text);
    }

    function appendText(text: string) {
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
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: activityBackground.baseMargins
        }
        text: "?"
        color: "black"
        fontSize: 28
        fontSizeMode: Text.Fit
        style: Text.Outline
        styleColor: "white"
    }

}
