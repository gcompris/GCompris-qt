/* GCompris - ResultIndicator.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

import "../singletons"

Rectangle {
    id: resultIndicator
    anchors.verticalCenter: parent.verticalCenter
    height: Style.lineHeight - Style.margins
    width: height
    radius: height
    border.width: Style.defaultBorderWidth
    border.color: Style.selectedPalette.text
    color: "transparent"

    required property bool resultSuccess

    Text {
        anchors.fill: parent
        anchors.margins: Style.smallMargins
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        color: Style.selectedPalette.text
        text: resultSuccess ? "\uf00c" : "\uf00d"
    }
}
