/* GCompris - StyledRadioButton.qml
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

AbstractButton {
    id: control
    height: Style.controlSize
    implicitWidth: label.implicitWidth + controlImage.width + Style.margins
    opacity: enabled ? 1 : 0.5
    checkable: true

    Row {
        id: controlRow
        height: Style.textSize
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
            id: controlImage
            height: 2 * Math.round(Style.textSize * 0.5)
            width: height
            radius: width
            color: control.down ? Style.selectedPalette.accent : "transparent"
            border.width: control.visualFocus ? 3 : 2
            border.color: control.visualFocus ? Style.selectedPalette.highlight :
                                                Style.selectedPalette.text

            Rectangle {
                anchors.centerIn: parent
                width: controlImage.width - 8
                height: width
                radius: width
                color: Style.selectedPalette.text
                visible: control.checked
            }
        }

        DefaultLabel {
            id: label
            leftPadding: Style.margins
            rightPadding: Style.margins
            width: control.width - controlImage.width - Style.margins
            horizontalAlignment: Text.AlignLeft
            fontSizeMode: Text.FixedSize
            font.pixelSize: Style.textSize
            text: control.text
        }
    }
}
