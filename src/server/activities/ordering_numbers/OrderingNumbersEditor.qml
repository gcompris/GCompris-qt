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
    readonly property var prototypeStack: [ editor.mainPrototype] // A stack of prototypes (Only one here. There is no nested Listmodel)

    property bool isOperation: false // false for learn_digits, else true
    property bool isAddition: false // false for learn_digits and learn_additions, true for learn_subtractions


    readonly property var sortModeChoices: [
        { "datasetValue": "ascending", "displayedValue": qsTr("ascending") },
        { "datasetValue": "descending", "displayedValue": qsTr("descending") }
    ]
    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        // inserted dynamically as the label and def changes depending on the target activity
        ListElement { name: "values";    label: qsTr("Numbers to sort"); type: "number_array"; def: '["1", "0", "2"]' }

        Component.onCompleted: {
            insert(0, {
                "name": "sortingType",
                "label": qsTr("Sorting mode"),
                "type": "choice",
                "values": editor.sortModeChoices
            })
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

                // For with coefficients
                FieldEdit { name: "sortingType" }
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

            // check only relevant values when using coefficients
            var numbersToSort = JSON.parse(currentDataset.values);

            // check the content of numbersToSort
            var numbersToSortValid = true;
            if(numbersToSort.length < 2) {
                numbersToSortValid = false;
            } else {
                for(var i = 0; i < numbersToSort.length; i++) {
                    var arrayValue = numbersToSort[i];
                    var arrayNumber = parseFloat(arrayValue);
                    var currentMinValue = i === 0 ? 1 : 0;
                    if(isNaN(arrayValue) || !Number.isInteger(arrayNumber) ||
                        arrayNumber < currentMinValue || arrayNumber > 10) {
                        numbersToSortValid = false;
                    }
                }
            }
            if(!numbersToSortValid) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1: "Numbers to sort" must contain more then 2 numbers.').arg(datasetId+1) + ("</li>");
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

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }
}

