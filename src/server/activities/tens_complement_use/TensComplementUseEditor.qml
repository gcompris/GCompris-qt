/* GCompris - TensComplementUseEditor.qml
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

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "randomValues";  label: qsTr("Random questions");       type: "boolean";        def: "true" }
        ListElement { name: "numberOfSubLevels"; label: qsTr("Sublevels");             type: "boundedDecimal"; def: "5";  decimalRange: '[1, 10]'; stepSize: 1; decimals: 0 }
        ListElement { name: "numberOfAdditions"; label: qsTr("Additions per sublevel");             type: "boundedDecimal"; def: "2";  decimalRange: '[1, 2]'; stepSize: 1; decimals: 0 }
        ListElement { name: "numberOfExtraCards"; label: qsTr("Extra cards");             type: "boundedDecimal"; def: "2";  decimalRange: '[0, 4]'; stepSize: 1; decimals: 0 }
        ListElement { name: "minResult";             label: qsTr("Minimum result"); type: "boundedDecimal"; def: "11";  decimalRange: '[11, 99]'; stepSize: 1; decimals: 0 }
        ListElement { name: "maxResult";             label: qsTr("Maximum result"); type: "boundedDecimal"; def: "20"; decimalRange: '[11, 99]'; stepSize: 1; decimals: 0 }
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "false" }
        ListElement { name: "values";       label: qsTr("Sublevels");   type: "model";      def: "[]"}
    }

    property ListModel subPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "additions";    label: qsTr("Additions"); type: "string_array"; def: '[]' }
        ListElement { name: "extraCards";    label: qsTr("Extra cards"); type: "number_array"; def: '[]' }
    }

    StyledSplitView {
        anchors.fill: parent

        EditorBox {
            id: levelEditor
            SplitView.minimumWidth: levelEditor.minWidth
            SplitView.preferredWidth: editor.width * 0.5 - Style.margins
            SplitView.fillHeight: true
            editorPrototype: editor.mainPrototype
            editorModel: editor.mainModel

            readonly property bool currentRandomValues: current != -1 && editorModel.get(current).randomValues

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

                    readonly property bool randomValues: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                        currentModel.get(fieldsColumn.modelIndex).randomValues : true

                    FieldEdit { name: "randomValues" }

                    // For Random mode
                    FieldEdit { name: "numberOfSubLevels"; visible: fieldsColumn.randomValues }
                    FieldEdit { name: "numberOfAdditions"; visible: fieldsColumn.randomValues }
                    FieldEdit { name: "numberOfExtraCards"; visible: fieldsColumn.randomValues }
                    FieldEdit {
                        id: minResult
                        name: "minResult"
                        visible: fieldsColumn.randomValues
                        onValueChanged: {
                            if(parseFloat(value) > parseFloat(maxResult.value)) {
                                maxResult.value = value;
                            }
                        }
                    }
                    FieldEdit {
                        id: maxResult
                        name: "maxResult"
                        visible: fieldsColumn.randomValues
                        onValueChanged: {
                            if(parseFloat(value) < parseFloat(minResult.value)) {
                                minResult.value = value;
                            }
                        }
                    }

                    // For Fixed mode
                    FieldEdit { name: "shuffle"; visible: !fieldsColumn.randomValues }
                    FieldEdit { name: "values"; visible: !fieldsColumn.randomValues }
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

            toolBarEnabled: levelEditor.current != -1 && !levelEditor.currentRandomValues

            fieldsComponent: Component {
                Column {
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: subLevelEditor.editorPrototype
                    property ListModel currentModel: subLevelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins

                    FieldEdit {
                        name: "additions"
                        maxNumberOfItems: 2
                        maxWidth: subLevelEditor.maxWidth
                    }

                    FieldEdit {
                        name: "extraCards"
                        maxNumberOfItems: 4
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
        var currentDataset = editor.mainModel.get(0);
        //check if dataset is not empty
        if(!currentDataset) {
            globalError = ("<ul><li>") + qsTr('Dataset is empty.') + ("</li></ul>");
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
            return false;
        }
        for(var datasetId = 0; datasetId < editor.mainModel.count; ++datasetId) {
            currentDataset = editor.mainModel.get(datasetId);
            if(currentDataset.randomValues) {
                // check that numberOfExtraCards is not too high
                var operandCards = 2 * parseFloat(currentDataset.numberOfAdditions);
                var numberOfExtraCards = parseFloat(currentDataset.numberOfExtraCards);
                if(operandCards + numberOfExtraCards > 6) {
                    isValid = false;
                    textError = textError + ("<li>") + qsTr('Level %1 contains too many extra cards.').arg(datasetId+1) + ("</li>");
                }
            } else {
                var datasetQuestions = currentDataset.values;
                if(datasetQuestions.count < 1) {
                    isValid = false;
                    textError = textError + ("<li>") + qsTr('Level %1 must not be empty.').arg(datasetId+1) + ("</li>");
                } else {
                    // Check that sublevels contain proper additions
                    for(var i = 0; i < datasetQuestions.count; i++) {
                        var sublevel = datasetQuestions.get(i);
                        var additions = JSON.parse(sublevel.additions);
                        var extraCards = JSON.parse(sublevel.extraCards);
                        if(additions.length === 0) {
                            isValid = false;
                            textError = textError + ("<li>") + qsTr('Sublevel %2 of Level %1 must not be empty.').arg(datasetId+1).arg(i+1) + ("</li>");
                        } else {
                            for(var j = 0; j < additions.length; j++) {
                                var additionArray = additions[j].match(/\d+/g).map(Number);
                                var additionResult = additionArray[0] + additionArray[1];
                                if(additionArray.length != 2 ||
                                    !Number.isInteger(additionArray[0]) || !Number.isInteger(additionArray[1]) ||
                                    additionArray[0] < 1 || additionArray[0] > 9 ||
                                    additionResult < 11 || additionResult > 99) {
                                    isValid = false;
                                    textError = textError + ("<li>") + qsTr('Addition %3 of Sublevel %2 of Level %1 is not correct.').arg(datasetId+1).arg(i+1).arg(j+1) + ("</li>");
                                }
                            }
                        }
                        if(extraCards.length != 0) {
                            for(var cardId = 0; cardId < extraCards.length; cardId++) {
                                var cardContent = extraCards[cardId];
                                var cardNumber = parseFloat(cardContent);
                                if(isNaN(cardContent) || !Number.isInteger(cardNumber) || cardNumber < 1 || cardNumber > 99) {
                                    isValid = false;
                                    textError = textError + ("<li>") + qsTr('Sublevel %2 of Level %1 contains invalid extra cards.').arg(datasetId+1).arg(i+1) + ("</li>");
                                }
                            }
                            // check that extraCards doesn't contain too many entries
                            var operandCards = 2 * additions.length;
                            var numberOfExtraCards = extraCards.length;
                            if(operandCards + numberOfExtraCards > 6) {
                                isValid = false;
                                textError = textError + ("<li>") + qsTr('Sublevel %2 of Level %1 contains too many extra cards.').arg(datasetId+1).arg(i+1) + ("</li>");
                            }
                        }
                    }
                }
            }
        }
        if(!isValid) {
            globalError = qsTr("The following errors need to be fixed:<ul>%1</ul>").arg(textError);
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }
}

