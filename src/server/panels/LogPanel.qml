/* GCompris - LogPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Rectangle {
    id: logPanel

    function appendLog(mess) {
        messageLog.text += mess + "\n"
        messageLog.cursorPosition = messageLog.length
    }

    function clearLog() {
        messageLog.text = ""
    }

    color: Style.selectedPalette.base

    ScrollView {
        id: view
        anchors.fill: parent

        TextArea {
            id: messageLog
            anchors.margins: 3
            readOnly: true
            wrapMode: TextEdit.WordWrap
            font.pixelSize: Style.textSize
        }
    }
}
