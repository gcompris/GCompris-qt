/* GCompris - ViewButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

AbstractButton {
    id: button
    width: button.defaultWidth
    height: button.defaultHeight

    property int defaultWidth: Style.bigControlSize * 4
    property int defaultHeight: Style.bigControlSize

    opacity: enabled ? 1 : 0.5

    Row {
        id: buttonRow
        width: button.width - Style.bigMargins
        height: button.height - Style.margins
        anchors.centerIn: parent
        spacing: Style.tinyMargins

        Button {
            id: iconButton
            visible: icon.source != ""
            width: Style.controlSize
            height: width
            padding: 0
            enabled: false
            activeFocusOnTab: false
            icon.source: button.icon.source
            icon.color: textDescription.color
            icon.width: Style.controlSize
            icon.height: Style.controlSize
            anchors.verticalCenter: parent.verticalCenter

            background: Item {}
        }

        DefaultLabel {
            id: textDescription
            height: buttonRow.height
            width: buttonRow.width - (iconButton.visible ? iconButton.width + buttonRow.spacing : 0)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: button.enabled && (button.pressed || button.hovered) ?
                Style.selectedPalette.highlightedText :
                Style.selectedPalette.text
            font.pixelSize: Style.textSize
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            text: button.text
        }
    }

    background: Rectangle {
        width: button.width
        height: button.height
        radius: Style.defaultRadius
        color: button.pressed ? Style.selectedPalette.highlight :
            (button.enabled && button.hovered ? Style.selectedPalette.accent :
            Style.selectedPalette.alternateBase)
        border.color: button.enabled && (button.visualFocus || button.hovered) ?
            Style.selectedPalette.text : Style.selectedPalette.accent
        border.width: button.enabled && (button.visualFocus || button.hovered) ? 2 : 1
    }
}

