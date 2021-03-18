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
    color: "#f2f2f2"
    radius: 10

    property string userEntry

    GCText {
        id: userEntryText
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#373737"
        fontSize: largeSize
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
