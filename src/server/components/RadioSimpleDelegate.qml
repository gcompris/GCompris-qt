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
import QtQuick.Layouts 1.15
import "../singletons"

Component {
    id: radioSimpleDelegate
    Control {
        id: lineBox
        font.pixelSize: Style.defaultPixelSize
        hoverEnabled: true
        Rectangle {
            anchors.fill: parent
            color: lineBox.hovered ? Style.colorHeaderPane : "transparent"
        }

        RadioButton {
            id: aButton
            anchors.fill: parent
            anchors.leftMargin: 10
            text: eval(nameKey)         // In these cases, eval is safe because no code injection is possible
            checked: eval(checkKey)     // Eval's parameter is an internal column name
            ButtonGroup.group: childGroup
            indicator.scale: Style.checkerScale
            onClicked: {
                if (currentChecked !== -1)
                    foldModel.setProperty(currentChecked, checkKey, false)
                foldModel.setProperty(index, checkKey, true)
                selectionClicked(foldModel.get(index)[indexKey])
                currentChecked = index
            }
        }
    }
}
