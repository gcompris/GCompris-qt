/* GCompris - RadioSequenceDelegate.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Control {
    id: radioSequenceDelegate
    font.pixelSize: Style.textSize
    hoverEnabled: true

    Rectangle {
        anchors.fill: parent
        color: radioSequenceDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }

    StyledRadioButton {
        id: aButton
        anchors.fill: parent
        anchors.leftMargin: 10
        text: sequence_name
        ButtonGroup.group: childGroup
        checked: sequence_checked
        onCheckedChanged: {
            foldDown.foldModel.setProperty(index, checkKey, checked);
            if(checked) {
                selectionClicked(foldDown.foldModel.get(index)[indexKey], checked);
            }
        }
    }
}
