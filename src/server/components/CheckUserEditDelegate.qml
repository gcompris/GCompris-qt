/* GCompris - CheckUserEditDelegate.qml
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
    id: checkUserEditDelegate
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: checkUserEditDelegate.hovered ? Style.selectedPalette.base : "transparent"
    }

    SmallButton {
        id: editPupil
        anchors.left: parent.left
        anchors.leftMargin: Style.margins
        hoverEnabled: true
        // visible: checkUserEditDelegate.hovered || editPupil.hovered // No reason to make it visible only on hover if there's always space for it...
        text: "\uf304"
        onClicked: modifyPupilDialog.openPupilDialog(index, user_name, user_id, user_password, groups_name, groups_id)
        toolTipOnHover: true
        toolTipText: qsTr("Edit pupil")
    }

    StyledCheckBox {
        id: checkButton
        anchors.left: editPupil.right
        anchors.leftMargin: Style.margins
        width: (parent.width - editPupil.width - 4 * Style.margins) * 0.5
        text: user_name
        checked: user_checked
        ButtonGroup.group: childGroup
        onClicked: {
            foldModel.setProperty(index, checkKey, checked)
            selectionClicked(foldModel.get(index)[indexKey], checked)
            currentChecked = index
        }
    }

    DefaultLabel {
        anchors.left: checkButton.right
        anchors.leftMargin: Style.margins
        anchors.verticalCenter: parent.verticalCenter
        width: checkButton.width
        horizontalAlignment: Text.AlignLeft
        text: groups_name
        opacity: enabled ? 1 : 0.5
    }
}
