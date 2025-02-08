/* GCompris - CheckActivityDelegate.qml
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
    id: checkActivityDelegate
    font.pixelSize: Style.defaultPixelSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: checkActivityDelegate.hovered ? Style.colorHeaderPane : "transparent"
    }
    CheckBox {
        anchors.fill: parent
        anchors.leftMargin: 10
        text : (Master.allActivities[activity_name] !== undefined) ? Master.allActivities[activity_name].title : ""
        checked: activity_checked
        ButtonGroup.group: childGroup
        indicator.scale: Style.checkerScale
        onClicked: {
            foldModel.setProperty(index, checkKey, checked)
            selectionClicked(foldModel.get(index)[indexKey], checked)
            //                currentChecked = index
        }
    }
}
