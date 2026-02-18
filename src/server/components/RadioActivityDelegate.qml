/* GCompris - RadioActivityDelegate.qml
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
        anchors.rightMargin: has_editor ? editorIcon.width + Style.bigMargins : 0
        text : (Master.allActivities[activity_name] !== undefined) ? Master.allActivities[activity_name].title : ""
        ButtonGroup.group: childGroup
        checked: activity_checked
        onCheckedChanged: {
            foldDown.foldModel.setProperty(index, checkKey, checked);
            if(checked) {
                selectionClicked(foldDown.foldModel.get(index)[indexKey], checked);
            }
        }
    }

    IconHolder {
        id: editorIcon
        height: Style.iconSize
        width: Style.iconSize
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Style.margins
        visible: has_editor
        icon.source: "qrc:/gcompris/src/server/resource/icons/editor.svg"
    }
}
