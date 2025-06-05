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
import QtQuick.Layouts
import QtQuick.Controls.Basic

import "../components"
import "../singletons"
import "../dialogs"

Item {
    id: managePupilsView
    enabled: serverRunning

    signal pupilsNamesListSelected(var pupilsNamesList)

    GroupDialog {
        id: addGroupDialog
        label: qsTr("Add a group")
        mode: GroupDialog.DialogType.Add
        group_Name: ""
        group_Description: ""
    }

    GroupDialog {
        id: removeGroupDialog
        textInputReadOnly: true
        label: qsTr("Are you sure you want to remove this group ?\n Pupils will not be removed.")
        mode: GroupDialog.DialogType.Remove
    }

    PupilDialog {
        id: modifyPupilDialog
        label: qsTr("Modify pupil name and groups")
        addMode: false
    }

    GroupDialog {
        id: modifyGroupDialog
        label: qsTr("Modify Group Name")
        mode: GroupDialog.DialogType.Modify
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

            FoldDownRadio {
                id: groupPane
                width: parent.width
                height: parent.height - addGroupButtonArea.height
                title: qsTr("Groups")
                foldModel: Master.groupModel
                indexKey: "group_id"
                nameKey: "group_name"
                checkKey: "group_checked"
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
                    onClicked: addGroupDialog.open();
                }
            }
        }

        FoldDownCheck { // Pupils lists
            id: pupilPane
            SplitView.fillWidth: true
            title: qsTr("Pupils and groups")
            foldModel: Master.filteredUserModel
            lineHeight: Style.mediumLineHeight
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            delegateName: "checkUserEdit"
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
                    text: "\uf234   " + qsTr("Add pupil")
                    onClicked: addPupilDialog.open()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    text: "\uf07c   " + qsTr("Add to groups")
                    onClicked: addPupilsToGroupsDialog.open()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
                    text: "\uf0c7   " + qsTr("Remove from groups")
                    onClicked: removePupilsFromGroupsDialog.open()
                }

                ViewButton {
                    width: splitManagePupils.bigButtonWidth
                    height: splitManagePupils.bigButtonHeight
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
                    text: "\uf503   " + qsTr("Remove pupils")
                    onClicked: removePupilsDialog.open()
                }
            }
        }

        PupilDialog {
            id: addPupilDialog
            addMode: true
            user_Name: ""
            user_Password: ""
            groups_Name: ""
            groups_Id: ""
            label: qsTr("Add pupil name and its group(s)")
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
            id: addPupilsToGroupsDialog
        }

        PupilsToGroupsDialog {
            id: removePupilsFromGroupsDialog
            addMode: false     // remove mode
        }
    }

    Component.onCompleted: splitManagePupils.restoreState(serverSettings.value("splitManagePupils"))
    Component.onDestruction: serverSettings.setValue("splitManagePupils", splitManagePupils.saveState())
}
