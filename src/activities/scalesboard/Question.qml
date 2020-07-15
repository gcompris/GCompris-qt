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
    property string answer
    property string userEntry

    Rectangle {
        id: questionBg
        width: parent.width
        height: parent.height
        border.color: "black"
        border.width: 2
        radius: 8

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
        font.pointSize: NaN  // need to clear font.pointSize explicitly
        fontSizeMode: Text.Fit
        minimumPixelSize: 10
        font.pixelSize: parent.width * 0.10
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: TextEdit.WordWrap
        text: question.text != "" ? question.text.arg(question.userEntry) : ""
        Behavior on opacity { NumberAnimation { duration: 100 } }

    }
}
