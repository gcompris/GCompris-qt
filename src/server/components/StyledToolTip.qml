/* GCompris - StyledToolTip.qml
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

ToolTip {
    id: control

    contentItem: Text {
        text: control.text
        font: control.font
        wrapMode: Text.Wrap
        color: Style.selectedPalette.highlightedText
    }

    background: Rectangle {
        border.width: Style.defaultBorderWidth
        border.color: Style.selectedPalette.accent
        color: Style.selectedPalette.accent
    }
}
