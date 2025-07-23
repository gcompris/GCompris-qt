/* GCompris - TopPanel.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"
import "../components"

Rectangle {
    id: topPanel
    x: 0
    y: 0
    width: parent.width
    height: Style.bigControlSize
    color: Style.selectedPalette.alternateBase

    property string text

    DefaultLabel {
        anchors {
            left: parent.left
            right: parent.right
            margins: Style.margins
            verticalCenter: parent.verticalCenter
        }
        height: Style.bigTextSize
        color: Style.selectedPalette.text
        font.bold: true
        text: topPanel.text
    }
}

