/* GCompris - RadioSimpleDelegate.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls.Basic

import "../singletons"

Control {
    id: radioSimpleDelegate
    font.pixelSize: Style.textSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: radioSimpleDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }

    StyledRadioButton {
        id: aButton
        anchors.fill: parent
        anchors.leftMargin: 10
        text: eval(nameKey)         // In these cases, eval is safe because no code injection is possible
        checked: eval(checkKey)     // Eval's parameter is an internal column name
        ButtonGroup.group: childGroup
        onClicked: {
            if(currentChecked !== -1) {
                foldModel.setProperty(currentChecked, checkKey, false);
            }
            foldModel.setProperty(index, checkKey, true);
            selectionClicked(foldModel.get(index)[indexKey], checked);
            currentChecked = index;
        }
    }
}
