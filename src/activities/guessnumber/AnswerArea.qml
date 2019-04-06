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
        text: answerBackground.userEntry
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
        if(userEntry != "")
            Activity.setUserAnswer(parseInt(userEntry))
    }
}
