/* GCompris - ViewButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Button {
    id: button
    width: 180
    height: Style.bigControlSize
    opacity: enabled ? 1 : 0.5
    contentItem: Text {
        anchors.fill: button
        anchors.margins: Style.margins
        text: button.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        color: button.enabled && (button.pressed || button.hovered) ?
            Style.selectedPalette.highlightedText :
            Style.selectedPalette.text
    }

    background: Rectangle {
        implicitWidth: button.width
        implicitHeight: button.height
        radius: 5
        color: button.pressed ? Style.selectedPalette.highlight :
            (button.enabled && button.hovered ? Style.selectedPalette.accent :
            Style.selectedPalette.alternateBase)
        border.color: button.enabled && (button.visualFocus || button.hovered) ?
            Style.selectedPalette.text : Style.selectedPalette.accent
        border.width: button.enabled && (button.visualFocus || button.hovered) ? 2 : 1
    }
}

