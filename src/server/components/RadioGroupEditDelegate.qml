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
        onClicked: {
            if (currentChecked !== -1)
                foldModel.setProperty(currentChecked, checkKey, false)
            foldModel.setProperty(index, checkKey, true)
            selectionClicked(foldModel.get(index)[indexKey], checked)
            currentChecked = index
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
            text: "\uf304"
            onClicked: modifyGroupDialog.openGroupDialog(index, group_name, group_id, group_description)
            toolTipOnHover: true
            toolTipText: qsTr("Edit group")
        }

        SmallButton {
            id: deleteGroup
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: Style.margins
            hoverEnabled: true
            text: "\uf1f8"
            onClicked: removeGroupDialog.openGroupDialog(index, group_name, group_id, group_description)
            toolTipOnHover: true
            toolTipText: qsTr("Delete group")
        }

    }
}
