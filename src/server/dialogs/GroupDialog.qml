/* GCompris - GroupDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import "../singletons"
import "../components"

Popup {
    id: groupDialog
    enum DialogType { Add, Modify, Remove }
    property string label
    property string subLabel: ""
    property bool textInputReadOnly: false
    property int mode: GroupDialog.DialogType.Modify
    // Database columns
    property int modelIndex: 0      // index in Master.groupModel
    property int group_Id: 0
    property string group_Name: ""
    property string group_Description: ""

    anchors.centerIn: Overlay.overlay
    width: dialogColumn.width + padding * 2
    height: dialogColumn.height + padding * 2
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8

    function openGroupDialog(index, group_name, group_id, group_description) {
        modelIndex = index
        group_Name = group_name
        group_Id = group_id
        group_Description = group_description
        open()
    }

    // Always force focus on the text input when displaying the popup
    onAboutToShow: {
        groupNameInput.text = group_Name
        groupDescriptionInput.text = group_Description
        groupNameInput.forceActiveFocus();
    }

    function saveGroup() {
        if (groupNameInput.text !== "") {
            switch (mode) {
            case GroupDialog.DialogType.Add:
                if (Master.createGroup(groupNameInput.text, groupDescriptionInput.text) !== -1)
                    groupDialog.close()
                break
            case GroupDialog.DialogType.Modify:
                if (Master.updateGroup(modelIndex, groupNameInput.text, groupDescriptionInput.text))
                    groupDialog.close()
                break
            case GroupDialog.DialogType.Remove:
                if (Master.deleteGroup(modelIndex))
                    groupDialog.close()
                break
            }
        } else {
            groupDialog.close()
        }
        Master.loadGroups()
        Master.loadUsers()
        Master.filterUsers(Master.filteredUserModel, false)
    }

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
    }

    Column {
        id: dialogColumn
        width: Math.max(750, bottomButtons.width)
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: Style.margins

        DefaultLabel {
            id: groupDialogText
            width: parent.width
            height: Style.mediumTextSize
            text: groupDialog.label
            fontSizeMode: Text.Fit
            font.bold: true
        }

        DefaultLabel {
            width: parent.width
            fontSizeMode: Text.Fit
            font.bold: true
            text: groupDialog.subLabel
        }

        Item {
            height: Style.margins
            width: 1
        }

        DefaultLabel {
            width: parent.width
            text: qsTr("Name")
            font.bold: true
        }

        UnderlinedTextInput {
            id: groupNameInput
            width: parent.width
            activeFocusOnTab: true
            readOnlyText: groupDialog.textInputReadOnly
        }

        DefaultLabel {
            width: parent.width
            text: qsTr("Description")
            font.bold: true
        }

        UnderlinedTextInput {
            id: groupDescriptionInput
            width: parent.width
            activeFocusOnTab: true
            readOnlyText: groupDialog.textInputReadOnly
        }

        OkCancelButtons {
            id: bottomButtons
            anchors.horizontalCenter: parent.horizontalCenter
            onCancelled: groupDialog.close()
            onValidated: groupDialog.saveGroup()
        }

        Keys.onReturnPressed: groupDialog.saveGroup()
        Keys.onEnterPressed: groupDialog.saveGroup()
        Keys.onEscapePressed: groupDialog.close()
    }
}
