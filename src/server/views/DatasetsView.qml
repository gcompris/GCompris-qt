/* GCompris - DatasetsView.qml
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
import QtQml.Models
import QtQuick.Controls.Basic

import "../singletons"
import "../components"
import "../dialogs"
import "../activities"
import "../panels"

Item {
    id: datasetsView
    width: parent.width
    height: parent.height
    enabled: serverRunning

    property int selectedActivity: -1
    property int selectedDataset: -1

    StyledSplitView {
        id: splitDatasetView
        anchors.fill: parent

        property int minSplitWidth: width / 3
        property int bigButtonWidth: Math.min(minSplitWidth - Style.bigMargins, 4 * Style.bigControlSize)
        property int bigButtonHeight: Math.min(height / (buttonsColumn.children.length + 3) - Style.margins, Style.bigControlSize)
        property int preferredSplitWidth: bigButtonWidth + Style.bigMargins

        Column {  // Activities list
            SplitView.preferredWidth: splitDatasetView.preferredSplitWidth
            SplitView.minimumWidth: splitDatasetView.bigButtonWidth
            height: parent.height

            FoldDown {
                id: activityPane
                width: parent.width
                height: parent.height
                title: qsTr("Activities")
                foldModel: Master.activityModel
                indexKey: "activity_id"
                nameKey: "activity_title"
                checkKey: "activity_checked"
                delegateName: "radio"
                filterVisible: true
                collapsable: false
                onSelectionClicked: (modelId) => {
                    datasetsView.selectedActivity = modelId
                    datasetsView.selectedDataset = -1
                    Master.filterDatasets(datasetsView.selectedActivity, false)
                }
            }
        }

        FoldDown { // Datasets lists
            id: datasetPane
            SplitView.fillWidth: true
            SplitView.minimumWidth: splitDatasetView.minSplitWidth
            title: qsTr("Datasets")
            foldModel: Master.filteredDatasetModel
            indexKey: "dataset_id"
            nameKey: "dataset_name"
            checkKey: "dataset_checked"
            delegateName: "radio"
            filterVisible: false
            collapsable: false
            onSelectionClicked: (modelId) => {
                datasetsView.selectedDataset = modelId
            }
        }

        Item {
            id: managementColumn
            SplitView.preferredWidth: splitDatasetView.preferredSplitWidth
            SplitView.minimumWidth: splitDatasetView.bigButtonWidth
            SplitView.maximumWidth: splitDatasetView.preferredSplitWidth

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
                    text: qsTr("Datasets management")
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
                    width: splitDatasetView.bigButtonWidth
                    height: splitDatasetView.bigButtonHeight
                    text: "\uf234 " + qsTr("Create dataset")
                    enabled: datasetsView.selectedActivity != -1
                    onClicked: datasetEditor.openDataEditor(datasetsView.selectedActivity, undefined)
                }

                ViewButton {
                    width: splitDatasetView.bigButtonWidth
                    height: splitDatasetView.bigButtonHeight
                    text: "\uf07c " + qsTr("Update dataset")
                    enabled: datasetsView.selectedDataset != -1
                    onClicked: datasetEditor.openDataEditor(datasetsView.selectedActivity, Master.getDataset(datasetsView.selectedDataset))
                }

                ViewButton {
                    width: splitDatasetView.bigButtonWidth
                    height: splitDatasetView.bigButtonHeight
                    text: "\uf2f6 " + qsTr("Send to clients")
                    enabled: datasetsView.selectedDataset != -1
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
                    width: splitDatasetView.bigButtonWidth
                    height: splitDatasetView.bigButtonHeight
                    text: "\uf506 " + qsTr("Remove from clients")
                    enabled: datasetsView.selectedDataset != -1
                    onClicked: {
                        var dataset = Master.getDataset(datasetsView.selectedDataset)
                        var datasetJson = {"dataset_id": dataset.dataset_id,
                            "activity_name": dataset.activity_name,
                            "dataset_name": dataset.dataset_name,
                        };
                        sendDatasetDialog.openDatasetDialog(datasetJson, false)
                    }
                }
            }

            ViewButton {
                width: splitDatasetView.bigButtonWidth
                height: splitDatasetView.bigButtonHeight
                anchors {
                    bottom: parent.bottom
                    margins: Style.bigMargins
                    horizontalCenter: parent.horizontalCenter
                }
                text: "\uf0c7 " + qsTr("Remove dataset")
                enabled: datasetsView.selectedDataset != -1
                onClicked: removeDatasetDialog.open()
            }
        }

        DatasetEditorDialog {
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
    }
    Component.onDestruction: serverSettings.setValue("splitDatasetView", splitDatasetView.saveState())
}
