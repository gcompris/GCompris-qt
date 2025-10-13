/* GCompris - AlgebraEditor.qml
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
    readonly property var prototypeStack: [ editor.mainPrototype, editor.subPrototype ]   // A stack of two prototypes

    readonly property string baseTeacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr('When "Random operands" is selected, if "Result value limit" is more than 0 it defines the maximum allowed for the result of each operation. It must be large enough to generate enough questions for the given number of sublevels using the minimum and maximum operand values.') + ("</li></ul><ul><li>") +

    qsTr('If "Random operands" is not selected, the sublevel list on the right side must not be empty.') + ("</li></ul>")

    property ListModel mainPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "randomOperands";  label: qsTr("Random operands");       type: "boolean";        def: "true" }
        ListElement { name: "numberSubLevels"; label: qsTr("Sublevels");             type: "boundedDecimal"; def: "5";  decimalRange: '[1, 10]'; stepSize: 1; decimals: 0 }
        ListElement { name: "min";             label: qsTr("Minimum operand value"); type: "boundedDecimal"; def: "0";  decimalRange: '[0, 1000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "max";             label: qsTr("Maximum operand value"); type: "boundedDecimal"; def: "10"; decimalRange: '[0, 1000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "limit";           label: qsTr("Result value limit");    type: "boundedDecimal"; def: "0";  decimalRange: '[0, 10000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "true" }
        ListElement { name: "operands";    label: qsTr("Sublevels");   type: "model";      def: "[]" }
    }

    property ListModel subPrototype: ListModel {
        property bool multiple: true
        ListElement { name: "first";  label: qsTr("First operand");  type: "boundedDecimal"; def: "0";  decimalRange: '[0, 1000]'; stepSize: 1; decimals: 0 }
        ListElement { name: "second"; label: qsTr("Second operand"); type: "boundedDecimal"; def: "10"; decimalRange: '[0, 1000]'; stepSize: 1; decimals: 0 }
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

            readonly property bool currentRandomOperands: current != -1 && editorModel.get(current).randomOperands

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

                    readonly property bool randomOperands: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                        currentModel.get(fieldsColumn.modelIndex).randomOperands : true

                    FieldEdit { name: "randomOperands" }

                    // For Range mode
                    FieldEdit { name: "numberSubLevels"; visible: fieldsColumn.randomOperands }
                    FieldEdit {
                        id: minField
                        name: "min"
                        visible: fieldsColumn.randomOperands
                        onValueChanged: {
                            if(parseFloat(value) > parseFloat(maxField.value)) {
                                maxField.value = value;
                            }
                        }
                    }
                    FieldEdit {
                        id: maxField
                        name: "max"
                        visible: fieldsColumn.randomOperands
                        onValueChanged: {
                            if(parseFloat(value) < parseFloat(minField.value)) {
                                minField.value = value;
                            }
                        }
                    }
                    FieldEdit { name: "limit"; visible: fieldsColumn.randomOperands }

                    // For Fixed mode
                    FieldEdit { name: "shuffle"; visible: !fieldsColumn.randomOperands }
                    FieldEdit { name: "operands"; visible: !fieldsColumn.randomOperands }
                }
            }

            onCurrentChanged: {
                subLevelEditor.current = -1;
                if(current > -1 && current < editorModel.count) {
                    subLevelEditor.editorModel = editor.mainModel.get(levelEditor.current).operands;
                } else {
                    subLevelEditor.editorModel = null;
                }
            }
        }

        EditorBox {
            id: subLevelEditor
            SplitView.minimumWidth: subLevelEditor.minWidth
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            editorPrototype: editor.subPrototype
            editorModel: null // set in levelEditor onCurrentChanged

            toolBarEnabled: levelEditor.current != -1 && !levelEditor.currentRandomOperands

            fieldsComponent: Component {
                Column {
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: subLevelEditor.editorPrototype
                    property ListModel currentModel: subLevelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins
                    FieldEdit {
                        name: "first"
                    }
                    FieldEdit {
                        name: "second"
                    }
                }
            }
        }
    }

    Component.onCompleted:  {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData));
    }
}

