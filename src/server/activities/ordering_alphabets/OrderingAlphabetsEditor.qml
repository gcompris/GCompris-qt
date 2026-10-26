/* GCompris - OrderingAlphabetsEditor.qml
 *
 * SPDX-FileCopyrightText:  2025 Timothée Giet <animtim@gmail.com>
 *                          2026 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import core 1.0 as GCompris

import "qrc:/gcompris/src/core/core.js" as Core

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
        ListElement { name: "values";    label: qsTr("Alphabets to sort"); type: "string_array"; def: '["a", "b", "c"]' }

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
                FieldEdit { name: "string_array" }
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
            var atLeastTwoLetters = true;
            var numbersAscendingOk = true
            if(numbersToSort.length < 2) {
                atLeastTwoLetters = false;
            }
            if(!atLeastTwoLetters) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1: "The list to sort" must contain at least 2 letters.').arg(datasetId+1) + ("</li>");
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
    }
}

