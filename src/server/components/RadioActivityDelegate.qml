/* GCompris - RadioActivityDelegate.qml
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

Component {     // Need to pick up the activity's title in allActivities
    id: radioActivityDelegate
    Control {
        id: lineBox
        font.pixelSize: Style.defaultPixelSize
        hoverEnabled: true
        Rectangle {
            anchors.fill: parent
            color: lineBox.hovered ? Style.colorHeaderPane : "transparent"
        }
        RadioButton {
            anchors.fill: parent
            anchors.leftMargin: 10
            text : (Master.allActivities[activity_name] !== undefined) ? Master.allActivities[activity_name].title : ""
            checked: activity_checked
            ButtonGroup.group: childGroup
            onClicked: {
                foldModel.setProperty(index, checkKey, checked)
                selectionClicked( foldModel.get(index)[indexKey])
                currentChecked = index
            }
        }
    }
}
