/* GCompris - StyledSpinBox.qml
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

SpinBox {
    id: control
    height: Style.controlSize

    opacity: enabled ? 1 : 0.5

    contentItem: TextInput {
        z: 2
        text: control.displayText
        clip: width < implicitWidth
        padding: 6

        font: control.font
        color: Style.selectedPalette.text
        selectionColor: Style.selectedPalette.highlight
        selectedTextColor: Style.selectedPalette.highlightedText
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints

        Rectangle {
            z: -1
            y: Style.defaultBorderWidth
            width: parent.width
            height: parent.height - 2 * Style.defaultBorderWidth
            color: Style.selectedPalette.alternateBase
        }
    }

    up.indicator: Rectangle {
        x: control.mirrored ? 0 : control.width - width
        height: control.height
        implicitWidth: height
        implicitHeight: height
        color: control.up.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.alternateBase
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
        opacity: enabled ? 1 : 0.5

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 3
            height: 2
            color: control.up.pressed ? Style.selectedPalette.highlightedText : Style.selectedPalette.text
        }
        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 2
            height: parent.width / 3
            color: control.up.pressed ? Style.selectedPalette.highlightedText : Style.selectedPalette.text
        }
    }

    down.indicator: Rectangle {
        x: control.mirrored ? parent.width - width : 0
        height: control.height
        implicitWidth: height
        implicitHeight: height
        color: control.down.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.alternateBase
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
        opacity: enabled ? 1 : 0.5

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 3
            height: 2
            color: control.down.pressed ? Style.selectedPalette.highlightedText : Style.selectedPalette.text
        }
    }

    background: Rectangle {
        implicitWidth: 140
        color: "transparent"
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }
}
