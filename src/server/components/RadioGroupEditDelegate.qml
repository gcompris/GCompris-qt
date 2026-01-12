/* GCompris - RadioGroupEditDelegate.qml
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
    id: radioGroupEditDelegate
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: radioGroupEditDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }

    StyledRadioButton {
        id: radioButton
        anchors.fill: parent
        anchors.leftMargin: Style.margins
        anchors.rightMargin: Style.margins
        hoverEnabled: true
        text: group_name
        checked: group_checked
        ButtonGroup.group: childGroup
        onCheckedChanged: {
            foldDown.foldModel.setProperty(index, checkKey, checked);
            if(checked) {
                foldDown.currentChecked = index;
                selectionClicked(foldDown.foldModel.get(index)[indexKey], checked);
            }
        }
    }

    Rectangle {
        visible: radioButton.hovered || deleteGroup.hovered || editGroup.hovered
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 2 * editGroup.width + Style.margins * 2.5
        height: editGroup.height
        color: Style.selectedPalette.base

        SmallButton {
            id: editGroup
            anchors.top: parent.top
            anchors.right: deleteGroup.left
            anchors.rightMargin: Style.smallMargins
            hoverEnabled: true
            icon.source: "qrc:/gcompris/src/server/resource/icons/edit.svg"
            onClicked: managePupilsView.editGroupDialog(index, group_name, group_id, group_description)
            toolTipOnHover: true
            toolTipText: qsTr("Edit group")
        }

        SmallButton {
            id: deleteGroup
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: Style.margins
            hoverEnabled: true
            icon.source: "qrc:/gcompris/src/server/resource/icons/delete.svg"
            onClicked: managePupilsView.removeGroupDialog(index, group_name, group_id, group_description)
            toolTipOnHover: true
            toolTipText: qsTr("Delete group")
        }

    }
}
