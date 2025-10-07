/* GCompris - AdjacentNumbersEditor.qml
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
    readonly property var prototypeStack: [ mainPrototype ] // A stack of prototypes (Only one here. There is no nested Listmodel)

    ListModel {
        id: mainPrototype
        property bool multiple: false
        // TODO: fix FieldEdit to store int for boundedDecimal entries instead of strings, and add a way to store arrays of int (maybe with new int_array component?)...
        ListElement { name: "randomSubLevels";   label: qsTr("Random start numbers");  type: "boolean";        def: "true" }
        ListElement { name: "numberRandomLevel"; label: qsTr("Sublevels");            type: "boundedDecimal"; def: "5";  decimalRange: '[1,10]';      stepSize: 1; decimals: 0 }
        ListElement { name: "fixedLevels";       label: qsTr("Start numbers");        type: "string_array";   def: '["0"]' }
        ListElement { name: "lowerBound";        label: qsTr("Minimum start number"); type: "boundedDecimal"; def: "0";  decimalRange: '[-10000, 10000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "upperBound";        label: qsTr("Maximum start number"); type: "boundedDecimal"; def: "10"; decimalRange: '[-10000, 10000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "step";              label: qsTr("Step between numbers"); type: "boundedDecimal"; def: "1";  decimalRange: '[1,1000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "numberShown";       label: qsTr("Sequence length");      type: "boundedDecimal"; def: "3";  decimalRange: '[3,6]'; stepSize: 1; decimals: 0 }
        ListElement { name: "indicesToGuess";    label: qsTr("Position of missing numbers"); type: "string_array"; def: '["0"]' }
        ListElement { name: "numberPropositions"; label: qsTr("Proposed numbers");    type: "boundedDecimal"; def: "3";  decimalRange: '[2,7]'; stepSize: 1; decimals: 0 }
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

                readonly property bool randomMode: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).randomSubLevels : false

                FieldEdit { name: "randomSubLevels" }
                FieldEdit {
                    name: "numberRandomLevel"
                    visible: fieldsColumn.randomMode
                }
                FieldEdit {
                    name: "fixedLevels"
                    maxWidth: levelEditor.maxWidth
                    visible: !fieldsColumn.randomMode
                }
                FieldEdit {
                    id: lowerBoundField
                    name: "lowerBound"
                    visible: fieldsColumn.randomMode
                    onValueChanged: {
                        if(parseFloat(value) > parseFloat(upperBoundField.value)) {
                            upperBoundField.value = value;
                        }
                    }
                }
                FieldEdit {
                    id: upperBoundField
                    name: "upperBound"
                    visible: fieldsColumn.randomMode
                    onValueChanged: {
                        if(parseFloat(value) < parseFloat(lowerBoundField.value)) {
                            lowerBoundField.value = value;
                        }
                    }
                }
                FieldEdit { name: "step" }
                FieldEdit { name: "numberShown" }
                FieldEdit { name: "indicesToGuess"; maxWidth: levelEditor.maxWidth }
                FieldEdit { name: "numberPropositions" }
            }
        }
    }

    readonly property string datasetEmpty: ("<ul><li>") +
    qsTr('Dataset is empty.') + ("</li></ul>")
    readonly property string startNumbersError: ("<ul><li>") +
        qsTr('"Start numbers" must contain only numbers, and not be empty.') + ("</li></ul>")
    readonly property string indicesNotNumber: ("<ul><li>") +
        qsTr('"Position of missing numbers" must contain only numbers, and not be empty.') + ("</li></ul>")
    readonly property string indicesTooLong: ("<ul><li>") +
        qsTr('"Position of missing numbers" contains too much numbers.') + ("</li></ul>")
    readonly property string indicesNotInRange: ("<ul><li>") +
        qsTr('"Position of missing numbers" contains invalid numbers.') + ("</li></ul>")

    // TODO: update function when values are proper numbers and arrays instead of strings...
    function validateDataset() {
        var errorMessage = ""
        var currentDataset = editor.mainModel.get(0)
        //check if dataset is not empty
        if(!currentDataset) {
            errorMessage = datasetEmpty;
            instructionPanel.setInstructionText(false, errorMessage);
            instructionPanel.open();
            return false;
        }
        var isValid = true;
        // if "Random start numbers" is not selected, check that "Start numbers" is not empty and contains only numbers
        if(!currentDataset.randomSubLevels) {
            var fixedLevels = JSON.parse(currentDataset.fixedLevels);
            if(fixedLevels.length < 1) {
                errorMessage += startNumbersError;
                isValid = false;
            } else {
                for(var i = 0; i < fixedLevels.length; i++) {
                    if(isNaN(fixedLevels[i])) {
                        errorMessage += startNumbersError;
                        isValid = false;
                        break;
                    }
                }
            }
        }
        var indicesToGuess = JSON.parse(currentDataset.indicesToGuess);
        // Check that "Position of missing numbers" is not empty and contains only numbers
        if(indicesToGuess.length < 1) {
            errorMessage += indicesNotNumber;
            isValid = false;
        } else {
            for(var i = 0; i < indicesToGuess.length; i++) {
                if(isNaN(indicesToGuess[i])) {
                    errorMessage += indicesNotNumber;
                    isValid = false;
                    break;
                }
            }
        }
        // Check that "Position of missing numbers" is not greater than "Sequence length" - 2
        if(indicesToGuess.length > Number(currentDataset.numberShown) - 2) {
            errorMessage += indicesTooLong;
            isValid = false;
        }
        // Check that each index in "Position of missing numbers" is between 0 and ("Sequence length" - 1)
        var maxIndexValue = Number(currentDataset.numberShown) - 1;
        for(var i = 0; i < indicesToGuess.length; i++) {
            var indiceNumber = Number(indicesToGuess[i]);
            if(indiceNumber < 0 || indiceNumber > maxIndexValue) {
                errorMessage += indicesNotInRange;
                isValid = false;
                break;
            }
        }
        if(!isValid) {
            instructionPanel.setInstructionText(false, errorMessage);
            instructionPanel.open();
        }
        return isValid;
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }
}
