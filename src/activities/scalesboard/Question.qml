/* GCompris - Question.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"

Rectangle {
    id: question
    width: parent.width
    height: parent.height
    color: GCStyle.lightBg
    border.color: GCStyle.blueBorder
    border.width: GCStyle.thinBorder
    radius: GCStyle.halfMargins

    property string text
    property string answer
    property string userEntry

    Behavior on opacity { NumberAnimation { duration: 100 } }

    GCText {
        id: questionText
        color: GCStyle.darkText
        anchors.centerIn: parent
        width: parent.width - GCStyle.baseMargins * 2
        height: parent.height - GCStyle.baseMargins
        fontSizeMode: Text.Fit
        minimumPixelSize: 8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: TextEdit.WordWrap
        text: question.text != "" ? question.text.arg(question.userEntry) : ""
    }
}
