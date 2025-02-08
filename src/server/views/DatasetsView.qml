/* GCompris - DatasetsView.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Basic

import "../singletons"
import "../components"
import "../dialogs"

Item {
    id: datasetsView
    enabled: serverRunning

    property int selectedActivity: -1
    property int selectedDataset: -1
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
                id: activityPane
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: qsTr("Activities")
                foldModel: Master.activityModel
                lineHeight: Style.mediumLineHeight
                indexKey: "activity_id"
                nameKey: "activity_title"
                checkKey: "activity_checked"
                delegateName: "radio"
                onSelectionClicked: (modelId) => {
                    datasetsView.selectedActivity = modelId
                    datasetsView.selectedDataset = -1;
                    Master.filterDatasets(datasetsView.selectedActivity, false)
                }
            }
        }

        FoldDownRadio { // Datasets lists
            id: pupilPane
            title: qsTr("Datasets")
            foldModel: Master.filteredDatasetModel
            lineHeight: Style.mediumLineHeight
            indexKey: "dataset_id"
            nameKey: "dataset_name"
            checkKey: "dataset_checked"
            delegateName: "radio"
            collapsable: false
            SplitView.fillWidth: true
            SplitView.minimumWidth: 300
            onSelectionClicked: (modelId) => {
                datasetsView.selectedDataset = modelId
            }
        }

        Rectangle {
            id: buttonsColumn
            SplitView.preferredWidth: 210
            SplitView.minimumWidth: 210
            SplitView.maximumWidth: 300
            color: Style.colorBackground

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.mediumLineHeight
                    color: Style.colorHeaderPane
                    radius: 5
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Style.defaultPixelSize
                        font.bold: true
                        text: qsTr("Datasets management")
                        color: enabled ? "black": "gray"
                    }
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    Layout.preferredWidth: 200
                    text: "\uf234   " + qsTr("Create dataset")
                    enabled: datasetsView.selectedActivity != -1
                    onClicked: addDatasetDialog.openDatasetDialog(datasetsView.selectedActivity, undefined)
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf07c   " + qsTr("Update dataset")
                    enabled: datasetsView.selectedDataset != -1
                    onClicked: addDatasetDialog.openDatasetDialog(datasetsView.selectedActivity, Master.getDataset(datasetsView.selectedDataset))
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf0c7   " + qsTr("Remove dataset")
                    enabled: datasetsView.selectedDataset != -1
                    onClicked: removeDatasetDialog.open()
                }

                /*ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf0c7   " + qsTr("Export datasets")
                    onClicked: exportPupilsDialog.open()
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text:  "\uf235   " + qsTr("Import datasets")
                    onClicked: importPupilsDialog.open()
                }*/

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf2f6   " + qsTr("Send to clients")
                    onClicked: {
                        var dataset = Master.getDataset(datasetsView.selectedDataset)
                        var datasetJson = {"dataset_id": dataset.dataset_id,
                            "activity_id": dataset.activity_id,
                            "activity_name": dataset.activity_name,
                            "dataset_name": dataset.dataset_name,
                            "dataset_objective": dataset.dataset_objective,
                            "dataset_difficulty": dataset.dataset_difficulty,
                            "dataset_content": dataset.dataset_content};
                        sendDatasetDialog.openDatasetDialog(datasetJson, true)
                    }
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: "\uf506   " + qsTr("Remove on clients")
                    onClicked: {
                        var dataset = Master.getDataset(datasetsView.selectedDataset)
                        var datasetJson = {"dataset_id": dataset.dataset_id,
                            "activity_name": dataset.activity_name,
                            "dataset_name": dataset.dataset_name,
                        };
                        sendDatasetDialog.openDatasetDialog(datasetJson, false)
                    }
                }


                Rectangle {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height
                    color: "transparent"
                }
            }
        }

        DatasetDialog {
            id: addDatasetDialog
            addMode: true
            dataset_Name: ""
            dataset_Objective: ""
            difficulty: 1
            dataset_Content: ""
            label: qsTr("Create dataset")
        }

        ExportPupilsDialog {
            id: exportPupilsDialog
        }

        ImportPupilsDialog {
            id: importPupilsDialog
        }

        RemoveDatasetDialog {
            id: removeDatasetDialog
            onDatasetRemoved: {
                datasetsView.selectedDataset = -1;
            }
        }

        SendDatasetDialog {
            id: sendDatasetDialog
        }

        PupilsToGroupsDialog {
            id: addPupilsToGroupsDialog
        }

        PupilsToGroupsDialog {
            id: removePupilsFromGroupsDialog
            addMode: false     // remove mode
        }
    }

    //Component.onCompleted: splitManagePupils.restoreState(serverSettings.value("splitManagePupils"))
    //Component.onDestruction: serverSettings.setValue("splitManagePupils", splitManagePupils.saveState())
}
