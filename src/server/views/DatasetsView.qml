/* GCompris - DatasetsView.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Controls.Basic

import "../singletons"
import "../components"
import "../dialogs"
import "../activities"
import "../panels"

Item {
    id: datasetsView
    enabled: serverRunning

    property int selectedActivity: -1
    property int selectedDataset: -1

    SplitView {
        id: splitDatasetView
        anchors.margins: 3
        anchors.fill: parent

        ColumnLayout {  // Activities list
            SplitView.preferredWidth: 250
            SplitView.minimumWidth: 180

            FoldDownCheck {
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
                    datasetsView.selectedDataset = -1
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
                        text: qsTr("Datasets management")
                        color: enabled ? Style.selectedPalette.text: "gray"
                    }
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                    width: 200
                    text: "\uf234   " + qsTr("Create dataset")
                    enabled: datasetsView.selectedActivity != -1
                    onClicked: datasetEditor.openDataEditor(datasetsView.selectedActivity, undefined)
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    width: 200
                    text: "\uf07c   " + qsTr("Update dataset")
                    enabled: datasetsView.selectedDataset != -1
                    onClicked: datasetEditor.openDataEditor(datasetsView.selectedActivity, Master.getDataset(datasetsView.selectedDataset))
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    width: 200
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
                    width: 200
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

                Item {
                    Layout.preferredWidth: parent.width
                    Layout.fillHeight: true
                }

                ViewButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20
                    width: 200
                    text: "\uf0c7   " + qsTr("Remove dataset")
                    enabled: datasetsView.selectedDataset != -1
                    onClicked: removeDatasetDialog.open()
                }
            }
        }

        DatasetEditor {
            id: datasetEditor
            addMode: true
            dataset_Name: ""
            dataset_Objective: ""
            difficulty: 1
            dataset_Content: ""
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
    }

    Component.onCompleted: {
        splitDatasetView.restoreState(serverSettings.value("splitDatasetView"))
        // The two next lines force a filter on activityPane. Remove later. Save clicks while developing.
        // activityPane.foldDownFilter.text = "verticale"
        activityPane.foldDownFilter.text = "choice"
        activityPane.filterButton.checked = true
    }
    Component.onDestruction: serverSettings.setValue("splitDatasetView", splitDatasetView.saveState())
}
