/* GCompris - CheckSimpleDelegate.qml
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

Control {
    id: checkSimpleDelegate
    font.pixelSize: Style.textSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: checkSimpleDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }
    StyledCheckBox {
        id: checkBox
        anchors.fill: parent
        anchors.leftMargin: 10
        text: eval(nameKey)         // In these cases, eval is safe because no code injection is possible
        checked: eval(checkKey)     // Eval's parameter is an internal column name
        ButtonGroup.group: childGroup
        onCheckedChanged: {
            foldModel.setProperty(index, checkKey, checked);
        }
        onClicked: {
            selectionClicked(foldModel.get(index)[indexKey], checked);
        }
    }
}
