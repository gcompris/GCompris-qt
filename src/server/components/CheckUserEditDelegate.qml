/* GCompris - CheckUserEditDelegate.qml
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
    id: checkUserEditDelegate
    font.pixelSize: Style.textSize
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: checkUserEditDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }

    SmallButton {
        id: editPupil
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        width: parent.height - 4
        height: parent.height - 4
        visible: checkUserEditDelegate.hovered || editPupil.hovered
        font.pixelSize: Style.textSize
        text: "\uf304"
        onClicked: modifyPupilDialog.openPupilDialog(index, user_name, user_id, user_password, groups_name, groups_id)
        ToolTip.visible: hovered
        ToolTip.text: qsTr("Edit pupil")
    }

    StyledCheckBox {
        id: checkButton
        anchors.fill: parent
        anchors.leftMargin: 15
        text: user_name
        checked: user_checked
        ButtonGroup.group: childGroup
        onClicked: {
            foldModel.setProperty(index, checkKey, checked)
            selectionClicked(foldModel.get(index)[indexKey], checked)
            currentChecked = index
        }
    }

    Text {
        anchors.right: parent.right
        width: parent.width / 2
        height: parent.height
        font.pixelSize: Style.textSize
        verticalAlignment: Text.AlignVCenter
        text: groups_name
        color: enabled ? Style.selectedPalette.text: "gray"
    }
}
