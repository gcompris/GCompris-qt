/* GCompris - BinaryBulbEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
    readonly property var prototypeStack: [ editor.mainPrototype ]

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "random";  label: qsTr("Random numbers");       type: "boolean";        def: "true" }
        ListElement { name: "numberSubLevels"; label: qsTr("Sublevels");             type: "boundedDecimal"; def: "5";  decimalRange: '[1, 10]'; stepSize: 1; decimals: 0 }
        ListElement { name: "shuffle";             label: qsTr("Shuffle level list"); type: "boolean"; def: "true" }
        ListElement { name: "bulbCount";             label: qsTr("Bulb count"); type: "boundedDecimal"; def: "8"; decimalRange: '[1, 8]'; stepSize: 1; decimals: 0 }
        ListElement { name: "numbersToBeConverted";           label: qsTr("Numbers to find"); type: "number_array"; def: '["0"]' }
        ListElement { name: "enableHelp";      label: qsTr("Display the current result");     type: "boolean";    def: "true" }
        ListElement { name: "bulbValueVisible";      label: qsTr("Display the bulb values");     type: "boolean";    def: "true" }
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

            readonly property bool currentRandom: current != -1 && editorModel.get(current).random

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

                    readonly property bool random: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                        currentModel.get(fieldsColumn.modelIndex).random : true

                    FieldEdit { name: "shuffle" }
                    FieldEdit { name: "bulbCount" }
                    FieldEdit { name: "enableHelp" }
                    FieldEdit { name: "bulbValueVisible" }
                    FieldEdit { name: "random" }
                    FieldEdit { name: "numberSubLevels"; visible: fieldsColumn.random }
                    FieldEdit { name: "numbersToBeConverted"; visible: !fieldsColumn.random }
                }
            }
        }
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }

    function validateDataset() {
        var isValid = true;
        var textError = "";
        for(var datasetId = 0; datasetId < editor.mainModel.count; ++datasetId) {
            var currentDataset = editor.mainModel.get(datasetId)
            //check if dataset is not empty
            if(!currentDataset) {
                errorMessage = datasetEmpty;
                instructionPanel.setInstructionText(false, errorMessage);
                instructionPanel.open();
                return false;
            }
            // if "Random start numbers" is not selected, check that "Start numbers" is not empty and contains only numbers
            var wrongValuesArray = new Array();
            if(!currentDataset.random) {
                var maxValue = Math.pow(2, currentDataset.bulbCount) - 1;
                var jsonValue = JSON.parse(currentDataset.numbersToBeConverted);
                for(var i = 0; i < jsonValue.length; ++i) {
                    if(jsonValue[i] > maxValue || jsonValue[i] < 0) {
                        isValid = false;
                        wrongValuesArray.push(jsonValue[i]);
                    }
                }
            }
            if(wrongValuesArray.length != 0) {
                var wrongNumberValues = wrongValuesArray.join(", ");
                textError = textError + ("<li>") + qsTr('These values are invalid for level %1: %2. The values must be between 0 and %3.').arg(datasetId+1).arg(wrongNumberValues).arg(maxValue) + ("</li>")
            }
        }
        if(!isValid) {
            var globalError = qsTr("The following values need to be fixed:<ul>%1</ul>").arg(textError)
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }
}
