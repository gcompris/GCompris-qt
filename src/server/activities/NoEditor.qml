/* GCompris - NoEditor.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.2

import "../singletons"
import "../components"

Text {
    text: "No editor for this activity.\nSwitch to Data editor"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    leftPadding: 50
    topPadding: 50
    color: Style.selectedPalette.text

    function updateDataFromEditor() { }     // Nothing to do when no activity editor is available
}
