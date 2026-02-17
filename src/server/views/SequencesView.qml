/* GCompris - SequencesView.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
    id: sequencesView
    width: parent.width
    height: parent.height
    enabled: serverRunning

    property int selectedSequence: -1

    StyledSplitView {
        id: splitSequenceView
        anchors.fill: parent

        property int minSplitWidth: width / 3
        property int bigButtonWidth: Math.min(minSplitWidth - Style.bigMargins, 4 * Style.bigControlSize)
        property int bigButtonHeight: Math.min(height / (buttonsColumn.children.length + 3) - Style.margins, Style.bigControlSize)
        property int preferredSplitWidth: bigButtonWidth + Style.bigMargins

        FoldDown { // Sequences list
            id: sequencePane
            SplitView.preferredWidth: splitSequenceView.preferredSplitWidth
            SplitView.minimumWidth: splitSequenceView.bigButtonWidth
            title: qsTr("Sequences")
            foldModel: Master.sequenceModel
            indexKey: "sequence_id"
            nameKey: "sequence_name"
            checkKey: "sequence_checked"
            delegateName: "radioSequence"
            filterVisible: true
            collapsable: false
            clickOnClear: true
            onSelectionClicked: (modelId) => {
                sequencesView.selectedSequence = modelId
            }
        }

        // TODO Not a foldDown, more a list of activities with details on the lines below
        FoldDown { // Activities with selected sequence names below
            id: activitiesPane
            SplitView.fillWidth: true
            SplitView.minimumWidth: splitSequenceView.minSplitWidth
            title: qsTr("Details")
            foldModel: Master.filteredDatasetModel // filteredSequenceModel
            indexKey: "dataset_id"
            nameKey: "dataset_name"
            checkKey: "dataset_checked"
            delegateName: "radio"
            filterVisible: false
            collapsable: false
            onSelectionClicked: (modelId) => {
                sequencesView.selectedSequence = modelId
            }
        }

        Item {
            id: managementColumn
            SplitView.preferredWidth: splitSequenceView.preferredSplitWidth
            SplitView.minimumWidth: splitSequenceView.bigButtonWidth
            SplitView.maximumWidth: splitSequenceView.preferredSplitWidth

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
                    text: qsTr("Sequences management")
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
                    width: splitSequenceView.bigButtonWidth
                    height: splitSequenceView.bigButtonHeight
                    icon.source: "qrc:/gcompris/src/server/resource/icons/plus.svg"
                    text: qsTr("Create sequence")
                    onClicked: sequenceEditor.openDataEditor(sequencesView.selectedSequence,
                                                            undefined)
                }

                ViewButton {
                    width: splitSequenceView.bigButtonWidth
                    height: splitSequenceView.bigButtonHeight
                    icon.source: "qrc:/gcompris/src/server/resource/icons/edit.svg"
                    text: qsTr("Update sequence")
                    enabled: sequencesView.selectedSequence != -1
                    onClicked: sequenceEditor.openDataEditor(sequencesView.selectedSequence)
                }

                ViewButton {
                    width: splitSequenceView.bigButtonWidth
                    height: splitSequenceView.bigButtonHeight
                    icon.source: "qrc:/gcompris/src/server/resource/icons/send-to.svg"
                    text: qsTr("Send sequence to clients")
                    enabled: sequencesView.selectedSequence != -1
                    onClicked: {
                        var sequence = Master.getSequence(sequencesView.selectedSequence)
                        var sequenceArray = []
                        // We merge all datasets for the same activities that
                        // follow in the same sequence (to avoid going back to
                        // the menu to reload the same activity in the client
                        // as it is done when using json file sequences)
                        var lastActivity = "";
                        for(var i = 0; i < sequence.sequenceList.count; ++ i) {
                            var elt = sequence.sequenceList.get(i)
                            if(lastActivity == elt.activity_name) {
                                sequenceArray[sequenceArray.length-1]["datasets"].push(elt.internal_name);
                            }
                            else {
                                sequenceArray.push({
                                    "activity": elt.activity_name,
                                    "datasets": [elt.internal_name],
                                });
                            }
                            lastActivity = elt.activity_name
                        }
                        var sequenceJson = {
                            "sequence": sequenceArray
                        }
                        sendSequenceDialog.openSequenceDialog(sequenceJson, SendSequenceDialog.MessageType.Send)
                    }
                }

                ViewButton { // Not sure if it makes sense, maybe "stop sequence" instead
                    width: splitSequenceView.bigButtonWidth
                    height: splitSequenceView.bigButtonHeight
                    icon.source: "qrc:/gcompris/src/server/resource/icons/remove-from.svg"
                    text: qsTr("Remove sequence from clients")
                    enabled: sequencesView.selectedSequence != -1
                    onClicked: {
                        var dataset = Master.getDataset(sequencesView.selectedDataset)
                        var datasetJson = {"dataset_id": dataset.dataset_id,
                            "activity_name": dataset.activity_name,
                            "dataset_name": dataset.dataset_name,
                        };
                        sendDatasetDialog.openDatasetDialog(datasetJson, SendDatasetDialog.MessageType.Remove)
                    }
                }
            }

            Column {
                anchors {
                    bottom: parent.bottom
                    margins: Style.bigMargins
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: Style.margins

                ViewButton {
                    width: splitSequenceView.bigButtonWidth
                    height: splitSequenceView.bigButtonHeight
                    icon.source: "qrc:/gcompris/src/server/resource/icons/minus.svg"
                    text: qsTr("Delete sequence")
                    enabled: sequencesView.selectedSequence != -1
                    onClicked: removeSequenceDialog.open()
                }
            }
        }

        SequenceEditorDialog {
            id: sequenceEditor
            addMode: true
            sequence_Name: ""
            sequence_Objective: ""
        }

        RemoveSequenceDialog {
            id: removeSequenceDialog
            onSequenceRemoved: {
                sequencesView.selectedSequence = -1;
            }
        }

        SendSequenceDialog {
            id: sendSequenceDialog
        }
    }

    Component.onCompleted: {
        splitSequenceView.restoreState(serverSettings.value("splitSequenceView"))
    }
    Component.onDestruction: serverSettings.setValue("splitSequenceView", splitSequenceView.saveState())
}
