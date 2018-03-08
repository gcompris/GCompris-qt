/* GCompris - Question.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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

import "../../core"

Item {
    id: question

    property string text
    property bool displayed: text != "" ? true : false
    property string answer
    property string userEntry

    Rectangle {
        id: questionBg
        x: questionText.x - 4
        y: questionText.y - 4
        width: questionText.width + 8
        height: questionText.height + 8
        border.color: "black"
        border.width: 2
        radius: 8
        opacity: question.displayed ? 1 : 0

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#F0FFFFFF" }
            GradientStop { position: 0.9; color: "#F0F0F0F0" }
            GradientStop { position: 1.0; color: "#F0CECECE" }
        }

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
    
    GCText {
        id: questionText
        color: "black"
        fontSize: largeSize
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: TextEdit.WordWrap
        opacity: question.displayed ? 1 : 0
        text: question.text != "" ? question.text.arg(question.userEntry) : ""
        Behavior on opacity { NumberAnimation { duration: 100 } }

    }

    onUserEntryChanged: {
        if(userEntry === question.answer)
            bonus.good("flower")
    }
}
