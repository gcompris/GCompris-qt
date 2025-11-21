/* GCompris - FractionsFindEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Ashutosh Singh <ashutoshas2610@gmail.com>
 *
 * Authors:
 *   Ashutosh Singh <ashutoshas2610@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import "../../singletons"
import "../../components"

import ".."

DatasetEditorBase {
    id: editor
    required property string textActivityData
    property ListModel mainModel: ({})
    readonly property var prototypeStack: [ mainPrototype, subPrototype ]

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "true" }
        ListElement { name: "subLevels";    label: qsTr("Questions");   type: "model";      def: "[]" }
    }

    ListModel {
        id: subPrototype
        property bool multiple: true
        ListElement { name: "fixedNumerator";     label: qsTr("Static numerator ");      type: "boolean";      def: "false" }
        ListElement { name: "fixedDenominator";   label: qsTr("Static denominator");    type: "boolean";      def: "false" }
        ListElement { name: "numerator"; label: qsTr("Numerator"); type: "boundedDecimal"; def: "1"; decimalRange: "[1,24]"; stepSize: 1; decimals: 0 }
        ListElement { name: 'denominator'; label: qsTr("Denominator"); type: "boundedDecimal"; def: "2"; decimalRange: '[2,12]'; stepSize: 1; decimals: 0 }
        ListElement { name: "maxFractions";   label: qsTr("Maximum of units");    type: "comboInt";   def: "[1,2]"; }
        ListElement { name: "random";   label: qsTr("Random fraction");    type: "boolean";      def: "true" }
    }

    StyledSplitView {
        anchors.fill: parent

        EditorBox {
            id: levelEditor
            SplitView.minimumWidth: levelEditor.minWidth
            SplitView.preferredWidth: editor.width * 0.2
            SplitView.fillHeight: true
            editorPrototype: mainPrototype
            editorModel: editor.mainModel

            fieldsComponent: Component {
                Column {
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: levelEditor.editorPrototype
                    property ListModel currentModel: levelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins
                    FieldEdit { name: "shuffle" }
                    FieldEdit { name: "subLevels" }
                }
            }

            onCurrentChanged: {
                subLevelEditor.current = -1;
                if(current > -1 && current < editorModel.count) {
                    subLevelEditor.editorModel = editor.mainModel.get(levelEditor.current).subLevels;
                } else {
                    subLevelEditor.editorModel = null;
                }
            }
        }

        EditorBox {
            id: subLevelEditor
            SplitView.minimumWidth: subLevelEditor.minWidth
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            editorPrototype: subPrototype
            editorModel: null // set in levelEditor onCurrentChanged

            toolBarEnabled: levelEditor.current != -1

            fieldsComponent: Component {
                Column {
                    id: fieldsColumn
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: subLevelEditor.editorPrototype
                    property ListModel currentModel: subLevelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins

                    readonly property bool random: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).random : false

                    FieldEdit { name: "chartType" }
                    FieldEdit { name: "random" }
                    FieldEdit {
                        name: "maxFractions"
                        visible: fieldsColumn.random
                    }
                    FieldEdit {
                        id: numeratorField
                        name: "numerator"
                        visible: fieldsColumn.random === false
                        onValueChanged: {
                            if(parseInt(value) > 2 * parseInt(denominatorField.value)) {
                                denominatorField.value = String(Math.ceil(parseInt(value) / 2));
                            }
                        }
                    }
                    FieldEdit {
                        id: denominatorField
                        visible: fieldsColumn.random === false
                        name: "denominator"
                        onValueChanged: {
                            if(2 * parseInt(value) < parseInt(numeratorField.value)) {
                                numeratorField.value = String(parseInt(value) * 2);
                            }
                        }
                    }
                    FieldEdit {
                        id: fixedNumeratorField
                        name: "fixedNumerator"
                        onJsonValueChanged: {
                            if(jsonValue && fixedDenominatorField.jsonValue) {
                                fixedDenominatorField.value = "false";
                            }
                        }
                    }
                    FieldEdit {
                        id: fixedDenominatorField
                        name: "fixedDenominator"
                        onJsonValueChanged: {
                            if(jsonValue && fixedNumeratorField.jsonValue) {
                                fixedNumeratorField.value = "false";
                            }
                        }
                    }
                }
            }
        }
    }

    function validateDataset() {
        var isValid = true;
        var globalError = "";
        var textError = "";
        var currentDataset = editor.mainModel.get(0)
        //check if dataset is not empty
        if(!currentDataset) {
            globalError = ("<ul><li>") + qsTr('Dataset is empty.') + ("</li></ul>")
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
            return false;
        }
        for(var datasetId = 0; datasetId < editor.mainModel.count; ++datasetId) {
            currentDataset = editor.mainModel.get(datasetId);
            var datasetQuestions = currentDataset.subLevels;
            if(datasetQuestions.count < 1) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1 must not be empty.').arg(datasetId+1) + ("</li>");
            }
        }
        if(!isValid) {
            globalError = qsTr("The following errors need to be fixed:<ul>%1</ul>").arg(textError)
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }

    readonly property var chartTypeChoices: [
        { "datasetValue": "rectangle", "displayedValue": qsTr("Rectangle") },
        { "datasetValue": "pie", "displayedValue": qsTr("Circle") }
    ]
    Component.onCompleted: {
        subPrototype.append({name: "chartType", label: qsTr("Chart Type"), type: "choice", values: chartTypeChoices})

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
