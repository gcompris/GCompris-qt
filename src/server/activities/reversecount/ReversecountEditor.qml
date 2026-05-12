/* GCompris - ReversecountEditor.qml
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
    readonly property var prototypeStack: [ editor.mainPrototype ]

    readonly property string teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('"Maximum number" is the maximum number which can be entered on each side of the domino.') + ("</li></ul><ul><li>") +

    qsTr('The maximum interval is the smaller of 15 and 2 * "Domino maximum number".') + ("</li></ul><ul><li>") +

    qsTr('"Intervals" must contain integer numbers between 1 and the maximum interval. These numbers will be selected randomly for each question. You can enter several times the same number to increase the probability that it will be selected.') + ("</li></ul>")

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "maxNumber"; label: qsTr("Maximum number"); type: "boundedDecimal"; def: "9";  decimalRange: '[1, 9]'; stepSize: 1; decimals: 0 }
        ListElement { name: "values"; label: qsTr("Intervals"); type: "number_array"; def: '[]' }
        ListElement { name: "numberOfFish"; label: qsTr("Number of fishes"); type: "boundedDecimal"; def: "5"; decimalRange: '[1, 20]'; stepSize: 1; decimals: 0 }
    }

    StyledSplitView {
        anchors.fill: parent

        EditorBox {
            id: levelEditor
            SplitView.minimumWidth: levelEditor.minWidth
            SplitView.preferredWidth: editor.width - Style.margins
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

                    FieldEdit { name: "maxNumber" }
                    FieldEdit {
                        name: "values"
                        maxNumberOfItems: 50
                        maxWidth: levelEditor.maxWidth
                    }
                    FieldEdit { name: "numberOfFish" }
                }
            }
        }
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }

    function validateDataset() {
        var isValid = true;
        var globalError = "";
        var textError = "";
        var currentDataset = editor.mainModel.get(0);
        var maxInterval = 15;
        //check if dataset is not empty
        if(!currentDataset) {
            globalError = ("<ul><li>") + qsTr('Dataset is empty.') + ("</li></ul>");
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
            return false;
        }
        for(var datasetId = 0; datasetId < editor.mainModel.count; ++datasetId) {
            currentDataset = editor.mainModel.get(datasetId);
            // Check that given values are integer numbers between 1 and the maximum interval possible with given maxNumber
            var wrongValuesArray = new Array();
            var maxPossibleValue = Math.min(maxInterval, JSON.parse(currentDataset.maxNumber) * 2);
            var jsonValue = JSON.parse(currentDataset.values);
            if(jsonValue.length === 0) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('"Intervals" for level %1 must not be empty.').arg(datasetId+1) + ("</li>");
            } else {
                for(var i = 0; i < jsonValue.length; ++i) {
                    var numberToFind = Number(jsonValue[i]);
                    if(isNaN(numberToFind) || !Number.isInteger(numberToFind) ||
                        numberToFind > maxPossibleValue || numberToFind < 1) {
                        isValid = false;
                        wrongValuesArray.push(jsonValue[i]);
                    }
                }
            }
            if(wrongValuesArray.length != 0) {
                var wrongNumberValues = wrongValuesArray.join(", ");
                textError = textError + ("<li>") + qsTr('These intervals are invalid for level %1: %2. Read the instructions for more details.').arg(datasetId+1).arg(wrongNumberValues) + ("</li>");
            }
        }
        if(!isValid) {
            globalError = qsTr("The following errors need to be fixed:<ul>%1</ul>").arg(textError)
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }
}
