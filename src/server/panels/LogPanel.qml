/* GCompris - LogPanel.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Item {
    id: logPanel

    function appendLog(mess) {
        messageLog.text += mess + "\n"
        messageLog.cursorPosition = messageLog.length
    }

    function clearLog() {
        messageLog.text = ""
    }

    ScrollView {
        id: view
        anchors.fill: parent

        TextArea {
            id: messageLog
            anchors.margins: Style.margins
            readOnly: true
            wrapMode: TextEdit.WordWrap
            font.pixelSize: Style.textSize
            color: Style.selectedPalette.text
            selectionColor: Style.selectedPalette.highlight
            selectedTextColor: Style.selectedPalette.highlightedText
        }
    }
}
