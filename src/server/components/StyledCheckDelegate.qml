/* GCompris - StyledCheckDelegate.qml
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

CheckBox {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset

    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    indicator: Rectangle {
        implicitWidth: 28
        implicitHeight: 28

        scale: 0.5

        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2

        color: control.down ? Style.selectedPalette.accent : Style.selectedPalette.base
        border.width: control.visualFocus ? 6 : 4
        border.color: control.visualFocus ? Style.selectedPalette.highlight :
                                            Style.selectedPalette.text

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: width
            color: Style.selectedPalette.text
            visible: control.checkState === Qt.Checked
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.5
            height: parent.height * 0.2
            color: Style.selectedPalette.text
            visible: control.checkState === Qt.PartiallyChecked
        }
    }

    contentItem: DefaultLabel {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0
        horizontalAlignment: Text.AlignLeft
        fontSizeMode: Text.FixedSize
        font.pixelSize: Style.textSize
        text: control.text
    }
}

