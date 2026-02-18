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

    property bool fixedWidth: false
    width: fixedWidth ? 100 : implicitWidth // 100 is a default value, set the target width if you set fixedWidth true
    height: Style.lineHeight
    padding: Style.margins

    contentItem: Row {
        id: contentRow
        anchors.centerIn: parent
        height: Style.textSize
        spacing: control.spacing
        layoutDirection: Qt.LeftToRight

        IconHolder {
            id: buttonIcon
            height: Style.iconSize
            width: Style.iconSize
            anchors.verticalCenter: parent.verticalCenter
            icon.source: control.icon.source
            icon.color: buttonText.color
            visible: icon.source != ""
        }

        DefaultLabel {
            id: buttonText
            width: control.fixedWidth ? (control.width - buttonIcon.width - contentRow.spacing) : implicitWidth
            fontSizeMode: Text.FixedSize
            font.pixelSize: Style.textSize
            text: control.text
            color: control.checked || control.hovered ? Style.selectedPalette.highlightedText :
                    Style.selectedPalette.text
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
