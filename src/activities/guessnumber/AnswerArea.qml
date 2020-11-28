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
import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "guessnumber.js" as Activity

Rectangle {
    id: answerBackground
    width: hiddentext.width * 1.2
    height: 60 * ApplicationInfo.ratio
    color: activeFocus ? "#ff07fff2" : "#cccccccc"
    radius: 10
    border {
        width: activeFocus ?  3 : 1
        color: "black"
    }

    property string userEntry
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

    GCText {
        id: userEntryText
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "black"
        fontSize: largeSize
        style: Text.Outline
        styleColor: "white"
    }

    GCText {
        id: hiddentext
        opacity: 0
        fontSize: userEntryText.fontSize
        text: items.currentMax
    }

    onUserEntryChanged: {
        userEntryText.text = Number(answerBackground.userEntry).toLocaleString(Qt.locale(ApplicationInfo.localeShort), 'f', 0)
        if(userEntry != "")
            Activity.setUserAnswer(parseInt(userEntry))
        userEntryText.text = userEntry
    }
}
