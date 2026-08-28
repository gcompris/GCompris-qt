/* GCompris - OrderingNumbersEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
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
    readonly property var prototypeStack: [ editor.mainPrototype] // A stack of prototypes (Only one here. There is no nested Listmodel)

    readonly property var sortModeChoices: [
        { "datasetValue": "ascending", "displayedValue": qsTr("ascending") },
        { "datasetValue": "descending", "displayedValue": qsTr("descending") }
    ]
    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        // inserted dynamically as the label and def changes depending on the target activity
        ListElement { name: "values";    label: qsTr("Numbers to sort"); type: "number_array"; def: '["1", "2", "3"]' }

        Component.onCompleted: {
            append({
                "name": "mode",
                "label": qsTr("Sorting mode"),
                "type": "choice",
                "values": editor.sortModeChoices
            })

            mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));

        }
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

                FieldEdit { name: "mode" }
                FieldEdit { name: "values" }
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

            var numbersToSort = JSON.parse(currentDataset.values);
            var sortingMode = currentDataset.mode;

            // check the content of numbersToSort
            var atLeastTwoNumbers = true;
            var numberIsPositiveOrNull = true
            var numbersAreAllInteger = true
            var numbersAscendingOk = true
            if(numbersToSort.length < 2) {
                atLeastTwoNumbers = false;
            } else {
                var precedentArrayNumber
                for(var i = 0; i < numbersToSort.length; i++) {
                    var arrayValue = numbersToSort[i];
                    var arrayNumber = parseFloat(arrayValue);
                    if(isNaN(arrayValue) || !Number.isInteger(arrayNumber)) {
                        numbersAreAllInteger = false;
                    }
                    if(arrayNumber < 0) {
                        numberIsPositiveOrNull = false;
                    }
                    // Always supply numbers in ascending order (e.g., 1, 2, 3); the sorting direction parameter handles reversing to descending (3, 2, 1).
                    if (i>0) {
                        if (arrayNumber < precedentArrayNumber) numbersAscendingOk = false
                    }
                    precedentArrayNumber = parseFloat(numbersToSort[i])
                }
            }
            if(!atLeastTwoNumbers) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1: "numbers to sort" must contain at least 2 numbers.').arg(datasetId+1) + ("</li>");
            } else if(!numbersAreAllInteger) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1: all numbers must be integers.').arg(datasetId+1) + ("</li>");
            }  else if(!numberIsPositiveOrNull) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1: all numbers must be positive or equal to zero.').arg(datasetId+1) + ("</li>");
            } else if(!numbersAscendingOk) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1: always supply numbers in ascending order (e.g., 1, 3, 6); the sorting direction parameter handles reversing to descending (6, 3, 1).').arg(datasetId+1) + ("</li>");
            }


        }

        if(!isValid) {
            globalError = qsTr("The following errors need to be fixed:<ul>%1</ul>").arg(textError);
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }


    Component.onCompleted: {
        // if(!editor.isOperation) {
        //     // We insert dynamically here the choice
        //     editor.mainPrototype.insert(0, { name: "questionsArray", label: qsTr("Numbers"), type: "string_array", def: '["0"]'});
        // } else if(editor.isAddition) {
        //     editor.mainPrototype.insert(0, { name: "questionsArray", label: qsTr("Additions"), type: "string_array", def: '["1 + 1"]'});
        // } else {
        //     editor.mainPrototype.insert(0, { name: "questionsArray", label: qsTr("Subtractions"), type: "string_array", def: '["1 - 1"]'});
        // }     
    }
}

