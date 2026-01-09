/* GCompris - NavigationButton.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

AbstractButton {
    id: navigationButton
    checkable: true
    height: Style.bigControlSize
    width: isCollapsed ? Style.bigControlSize : buttonRow.width + Style.margins

    required property bool isCollapsed
    required property int panelWidth

    Rectangle {
        id: background
        width: navigationButton.panelWidth
        height: Style.bigControlSize
        color: navigationButton.checked ? Style.selectedPalette.highlight :
            (mouseArea.containsMouse ? Style.selectedPalette.accent : Style.selectedPalette.alternateBase)
        border.width: navigationButton.activeFocus ? Style.defaultBorderWidth : 0
        border.color: Style.selectedPalette.text
    }

    Row {
        id: buttonRow
        opacity: enabled ? 1 : 0.5
        width: childrenRect.width
        height: childrenRect.height
        spacing: Style.smallMargins

        Button {
            id: iconButton
            width: Style.bigControlSize
            height: Style.bigControlSize
            padding: 0
            activeFocusOnTab: false
            icon.source: navigationButton.icon.source
            icon.color: textDescription.color
            icon.width: Style.bigIconSize
            icon.height: Style.bigIconSize

            background: Item {}
        }

        DefaultLabel {
            id: textDescription
            height: Style.bigControlSize
            horizontalAlignment: Text.AlignLeft
            color: navigationButton.checked || mouseArea.containsMouse ?
                Style.selectedPalette.highlightedText :
                Style.selectedPalette.text
            font.pixelSize: Style.textSize
            fontSizeMode: Text.FixedSize
            text: navigationButton.text
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: background
        hoverEnabled: true
        onClicked: {
            navigationButton.clicked()
        }
    }
}
