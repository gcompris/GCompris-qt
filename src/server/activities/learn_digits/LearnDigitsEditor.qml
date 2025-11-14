/* GCompris - LearnDigitsEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
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
    readonly property var prototypeStack: [ editor.mainPrototype ] // A stack of prototypes (Only one here. There is no nested Listmodel)

    property bool isOperation: false // false for learn_digits, else true
    property bool isAddition: false // false for learn_digits and learn_additions, true for learn_subtractions

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        // inserted dynamically as the label and def changes depending on the target activity
        // ListElement { name: "questionsArray"; label: qsTr("Numbers");           type: "string_array";   def: '["0"]' }
        ListElement { name: "circlesModel";   label: qsTr("Number of circles"); type: "boundedDecimal"; def: "9";  decimalRange: '[1,9]'; stepSize: 1; decimals: 0 }
        ListElement { name: "randomOrder";    label: qsTr("Random order");      type: "boolean";        def: "true" }
    }

    EditorBox {
        id: levelEditor
        anchors.fill: parent
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

                property int maxNumber: 0
                onMaxNumberChanged: {
                    clipCirclesToMaxNumber();
                }

                // Make sure that circlesModel is big enough to enter highest answer
                function clipCirclesToMaxNumber() {
                    if(parseInt(circlesModelField.value) < maxNumber) {
                        circlesModelField.value = maxNumber.toString();
                    }
                }

                FieldEdit {
                    name: "questionsArray"
                    maxWidth: levelEditor.maxWidth
                    onValueChanged: {
                        // store max number from array in maxNumber
                        var tempMaxNumber = 0;
                        var jsonValues = JSON.parse(value)
                        for(var i = 0; i < jsonValues.length; i++) {
                            var questionValue = eval?.(`"use strict";(${jsonValues[i]})`);
                            if(tempMaxNumber < questionValue) {
                                tempMaxNumber = questionValue;
                            }
                        }
                        if(tempMaxNumber > 9) {
                            tempMaxNumber = 9; // prevent setting maxNumber above 9, as the circlesModel max is 9 trying to set it above that creates binding loops...
                        }
                        fieldsColumn.maxNumber = tempMaxNumber;
                    }
                }
                FieldEdit {
                    id: circlesModelField
                    name: "circlesModel"
                    onValueModified: {
                        fieldsColumn.clipCirclesToMaxNumber();
                    }
                }
                FieldEdit {
                    name: "randomOrder"
                }
            }
        }
    }

    readonly property string datasetEmpty: ("<ul><li>") +
    qsTr('Dataset is empty.') + ("</li></ul>")
    readonly property string numberListErrorMessage: ("<ul><li>") +
    qsTr('"Numbers" must only contain integer numbers between 0 and 9, and must not be empty.') + ("</li></ul>")
    readonly property string additionListErrorMessage: ("<ul><li>") +
    qsTr('"Additions" must only contain additions which results are integer numbers between 0 and 9, and must not be empty.') + ("</li></ul>")
    readonly property string subtractionListErrorMessage: ("<ul><li>") +
    qsTr('"Subtractions" must only contain subtractions which results are integer numbers between 0 and 9, and must not be empty.') + ("</li></ul>")

    function validateDataset() {
        var errorMessage = "";
        var currentDataset = editor.mainModel.get(0);
        // check if dataset is not empty
        if(!currentDataset) {
            errorMessage = datasetEmpty;
            instructionPanel.setInstructionText(false, errorMessage);
            instructionPanel.open();
            return false;
        }
        var numberListError = false;
        // check the content of all added levels
        for(var level = 0; level < editor.mainModel.count; level++) {
            currentDataset = editor.mainModel.get(level);
            var numberList = JSON.parse(currentDataset.questionsArray);
            // check if Numbers list is not empty
            if(numberList.length === 0) {
                numberListError = true;
                break;
            } else {
                // check if Numbers list contains only integer numbers between 0 and 9, or operations with integer result between 0 and 9
                for(var i = 0; i < numberList.length; i++) {
                    var numberToFind = eval?.(`"use strict";(${numberList[i]})`);
                    if(isNaN(numberToFind) || !Number.isInteger(numberToFind) ||
                    numberToFind < 0 || numberToFind > 9) {
                        numberListError = true;
                        break;
                    }
                }
                if(numberListError) {
                    break;
                }
            }

        }
        if(numberListError) {
            if(!isOperation) {
                errorMessage = numberListErrorMessage;
            } else if(isAddition) {
                errorMessage = additionListErrorMessage;
            } else {
                errorMessage = subtractionListErrorMessage;
            }
            instructionPanel.setInstructionText(false, errorMessage);
            instructionPanel.open();
            return false;
        } else {
            return true;
        }
    }

    Component.onCompleted: {
        if(!editor.isOperation) {
            // We insert dynamically here the choice
            editor.mainPrototype.insert(0, { name: "questionsArray", label: qsTr("Numbers"), type: "string_array", def: '["0"]'});
        } else if(editor.isAddition) {
            editor.mainPrototype.insert(0, { name: "questionsArray", label: qsTr("Additions"), type: "string_array", def: '["1 + 1"]'});
        } else {
            editor.mainPrototype.insert(0, { name: "questionsArray", label: qsTr("Subtractions"), type: "string_array", def: '["1 - 1"]'});
        }

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }
}

