/* GCompris - GuessnumberEditor.qml
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
        ListElement { name: "minNumber"; label: qsTr("Minimum number"); type: "boundedDecimal"; def: "1";  decimalRange: '[1, 999999]'; stepSize: 1; decimals: 0 }
        ListElement { name: "maxNumber"; label: qsTr("Maximum number"); type: "boundedDecimal"; def: "10";  decimalRange: '[2, 1000000]'; stepSize: 1; decimals: 0 }

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

                    FieldEdit {
                        id: minField
                        name: "minNumber"

                        onValueChanged: {
                            var intValue = parseInt(value);
                            if(intValue >= parseInt(maxField.value)) {
                                maxField.value = (intValue + 1).toString();
                            }
                        }

                    }
                    FieldEdit {
                        id: maxField
                        name: "maxNumber"

                        onValueChanged: {
                            var intValue = parseInt(value);
                            if(intValue <= parseInt(minField.value)) {
                                minField.value = (intValue - 1).toString();
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }

    function validateDataset() {
        var currentDataset = editor.mainModel.get(0);
        //check if dataset is not empty
        if(!currentDataset) {
            var globalError = ("<ul><li>") + qsTr('Dataset is empty.') + ("</li></ul>");
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
            return false;
        }

        return true;
    }
}
