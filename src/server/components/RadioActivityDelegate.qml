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

import "../singletons"

// Need to pick up the activity's title in allActivities

Control {
    id: radioActivityDelegate
    font.pixelSize: Style.textSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: radioActivityDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }
    StyledRadioButton {
        id: aButton
        anchors.fill: parent
        anchors.leftMargin: 10
        text : (Master.allActivities[activity_name] !== undefined) ? Master.allActivities[activity_name].title : ""
        checked: activity_checked
        ButtonGroup.group: childGroup
        indicator.scale: Style.checkerScale
        onClicked: {
            foldModel.setProperty(index, checkKey, checked)
            selectionClicked( foldModel.get(index)[indexKey], checked)
            currentChecked = index
        }
    }
}
