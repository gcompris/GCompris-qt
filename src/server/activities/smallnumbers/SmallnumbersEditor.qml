/* GCompris - SmallnumbersEditor.qml
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
    readonly property var prototypeStack: [ mainPrototype ] // A stack of prototypes (Only one here. There is no nested Listmodel)

    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('"Sublevels" defines the amount of numbers which will appear in the level. Numbers will be randomly selected from the "Numbers" list.') + ("</li></ul><ul><li>") +

    qsTr('"Numbers" must contain a list of integer numbers between 0 and 9. You can enter several times the same number to increase the probability that it will be appear.') + ("</li></ul><ul><li>") +

    qsTr('You can enter an optional instruction sentence in the "Instruction" field, or leave it empty.') + ("</li></ul>")

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "sublevels"; label: qsTr("Sublevels"); type: "boundedDecimal"; def: "10";  decimalRange: '[1,50]'; stepSize: 1; decimals: 0 }
        ListElement { name: "words"; label: qsTr("Numbers"); type: "string_array"; def: '[]' }
        ListElement { name: "objective"; label: qsTr("Instruction"); type: "string";  def: "" }
    }

    EditorBox {
        id: levelEditor
        anchors.fill: parent
        editorPrototype: mainPrototype
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

                FieldEdit { name: "sublevels" }
                FieldEdit {
                    name: "words"
                    maxNumberOfItems: 50
                    maxWidth: levelEditor.maxWidth
                }
                FieldEdit {
                    name: "objective"
                    maxWidth: levelEditor.maxWidth
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
            // Check that "Numbers to find" is not empty and contains only integer numbers between 0 and 9
            var wrongValuesArray = new Array();
            var maxValue = 9
            var jsonValue = JSON.parse(currentDataset.words);
            if(jsonValue.length === 0) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('"Numbers" for level %1 must not be empty.').arg(datasetId+1) + ("</li>");
            } else {
                for(var i = 0; i < jsonValue.length; ++i) {
                    var currentValue = jsonValue[i];
                    if(currentValue.length > 1) { // check that it's only one character, as it won't work if there's extra 0.
                        isValid = false;
                        wrongValuesArray.push(currentValue);
                    } else {
                        var numberToFind = Number(currentValue);
                        if(isNaN(numberToFind) || !Number.isInteger(numberToFind) ||
                            numberToFind > maxValue || numberToFind < 0) {
                            isValid = false;
                            wrongValuesArray.push(currentValue);
                        }
                    }
                }
            }
            if(wrongValuesArray.length != 0) {
                var wrongNumberValues = wrongValuesArray.join(", ");
                textError = textError + ("<li>") + qsTr('These values are invalid for level %1: %2. The values must be integer numbers between 0 and %3.').arg(datasetId+1).arg(wrongNumberValues).arg(maxValue) + ("</li>");
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
