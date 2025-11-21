/* GCompris - DecimalAdditionEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Ashutosh Singh <ashutoshas2610@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Ashutosh Singh <ashutoshas2610@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../../singletons"
import "../../components"
import ".."
DatasetEditorBase {
    id: editor
    required property string textActivityData               // Json array stringified as stored in database (dataset_/dataset_content)
    property ListModel mainModel: ({})                      // The main ListModel, declared as a property for dynamic creation
    readonly property var prototypeStack: [ mainPrototype, subPrototype ]   // A stack of two prototypes

    property bool isAddition: true // false for subtraction

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "true" }
        ListElement { name: "subLevels";    label: qsTr("Sublevels");   type: "model";      def: "[]" }
    }

    ListModel {
        id: subPrototype
        property bool multiple: true
        // inputType is inserted in the global Component.onCompleted function.
        // We cannot implement "choice" directly as ListElement due to the fact
        // that the values are variables and only static values are accepted
        //ListElement { name: "inputType"; label: qsTr("Mode"); type: "choice"; def: '["Random", "Fixed"]' }
        // We can display 6 bars for additions and 5 bars for subtractions, so limit the range to 5 in any case to make things simpler.
        ListElement { name: "firstNumber"; label: qsTr("First Number"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,5]' ; stepSize: 1 ; decimals: 1 }
        ListElement { name: "secondNumber"; label: qsTr("Second Number"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,5]' ; stepSize: 1 ; decimals: 1 }
        ListElement { name: "minValue"; label: qsTr("Minimum Value"); type: "boundedDecimal"; def: "0" ; decimalRange :'[0,5]' ; stepSize: 1  ; decimals: 1 }
        ListElement { name: "maxValue"; label: qsTr("Maximum Value"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,5]' ; stepSize: 1 ; decimals: 1 }
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

                    readonly property bool fixedMode: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).inputType === "fixed" : false

                    property double firstNumber: 0
                    property double secondNumber: 0

                    function clampSecondNumber() {
                        if(editor.isAddition && firstNumber + secondNumber > 6) {
                            secondNumber = 6 - firstNumber;
                            secondNumberField.value = secondNumber.toString();
                        } else if(!editor.isAddition && firstNumber - secondNumber < 0) {
                            secondNumber = firstNumber;
                            secondNumberField.value = secondNumber.toString();
                        }
                    }

                    function clampFirstNumber() {
                        if(editor.isAddition && firstNumber + secondNumber > 6) {
                            firstNumber = 6 - secondNumber;
                            firstNumberField.value = firstNumber.toString();
                        } else if(!editor.isAddition && firstNumber - secondNumber < 0) {
                            firstNumber = secondNumber;
                            firstNumberField.value = firstNumber.toString();
                        }
                    }

                    FieldEdit { name: "inputType" }
                    FieldEdit {
                        id: firstNumberField
                        name: "firstNumber"
                        visible: fieldsColumn.fixedMode
                        onValueModified: {
                            fieldsColumn.firstNumber = parseFloat(value);
                            fieldsColumn.clampSecondNumber();
                        }
                    }
                    FieldEdit {
                        id: secondNumberField
                        name: "secondNumber"
                        visible: fieldsColumn.fixedMode
                        onValueModified: {
                            fieldsColumn.secondNumber = parseFloat(value);
                            fieldsColumn.clampFirstNumber();
                        }
                    }

                    FieldEdit {
                        id: minValueField
                        name: "minValue"
                        visible: !fieldsColumn.fixedMode
                        onValueModified: {
                            if(parseFloat(value) > parseFloat(maxValueField.value)) {
                                maxValueField.value = value;
                            }
                        }
                    }

                    FieldEdit {
                        id: maxValueField
                        name: "maxValue"
                        visible:! fieldsColumn.fixedMode
                        onValueModified: {
                            if(parseFloat(value) < parseFloat(minValueField.value)) {
                                minValueField.value = value;
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

    readonly property var inputTypeChoices: [
        { "datasetValue": "range", "displayedValue": qsTr("Random") },
        { "datasetValue": "fixed", "displayedValue": qsTr("Fixed") }
    ]

    Component.onCompleted: {
        // We insert dynamically here the choice
        subPrototype.insert(0, {name: "inputType", label: qsTr("Mode"), type: "choice", values: inputTypeChoices})

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
