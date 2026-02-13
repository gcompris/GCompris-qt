/* GCompris - TensComplementSwapEditor.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
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
    readonly property var prototypeStack: [ editor.mainPrototype, editor.subPrototype ]   // A stack of two prototypes

    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('All numbers must be positive integers') + ("</li></ul><ul><li>") +

    qsTr('If "Random operands" is not selected, "Operands" must contain 1, 2 or 3 entries. Each entry must be a number between 1 and 9. The resulting addition will contain the given entries and their complement to 10.') + ("</li></ul><ul><li>") +

    qsTr('"Extra operand" can contain 1 number between 1 and 9 which will be added to the addition. It is mandatory if "Operands" contains 1 number, optional if "Operands" contains 2 numbers, and not used if "Operands" contains 3 numbers.') + ("</li></ul>")

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "shuffle";      label: qsTr("Shuffle");   type: "boolean";      def: "false"}
        ListElement { name: "values";       label: qsTr("Additions");   type: "model";      def: "[]"}
    }

    property ListModel subPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "randomValues";  label: qsTr("Random operands");       type: "boolean";        def: "true" }
        ListElement { name: "numberOfElements"; label: qsTr("Number of operands"); type: "boundedDecimal"; def: "4";  decimalRange: '[3, 6]'; stepSize: 1; decimals: 0 }
        ListElement { name: "numberValues";    label: qsTr("Operands"); type: "number_array"; def: '[]' }
        ListElement { name: "extraValue";    label: qsTr("Extra operand"); type: "number_array"; def: '[]' }
    }

    StyledSplitView {
        anchors.fill: parent

        EditorBox {
            id: levelEditor
            SplitView.minimumWidth: levelEditor.minWidth
            SplitView.preferredWidth: editor.width * 0.25 - Style.margins
            SplitView.fillHeight: true
            editorPrototype: editor.mainPrototype
            editorModel: editor.mainModel

            fieldsComponent: Component {
                Column {
                    id: fieldsColumn
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: levelEditor.editorPrototype
                    property ListModel currentModel: levelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins

                    FieldEdit { name: "shuffle"; }
                    FieldEdit { name: "values"; }
                }
            }

            onCurrentChanged: {
                subLevelEditor.current = -1;
                if(current > -1 && current < editorModel.count) {
                    subLevelEditor.editorModel = editor.mainModel.get(levelEditor.current).values;
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
            editorPrototype: editor.subPrototype
            editorModel: null // set in levelEditor onCurrentChanged

            toolBarEnabled: levelEditor.current != -1
            addEnabled: editorModel && editorModel.count < 4 // Max 4 questions per level to avoid layout overflow

            fieldsComponent: Component {
                Column {
                    id: subLevelFieldColumn
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: subLevelEditor.editorPrototype
                    property ListModel currentModel: subLevelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins

                    readonly property bool randomValues: currentModel &&
                        currentModel.get(modelIndex) ?
                            currentModel.get(modelIndex).randomValues : true

                    readonly property int numberOfValues: currentModel &&
                        currentModel.get(modelIndex) ?
                            JSON.parse(currentModel.get(modelIndex).numberValues).length : 0

                    FieldEdit { name: "randomValues" }

                    // For Random mode
                    FieldEdit { name: "numberOfElements"; visible: subLevelFieldColumn.randomValues }

                    // For Fixed mode
                    FieldEdit {
                        name: "numberValues"
                        visible: !subLevelFieldColumn.randomValues
                        maxNumberOfItems: 3
                        maxWidth: subLevelEditor.maxWidth
                    }
                    FieldEdit {
                        name: "extraValue"
                        visible: !subLevelFieldColumn.randomValues && subLevelFieldColumn.numberOfValues < 3
                        maxNumberOfItems: 1
                        maxWidth: subLevelEditor.maxWidth
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
            var datasetQuestions = currentDataset.values;
            if(datasetQuestions.count < 1) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1 must not be empty.').arg(datasetId+1) + ("</li>");
            } else {
                for(var i = 0; i < datasetQuestions.count; i++) {
                    var subLevelValid = true;
                    var sublevel = datasetQuestions.get(i);
                    if(!sublevel.randomValues) {
                        var operands = JSON.parse(sublevel.numberValues);
                        var extraValue = JSON.parse(sublevel.extraValue);
                        var numberOfCards = (operands.length * 2) + extraValue.length;
                        if(numberOfCards < 3) {
                            subLevelValid = false;
                        } else {
                            // Check that operands contains only integer numbers between 1 and 9
                            for(var numberId = 0; numberId < operands.length; numberId++) {
                                var operand = operands[numberId];
                                var operandNumber = parseFloat(operand);
                                if(isNaN(operand) || !Number.isInteger(operandNumber) ||
                                    operandNumber < 1 || operandNumber > 9) {
                                    subLevelValid = false
                                    break;
                                }
                            }
                        }

                        // Check extraValue content if it will be used (less than 3 operands)
                        if(operands.length < 3 && extraValue.length > 0) {
                            var extraValueContent = extraValue[0];
                            var extraValueNumber = parseFloat(extraValueContent);
                            if(isNaN(extraValueContent) ||
                                !Number.isInteger(extraValueNumber) ||
                                extraValueNumber < 1 || extraValueNumber > 9) {
                                subLevelValid = false
                            }
                        }
                    }

                    if(!subLevelValid) {
                        isValid = false;
                        textError = textError + ("<li>") + qsTr('Content of Addition %2 of Level %1 is not valid. Please check the instructions.').arg(datasetId+1).arg(i+1) + ("</li>");
                    }
                }
            }
        }
        if(!isValid) {
            globalError = qsTr("The following errors need to be fixed:<ul>%1</ul>").arg(textError)
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }
}

