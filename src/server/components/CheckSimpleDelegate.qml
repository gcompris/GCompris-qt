/* GCompris - CheckSimpleDelegate.qml
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
    id: checkSimpleDelegate
    font.pixelSize: Style.defaultPixelSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: checkSimpleDelegate.hovered ? Style.colorHeaderPane : "transparent"
    }
    CheckBox {
        id: checkBox
        anchors.fill: parent
        anchors.leftMargin: 10
        text: eval(nameKey)         // In these cases, eval is safe because no code injection is possible
        checked: eval(checkKey)     // Eval's parameter is an internal column name
        ButtonGroup.group: childGroup
        indicator.scale: Style.checkerScale
        onClicked: {
            currentChecked = index
            foldModel.setProperty(index, checkKey, checked)
            selectionClicked(foldModel.get(index)[indexKey], checked)
        }
    }
}
