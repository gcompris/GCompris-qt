/* GCompris - RadioGroupEditDelegate.qml
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

Control {
    id: lineBox
    font.pixelSize: Style.defaultPixelSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: lineBox.hovered ? Style.colorHeaderPane : "transparent"
    }

    RadioButton {
        id: radioButton
        anchors.fill: parent
        anchors.leftMargin: 10
        hoverEnabled: true
        text: group_name
        checked: group_checked
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

    SmallButton {
        id: editGroup
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        width: parent.height - 4
        height: parent.height - 4
        visible: radioButton.hovered || deleteGroup.hovered || editGroup.hovered
        font.pixelSize: Style.defaultPixelSize
        text: "\uf304"
        onClicked: modifyGroupDialog.openGroupDialog(index, group_name, group_id, group_description)
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Edit group")
    }

    SmallButton {
        id: deleteGroup
        anchors.left: editGroup.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        width: parent.height - 4
        height: parent.height - 4
        visible: radioButton.hovered || deleteGroup.hovered || editGroup.hovered
        font.pixelSize: Style.defaultPixelSize
        text: "\uf1f8"
        onClicked: removeGroupDialog.openGroupDialog(index, group_name, group_id, group_description)
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Delete group")
    }
}
