/* GCompris - StyledTabButton.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic
import "../singletons"

TabButton {
    id: control
    contentItem: Row {
        spacing: control.spacing
        layoutDirection: Qt.LeftToRight

        Image {
            id: buttonIcon
            height: parent.height
            width: height
            source: control.icon.source
            visible: source != ""
        }

        DefaultLabel {
            id: buttonText
            width: control.width - buttonIcon.width
            fontSizeMode: Text.FixedSize
            font.pixelSize: Style.textSize
            text: control.text
            color: control.checked ? Style.selectedPalette.highlightedText : Style.selectedPalette.text
        }
    }
    background: Rectangle {
        color: (control.pressed || control.checked) ? Style.selectedPalette.highlight :
                (control.enabled && control.hovered ? Style.selectedPalette.accent :
                Style.selectedPalette.alternateBase)
        border.color: control.enabled && (control.visualFocus || control.hovered) ?
                Style.selectedPalette.text : Style.selectedPalette.accent
        border.width: control.enabled && (control.visualFocus || control.hovered) ? 2 : 1
        radius: Style.defaultRadius
    }
}
