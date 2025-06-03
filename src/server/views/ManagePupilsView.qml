/* GCompris - ManagePupilsView.qml
*
* SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
*
* Authors:
*   Emmanuel Charruau <echarruau@gmail.com>
*   Bruno Anselme <be.root@free.fr>
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

    SplitView {
        id: splitManagePupils
        anchors.margins: 3
        anchors.fill: parent

        ColumnLayout {  // Group list and Add button
            SplitView.preferredWidth: 200
            SplitView.minimumWidth: 180

            FoldDownRadio {
                id: groupPane
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: qsTr("Groups")
                foldModel: Master.groupModel
                lineHeight: Style.mediumLineHeight
                indexKey: "group_id"
                nameKey: "group_name"
                checkKey: "group_checked"
                collapsable: false
                delegateName: "radioGroupEdit"
                onSelectionClicked: (modelId) => {
                    Master.groupFilterId = modelId
                    Master.filterUsers(Master.filteredUserModel, false)
                }
            }

            // Add group button
            Rectangle {
                id: addGroupLabelRectangle
                color: "transparent"
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                ViewButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf067 " + qsTr("Add a group")
                    onClicked: addGroupDialog.open()
                }

                GroupDialog {
                    id: addGroupDialog
                    label: qsTr("Add a group")
                    mode: GroupDialog.DialogType.Add
                    group_Name: ""
                    group_Description: ""
                }
            }
        }

        FoldDownCheck { // Pupils lists
            id: pupilPane
            title: qsTr("Pupils and groups")
            foldModel: Master.filteredUserModel
            lineHeight: Style.mediumLineHeight
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            delegateName: "checkUserEdit"
            collapsable: false
            SplitView.fillWidth: true
            SplitView.minimumWidth: 300
        }

        Rectangle {
            id: buttonsColumn
            SplitView.preferredWidth: 210
            SplitView.minimumWidth: 210
            SplitView.maximumWidth: 300
            color: Style.selectedPalette.base

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.mediumLineHeight
                    color: Style.selectedPalette.base
                    radius: 5
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Style.textSize
                        font.bold: true
                        text: qsTr("Pupils management")
                        color: enabled ? Style.selectedPalette.text : "gray"
                    }
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    Layout.preferredWidth: 200
                    text: "\uf234   " + qsTr("Add pupil")
                    onClicked: addPupilDialog.open()
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf07c   " + qsTr("Add to groups")
                    onClicked: addPupilsToGroupsDialog.open()
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf0c7   " + qsTr("Remove from groups")
                    onClicked: removePupilsFromGroupsDialog.open()
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf0c7   " + qsTr("Export pupils")
                    onClicked: exportPupilsDialog.open()
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text:  "\uf235   " + qsTr("Import pupils")
                    onClicked: importPupilsDialog.open()
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf503   " + qsTr("Remove pupils")
                    onClicked: removePupilsDialog.open()
                }

                Rectangle {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height
                    color: "transparent"
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
