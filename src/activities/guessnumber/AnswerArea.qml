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
import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
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
        userEntryText.text = Core.convertNumberToLocaleString(Number(answerBackground.userEntry));
        if(userEntry != "")
            Activity.setUserAnswer(parseInt(userEntry))
        userEntryText.text = userEntry
    }
}
