/* GCompris - EnumerateEditor.qml
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
        ListElement { name: "numberOfItemType"; label: qsTr("Number of item types"); type: "boundedDecimal"; def: "2";  decimalRange: '[1, 4]'; stepSize: 1; decimals: 0 }
        ListElement { name: "numberOfItemMax"; label: qsTr("Maximum number per item type"); type: "boundedDecimal"; def: "3";  decimalRange: '[1, 9]'; stepSize: 1; decimals: 0 }
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
                    FieldEdit { name: "numberOfItemType" }
                    FieldEdit { name: "numberOfItemMax" }
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
        } else {
            return true;
        }
    }
}
