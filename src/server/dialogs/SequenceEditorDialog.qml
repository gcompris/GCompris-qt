/* GCompris - SequenceEditorDialog.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

import core 1.0
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic

import "../singletons"
import "../components"

Popup {
    id: sequenceEditor
    property string label
    property bool textInputReadOnly: false
    property bool addMode: true     // modify mode when false
    // Database columns
    property int modelIndex: 0      // index in Master.sequenceModel
    property int sequence_Id: 0
    property string sequence_Name: ""
    property alias sequence_Objective: sequenceObjective.text
    property var currentSequence: null

    parent: Overlay.overlay
    width: Overlay.overlay.width
    height: Overlay.overlay.height
    modal: true
    closePolicy: Popup.NoAutoClose

    function openDataEditor(selectedSequence) {
        currentSequence = Master.findObjectInModel(Master.sequenceModel, function(item) { return item.sequence_id === selectedSequence })

        sequenceModel.clear()
        splitDatasetView.resetState()
        if (!currentSequence) {
            label = qsTr("Create sequence")
            addMode = true
            sequenceName.text = ""
            sequence_Objective = ""
        }
        else {
            label = qsTr("Update sequence")
            addMode = false
            sequence_Id = currentSequence.sequence_id
            sequenceName.text = currentSequence.sequence_name
            sequence_Objective = currentSequence.sequence_objective
            print(JSON.stringify(currentSequence));
            for (var i = 0; i < currentSequence.sequenceList.count; ++ i) {
                var s = currentSequence.sequenceList.get(i)
                var act = Master.findObjectInModel(Master.activityModel, function(item) { return item.activity_id === s.activity_id })
                sequenceModel.append({
                    "activity_id": s.activity_id,
                    "activity_name": s.activity_name,
                    "activity_title": act.activity_title,
                    "dataset_id": s.dataset_id,
                    "dataset_name": s.dataset_name,
                    "internal_name": s.internal_name
                })
            }
        }

        open()
    }

    function saveSequence() {
        if (sequenceName.text === "") {
            errorDialog.message = [ qsTr("Sequence name is empty") ]
            errorDialog.open()
            return
        }

        var sequenceList = [];
        for(var i = 0; i < sequenceModel.count; ++ i) {
            var elt = sequenceModel.get(i)
            sequenceList.push({
                "activity_id": elt.activity_id,
                "activity_name": elt.activity_name,
                "dataset_id": elt.dataset_id,
                "dataset_name": elt.dataset_name,
                "internal_name": elt.internal_name,
            })
        }

        if (addMode) {
            // Add the sequence to database
            sequence_Id = Master.createSequence(sequenceName.text, sequenceObjective.text, sequenceList)
            if (sequence_Id !== -1)
                sequenceEditor.close()
        } else {
            if (Master.updateSequence(sequence_Id, sequenceName.text, sequenceObjective.text, sequenceList))
                sequenceEditor.close();
        }
    }

    onOpened: {
        sequenceName.forceActiveFocus();
    }

    background: Rectangle {
        color: Style.selectedPalette.base
    }

    Column {
        id: mainColumn
        width: parent.width
        spacing: Style.smallMargins

        Item {
            width: parent.width
            height: Style.lineHeight

            DefaultLabel {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Style.margins
                    verticalCenter: parent.verticalCenter
                }
                height: Style.textSize
                color: Style.selectedPalette.text
                font.bold: true
                text: sequenceEditor.label
            }
        }

        Item {
            width: parent.width
            height: infoContentColumn.height

            Column {
                id: infoLabelColumn
                spacing: Style.smallMargins

                property int maxWidth: mainColumn.width * 0.3

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width
                    anchors.right: parent.right

                    DefaultLabel {
                        width: Math.min(implicitWidth, infoLabelColumn.maxWidth)
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Sequence name")
                        font.bold: true
                    }
                }

                Item {
                    height: Style.lineHeight
                    width: childrenRect.width
                    anchors.right: parent.right

                    DefaultLabel {
                        width: Math.min(implicitWidth, infoLabelColumn.maxWidth)
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Goal")
                        font.bold: true
                    }
                }
            }

            Column {
                id: infoContentColumn

                anchors {
                    left: infoLabelColumn.right
                    right: parent.right
                    leftMargin: Style.margins
                }
                spacing: Style.smallMargins

                UnderlinedTextInput {
                    id: sequenceName
                    width: parent.width
                    activeFocusOnTab: true
                    focus: true
                    defaultText: ""
                    // Prevent specific characters in the filename and only 40 characters max:
                    // <, :, ", /, >, |, ?, *, \, ', [, ], + 
                    validator: RegularExpressionValidator { regularExpression: /^[^<:"\/>|?\*\\'\[\]\+]{0,40}/ }
                }

                UnderlinedTextInput {
                    id: sequenceObjective
                    width: parent.width
                    activeFocusOnTab: true
                    focus: true
                    defaultText: ""
                }
            }
        }
    }

    StyledSplitView {
        id: splitDatasetView
        anchors.top: mainColumn.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: okButtons.top
        anchors.topMargin: Style.margins
        anchors.bottomMargin: Style.margins

        property int minSplitWidth: width / 3
        property int bigButtonWidth: Math.min(minSplitWidth - Style.bigMargins, 4 * Style.bigControlSize)
        property int bigButtonHeight: Math.min(height / (buttonsColumn.children.length + 3) - Style.margins, Style.bigControlSize)
        property int preferredSplitWidth: bigButtonWidth + Style.bigMargins

        property int selectedActivity: -1
        property int selectedDataset: -1
        property string selectedActivityTitle: ""
        property string selectedActivityName: ""
        property string selectedDatasetName: ""
        property string selectedInternalDatasetName: ""

        function resetState() {
            activityPane.clearSelection()
            datasetPane.clearSelection()
        }

        FoldDown { // Activities list
            id: activityPane
            SplitView.preferredWidth: splitDatasetView.preferredSplitWidth
            SplitView.minimumWidth: splitDatasetView.bigButtonWidth
            title: qsTr("Activities")
            foldModel: Master.activityModel
            indexKey: "activity_id"
            nameKey: "activity_title"
            checkKey: "activity_checked"
            delegateName: "radioActivity"
            filterVisible: true
            collapsable: false
            clickOnClear: true
            onSelectionClicked: (modelId) => {
                var act = Master.findObjectInModel(Master.activityModel, function(item) { return item.activity_id === modelId })
                if(act) {
                    splitDatasetView.selectedActivity = act.activity_id
                    splitDatasetView.selectedActivityName = act.activity_name
                    splitDatasetView.selectedActivityTitle = act.activity_title
                }
                else {
                    splitDatasetView.selectedActivity = -1
                }
                Master.filterDatasets(splitDatasetView.selectedActivity, false)
                splitDatasetView.selectedDataset = -1
            }
        }

        FoldDown { // Datasets lists
            id: datasetPane
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
                var act = Master.findObjectInModel(Master.filteredDatasetModel, function(item) { return item.dataset_id === modelId })
                if(act) {
                    splitDatasetView.selectedDataset = act.dataset_id
                    splitDatasetView.selectedDatasetName = act.dataset_name
                    splitDatasetView.selectedInternalDatasetName = act.internal_name
                }
                else {
                    splitDatasetView.selectedDataset = -1
                }
            }
        }
        // Sequence - Make its own Item once we have an idea on what to do
        // This is mostly copied from EditorBox.qml
        ListModel {
            id: sequenceModel
        }
        Rectangle {
            id: elements
            SplitView.fillWidth: true
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: Style.selectedPalette.alternateBase

            // Properties initialized with parent properties.
            readonly property bool removeEnabled: elements.current !== -1
            readonly property bool upEnabled: (sequenceModel.count > 1) && (elements.current > 0)
            readonly property bool downEnabled: (sequenceModel.count > 1) && (elements.current < sequenceModel.count - 1) && (elements.current !== -1)
            property int current: -1

            Row {
                id: buttonsRow
                SmallButton {        // Add button
                    enabled: splitDatasetView.selectedActivity != -1 && splitDatasetView.selectedDataset != -1 
                    icon.source: "qrc:/gcompris/src/server/resource/icons/plus.svg"
                    toolTipOnHover: true
                    toolTipText: qsTr("Add")
                    onClicked: {
                        // We need to store the real id of the dataset, not the filtered one!
                        var elt = {
                            "activity_id": splitDatasetView.selectedActivity,
                            "dataset_id": splitDatasetView.selectedDataset,
                            "activity_name": splitDatasetView.selectedActivityName,
                            "activity_title": splitDatasetView.selectedActivityTitle,
                            "dataset_name": splitDatasetView.selectedDatasetName,
                            "internal_name": splitDatasetView.selectedInternalDatasetName
                        };
                        sequenceModel.append(elt);
                        elements.current = sequenceModel.count - 1;
                    }
                }

                SmallButton {        // Remove button
                    enabled: elements.removeEnabled
                    icon.source: "qrc:/gcompris/src/server/resource/icons/minus.svg"
                    toolTipOnHover: true
                    toolTipText: qsTr("Remove")
                    onClicked: {
                        var toRemove = elements.current;
                        elements.current = -1;
                        sequenceModel.remove(toRemove);
                    }
                }

                SmallButton {        // Move up button
                    enabled: elements.upEnabled
                    icon.source: "qrc:/gcompris/src/server/resource/icons/up.svg"
                    toolTipOnHover: true
                    toolTipText: qsTr("Move up")
                    onClicked: {
                        sequenceModel.move(elements.current, elements.current - 1, 1);
                        elements.current = elements.current - 1;
                    }
                }

                SmallButton {        // Move down button
                    enabled: elements.downEnabled
                    icon.source: "qrc:/gcompris/src/server/resource/icons/up.svg"
                    rotation: 180
                    toolTipOnHover: true
                    toolTipText: qsTr("Move down")
                    onClicked: {
                        sequenceModel.move(elements.current, elements.current + 1, 1);
                        elements.current = elements.current + 1;
                    }
                }
            }

            Flickable {
                id: scrollLines
                anchors.top: buttonsRow.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                contentWidth: width
                contentHeight: boxes.height
                flickableDirection: Flickable.VerticalFlick
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: width
                        opacity: scrollLines.contentHeight > scrollLines.height ? 1 : 0
                        color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                    }
                }

                Column {
                    id: boxes
                    height: implicitHeight
                    Repeater {
                        model: sequenceModel
                        delegate: Rectangle {
                            id: sequenceItem
                            required property var modelData
                            required property int index
                            width: scrollLines.width - 10
                            height: 20 * Style.margins
                            color: mainMouseArea.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.base
                            border.color: sequenceItem.activeFocus ? Style.selectedPalette.highlight :
                            (mainMouseArea.hovered || (elements.current === index) ? Style.selectedPalette.text :
                            Style.selectedPalette.accent)
                            border.width: (sequenceItem.activeFocus || (elements.current === index)) ? 2 : 1
                            activeFocusOnTab: true

                            function selectItem() {
                                elements.current = index;
                            }

                            MouseArea {
                                id: mainMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onClicked: {
                                    sequenceItem.selectItem();
                                }
                            }

                            Keys.onPressed: (event) => {
                                if(event.key == Qt.Key_Space) {
                                    sequenceItem.selectItem();
                                }
                            }
                            Text {
                                anchors.fill: parent
                                text: modelData.activity_title
                            }
                            Rectangle {
                                width: sequenceItem - 10
                                height:  Style.lineHeight
                                anchors.bottom: parent.bottom
                                color: Style.selectedPalette.alternateBase
                                Text {
                                    anchors.fill: parent
                                    text: modelData.dataset_name
                                }
                            }
                        }
                    }

                    Item {
                        width: 1
                        height: Style.bigMargins
                    }
                }
            }
        }
    }

    OkCancelButtons {
        id: okButtons
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: buttonsWidth * 2 + spacing
        onCancelled: sequenceEditor.close()
        onValidated:  {
            saveSequence();
        }
    }
}
