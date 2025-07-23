/* GCompris - ManagePupilsView.qml
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

import "../components"
import "../singletons"
import "../dialogs"

Item {
    id: managePupilsView
    width: parent.width
    height: parent.height
    enabled: serverRunning

    signal pupilsNamesListSelected(var pupilsNamesList)

    GroupDialog {
        id: groupDialog
    }

    function addGroupDialog() {
        groupDialog.textInputReadOnly = false;
        groupDialog.label = qsTr("Add a group");
        groupDialog.subLabel = "";
        groupDialog.mode = GroupDialog.DialogType.Add;
        groupDialog.group_Name = "";
        groupDialog.group_Description = "";
        groupDialog.open();
    }

    function removeGroupDialog(index, group_name, group_id, group_description) {
        groupDialog.textInputReadOnly = true;
        groupDialog.label = qsTr("Are you sure you want to remove this group?");
        groupDialog.subLabel = qsTr("Pupils will not be removed.");
        groupDialog.mode = GroupDialog.DialogType.Remove;
        groupDialog.openGroupDialog(index, group_name, group_id, group_description);
    }

    function editGroupDialog(index, group_name, group_id, group_description) {
        groupDialog.textInputReadOnly = false;
        groupDialog.label = qsTr("Edit group");
        groupDialog.subLabel = "";
        groupDialog.mode = GroupDialog.DialogType.Modify;
        groupDialog.openGroupDialog(index, group_name, group_id, group_description);
    }

    PupilDialog {
        id: pupilDialog
    }

    function addPupilDialog() {
        pupilDialog.addMode = true;
        pupilDialog.user_Name = "";
        pupilDialog.user_Password = "";
        pupilDialog.groups_Name = "";
        pupilDialog.groups_Id = "";
        pupilDialog.label = qsTr("Add a pupil");
        pupilDialog.open();
    }

    function editPupilDialog(index, user_name, user_id, user_password, groups_name, groups_id) {
        pupilDialog.addMode = false;
        pupilDialog.label = qsTr("Edit pupil's name and groups");
        pupilDialog.openPupilDialog(index, user_name, user_id, user_password, groups_name, groups_id);
    }

    ExportPupilsDialog {
        id: exportPupilsDialog
    }

    ImportPupilsDialog {
        id: importPupilsDialog
    }

    RemovePupilsDialog {
        id: removePupilsDialog
    }

    PupilsToGroupsDialog {
        id: pupilsToGroupsDialog
    }

    function addPupilsToGroupsDialog() {
        pupilsToGroupsDialog.addMode = true;
        pupilsToGroupsDialog.open();
    }

    function removePupilsFromGroupsDialog() {
        pupilsToGroupsDialog.addMode = false;  // remove mode
        pupilsToGroupsDialog.open();
    }

    StyledSplitView {
        id: splitManagePupils
        anchors.fill: parent

        property int minSplitWidth: width / 3
        property int bigButtonWidth: Math.min(minSplitWidth - Style.bigMargins, 4 * Style.bigControlSize)
        property int bigButtonHeight: Math.min(height / (buttonsColumn.children.length + 1) - Style.margins, Style.bigControlSize)
        property int preferredSplitWidth: bigButtonWidth + Style.bigMargins

        Column {  // Group list and Add button
            SplitView.preferredWidth: splitManagePupils.preferredSplitWidth
            SplitView.minimumWidth: splitManagePupils.bigButtonWidth
            height: parent.height

            FoldDown {
                id: groupPane
                width: parent.width
                height: parent.height - addGroupButtonArea.height
                title: qsTr("Groups")
                foldModel: Master.groupModel
                indexKey: "group_id"
                nameKey: "group_name"
                checkKey: "group_checked"
                filterVisible: false
                collapsable: false
                delegateName: "radioGroupEdit"
                onSelectionClicked: (modelId) => {
                    Master.groupFilterId = modelId;
                    Master.filterUsers(Master.filteredUserModel, false);
                }
            }

            // Add group button
            Item {
                id: addGroupButtonArea
                width: parent.width
                height: addGroupButton.height + Style.bigMargins

                ViewButton {
                    id: addGroupButton
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    anchors.centerIn: parent
                    text: "\uf067 " + qsTr("Add a group")
                    onClicked: managePupilsView.addGroupDialog();
                }
            }
        }

        FoldDown { // Pupils lists
            id: pupilPane
            SplitView.fillWidth: true
            SplitView.minimumWidth: splitManagePupils.minSplitWidth
            title: qsTr("Pupils and groups")
            foldModel: Master.filteredUserModel
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            delegateName: "checkUserEdit"
            filterVisible: true
            collapsable: false
        }

        Item {
            id: managementColumn
            SplitView.preferredWidth: splitManagePupils.preferredSplitWidth
            SplitView.minimumWidth: splitManagePupils.bigButtonWidth
            SplitView.maximumWidth: splitManagePupils.preferredSplitWidth

            Rectangle {
                id: managementColumnTitle
                anchors.top: parent.top
                width: parent.width
                height: Style.lineHeight
                border.width: Style.defaultBorderWidth
                border.color: Style.selectedPalette.accent
                color: Style.selectedPalette.base

                DefaultLabel {
                    anchors.centerIn: parent
                    width: parent.width - Style.bigMargins
                    font.bold: true
                    text: qsTr("Pupils management")
                    color: enabled ? Style.selectedPalette.text : "gray"
                }
            }

            Column {
                id: buttonsColumn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: managementColumnTitle.bottom
                anchors.topMargin: Style.margins
                height: childrenRect.height
                width: childrenRect.width
                spacing: Style.margins

                ViewButton {
                    id: addPupilButton
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    text: "\uf234   " + qsTr("Add a pupil")
                    onClicked: managePupilsView.addPupilDialog()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    enabled: pupilPane.childGroup.checkState != Qt.Unchecked // disable if nothing selected
                    text: "\uf07c   " + qsTr("Add to groups")
                    onClicked: managePupilsView.addPupilsToGroupsDialog()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    enabled: pupilPane.childGroup.checkState != Qt.Unchecked // disable if nothing selected
                    text: "\uf0c7   " + qsTr("Remove from groups")
                    onClicked: managePupilsView.removePupilsFromGroupsDialog()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    enabled: pupilPane.childGroup.checkState != Qt.Unchecked // disable if nothing selected
                    text: "\uf0c7   " + qsTr("Export pupils")
                    onClicked: exportPupilsDialog.open()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    text:  "\uf235   " + qsTr("Import pupils")
                    onClicked: importPupilsDialog.open()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    enabled: pupilPane.childGroup.checkState != Qt.Unchecked // disable if nothing selected
                    text: "\uf503   " + qsTr("Remove pupils")
                    onClicked: removePupilsDialog.open()
                }
            }
        }
    }

    Component.onCompleted: splitManagePupils.restoreState(serverSettings.value("splitManagePupils"))
    Component.onDestruction: serverSettings.setValue("splitManagePupils", splitManagePupils.saveState())
}
