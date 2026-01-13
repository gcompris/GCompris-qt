/* GCompris - RadioSimpleDelegate.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Control {
    id: radioSimpleDelegate
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: radioSimpleDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }

    StyledRadioButton {
        id: aButton
        anchors.fill: parent
        anchors.leftMargin: Style.margins
        anchors.rightMargin: Style.margins
        text: eval(nameKey)         // In these cases, eval is safe because no code injection is possible
        checked: eval(checkKey)     // Eval's parameter is an internal column name
        ButtonGroup.group: childGroup
        onCheckedChanged: {
            foldDown.foldModel.setProperty(index, checkKey, checked);
            if(checked) {
                if(visible)
                    selectionClicked(foldDown.foldModel.get(index)[indexKey], checked);
            }
        }
    }
}
