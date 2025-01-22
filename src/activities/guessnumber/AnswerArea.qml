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

Item {
    id: answerBackground

    property string userEntry

    Rectangle {
        anchors.centerIn: hiddenText
        width: hiddenText.contentWidth + 2 * background.baseMargins
        height: hiddenText.contentHeight + background.baseMargins
        color: "#f2f2f2"
        radius: background.baseMargins
    }

    GCText {
        id: userEntryText
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#373737"
        font.bold: true
        fontSize: mediumSize
        fontSizeMode: Text.Fit
    }

    GCText {
        id: hiddenText
        opacity: 0
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        fontSize: mediumSize
        fontSizeMode: Text.Fit
        text: items.currentMax
    }

    onUserEntryChanged: {
        userEntryText.text = Core.convertNumberToLocaleString(Number(answerBackground.userEntry));
        if(userEntry != "")
            Activity.setUserAnswer(parseInt(userEntry))
        userEntryText.text = userEntry
    }
}
