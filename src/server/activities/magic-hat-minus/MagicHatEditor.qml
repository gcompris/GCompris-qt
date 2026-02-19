/* GCompris - MagicHatEditor.qml
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
    property string mode: "minus"
    required property string textActivityData               // Json array stringified as stored in database (dataset_/dataset_content)
    property ListModel mainModel: ({})                      // The main ListModel, declared as a property for dynamic creation
    readonly property var prototypeStack: [ editor.mainPrototype ]

    property int minFirstStarValue: mode === "minus" ? 2 : 1
    property int maxStarValue: mode === "minus" ? 10 : 9

    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('If "Use coefficients" is not checked:') + ("<ul><li>") +

    qsTr('"Maximum number of stars" and "Minimum number of stars" limit the number of stars for each row of the first operand. They must contain exactly 3 integer numbers, one for each row. The first entry must be between %1 and %2, the others between 0 and %2. Also the minimum numbers must not be larger than the corresponding maximum numbers.').arg(minFirstStarValue).arg(maxStarValue) + ("</li>") +

    (mode === "plus" ?
        ("<li>") + qsTr('"Maximum result per row" must be larger than any value in "Maximum number of stars".') + ("</li>") : "") + ("</ul></li></ul><ul><li>") +

    qsTr('If "Use coefficients" is checked:') + ("<ul><li>") +

    qsTr('"Row coefficients" must contain exactly 3 integer numbers. The first entry must be between 1 and 10, the others between 0 and 10, and the sum of the 3 entries must not be larger than 10.') + ("</li></ul></li></ul>")

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "useCoefficients";  label: qsTr("Use coefficients");       type: "boolean";        def: "false" }
        ListElement { name: "maxResultPerRow";  label: qsTr("Maximum result per row"); type: "boundedDecimal"; def: "10";  decimalRange: '[1, 10]'; stepSize: 1; decimals: 0}
        ListElement { name: "useDifferentStars";  label: qsTr("Use different star sets per row");       type: "boolean";        def: "false" }
        ListElement { name: "maxStars";    label: qsTr("Maximum number of stars"); type: "number_array"; def: '["2", "0", "0"]' }
        ListElement { name: "minStars";    label: qsTr("Minimum number of stars"); type: "number_array"; def: '["2", "0", "0"]' }
        ListElement { name: "multiplier";   label: qsTr("Coefficient multiplier");    type: "comboInt";   def: '["1", "10", "100"]'; }
        ListElement { name: "rowCoefficients";    label: qsTr("Row coefficients"); type: "number_array"; def: '["2", "1", "1"]' }
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

                readonly property bool useCoefficients: currentModel &&
                                currentModel.get(fieldsColumn.modelIndex) ?
                                currentModel.get(fieldsColumn.modelIndex).useCoefficients : false

                FieldEdit { name: "useCoefficients" }

                // For without coefficients
                FieldEdit { name: "maxResultPerRow"; visible: !fieldsColumn.useCoefficients }
                FieldEdit { name: "useDifferentStars"; visible: !fieldsColumn.useCoefficients }
                FieldEdit {
                    name: "maxStars"
                    maxNumberOfItems: 3
                    visible: !fieldsColumn.useCoefficients
                }
                FieldEdit {
                    name: "minStars"
                    maxNumberOfItems: 3
                    visible: !fieldsColumn.useCoefficients
                }

                // For with coefficients
                FieldEdit {
                    name: "multiplier"
                    specificComboInt: true
                    visible: fieldsColumn.useCoefficients
                }
                FieldEdit {
                    name: "rowCoefficients"
                    visible: fieldsColumn.useCoefficients
                    maxNumberOfItems: 3
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
            if(!currentDataset.useCoefficients) {
                // check only relevant values when not using coefficients
                var maxStars = JSON.parse(currentDataset.maxStars);
                var minStars = JSON.parse(currentDataset.minStars);

                // check the content of maxStars
                var maxStarsValid = true;
                if(maxStars.length < 3) {
                    maxStarsValid = false;
                } else {
                    for(var i = 0; i < maxStars.length; i++) {
                        var arrayValue = maxStars[i];
                        var arrayNumber = parseFloat(arrayValue);
                        var currentMinStarValue = i === 0 ? editor.minFirstStarValue : 0;
                        if(isNaN(arrayValue) || !Number.isInteger(arrayNumber) ||
                            arrayNumber < currentMinStarValue || arrayNumber > editor.maxStarValue) {
                            maxStarsValid = false;
                        }
                    }
                }
                if(!maxStarsValid) {
                    isValid = false;
                    textError = textError + ("<li>") + qsTr('Level %1 must contain exactly 3 integer numbers in "Maximum number of stars". The first entry must be between %2 and %3, the others between 0 and %3.').arg(datasetId+1).arg(editor.minFirstStarValue).arg(editor.maxStarValue) + ("</li>");
                }

                // check the content of minStars
                var minStarsValid = true;
                if(minStars.length < 3) {
                    minStarsValid = false;
                } else {
                    for(var i = 0; i < minStars.length; i++) {
                        var arrayValue = minStars[i];
                        var arrayNumber = parseFloat(arrayValue);
                        var currentMinStarValue = i === 0 ? editor.minFirstStarValue : 0;
                        if(isNaN(arrayValue) || !Number.isInteger(arrayNumber) ||
                            arrayNumber < currentMinStarValue || arrayNumber > parseFloat(maxStars[i])) {
                            minStarsValid = false;
                        }
                    }
                }
                if(!minStarsValid) {
                    isValid = false;
                    textError = textError + ("<li>") + qsTr('Level %1 must contain exactly 3 integer numbers in "Minimum number of stars". The first entry must be between %2 and %3, the others between 0 and %3, and each number must not be larger than the corresponding number in "Maximum number of stars".').arg(datasetId+1).arg(editor.minFirstStarValue).arg(editor.maxStarValue) + ("</li>");
                }

                // check the content of maxResultPerRow for Addition activity
                if(editor.mode === "plus") {
                    var maxResultPerRowValid = true;
                    var maxResultPerRowNumber = parseFloat(currentDataset.maxResultPerRow);
                    for(var i = 0; i < currentDataset.maxStars.length; i++) {
                        if(maxResultPerRowNumber <= parseFloat(currentDataset.maxStars[i])) {
                            maxResultPerRowValid = false;
                        }
                    }
                    if(!maxResultPerRowValid) {
                        isValid = false;
                        textError = textError + ("<li>") + qsTr('In Level %1, "Maximum result per row" must be larger than any value in "Maximum number of stars".').arg(datasetId+1) + ("</li>");
                    }
                }
            } else {
                // check only relevant values when using coefficients
                var rowCoefficients = JSON.parse(currentDataset.rowCoefficients);

                // check the content of rowCoefficients
                var rowCoefficientsValid = true;
                if(rowCoefficients.length < 3) {
                    rowCoefficientsValid = false;
                } else {
                    var coefficientsSum = 0;
                    for(var i = 0; i < rowCoefficients.length; i++) {
                        var arrayValue = rowCoefficients[i];
                        var arrayNumber = parseFloat(arrayValue);
                        var currentMinValue = i === 0 ? 1 : 0;
                        if(isNaN(arrayValue) || !Number.isInteger(arrayNumber) ||
                            arrayNumber < currentMinValue || arrayNumber > 10) {
                            rowCoefficientsValid = false;
                        } else {
                            coefficientsSum += arrayNumber;
                        }
                    }
                    if(coefficientsSum > 10) {
                        rowCoefficientsValid = false;
                    }
                }
                if(!rowCoefficientsValid) {
                    isValid = false;
                    textError = textError + ("<li>") + qsTr('Level %1 must contain exactly 3 integer numbers in "Row coefficients". The first entry must be between 1 and 10, the others between 0 and 10, and the sum of the 3 entries must not be larger than 10.').arg(datasetId+1) + ("</li>");
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

