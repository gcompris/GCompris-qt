/* GCompris - TargetEditor.qml
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

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "subLevels"; label: qsTr("Sublevels"); type: "boundedDecimal"; def: "5";  decimalRange: '[1, 10]'; stepSize: 1; decimals: 0 }
        ListElement { name: "arrows"; label: qsTr("Number of darts"); type: "boundedDecimal"; def: "3";  decimalRange: '[1, 6]'; stepSize: 1; decimals: 0 }
        ListElement { name: "circleValues"; label: qsTr("Target values"); type: "number_array"; def: '[]' }
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

                    FieldEdit { name: "subLevels" }
                    FieldEdit { name: "arrows" }
                    FieldEdit { name: "circleValues"; maxNumberOfItems: 14 }
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
        //check if dataset is not empty
        if(!currentDataset) {
            globalError = ("<ul><li>") + qsTr('Dataset is empty.') + ("</li></ul>");
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
            return false;
        }
        for(var datasetId = 0; datasetId < editor.mainModel.count; ++datasetId) {
            currentDataset = editor.mainModel.get(datasetId);
            // Check that circleValues is not empty, and that no field is empty.
            var circleValuesJson = JSON.parse(currentDataset.circleValues);
            if(circleValuesJson.length < 1) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('"Target values" for level %1 must not be empty.').arg(datasetId+1) + ("</li>");
            } else {
                for(var i = 0; i < circleValuesJson.length; i++) {
                    var circleValue = Number(circleValuesJson[i]);
                    if(isNaN(circleValue) || !Number.isInteger(circleValue)) {
                        isValid = false;
                        textError = textError + ("<li>") + qsTr('"Target values" for level %1 contains invalid entries.').arg(datasetId+1) + ("</li>");
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
}
