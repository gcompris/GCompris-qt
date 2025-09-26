/* GCompris - ComparatorEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
    readonly property var prototypeStack: [ mainPrototype, subPrototype ]   // A stack of two prototypes

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "true" }
        ListElement { name: "subLevels";    label: qsTr("SubLevels");   type: "model";      def: "[]" }
    }

    ListModel {
        id: subPrototype
        property bool multiple: true
        ListElement { name: "leftNumber";       label: qsTr("Left number");     type: "number";        def: "" }
        ListElement { name: "rightNumber";      label: qsTr("Right number");    type: "number";         def: "" }
    }

    StyledSplitView {
        anchors.fill: parent

        EditorBox {
            id: levelEditor
            SplitView.minimumWidth: levelEditor.minWidth
            SplitView.preferredWidth: editor.width * 0.2
            SplitView.fillHeight: true
            editorPrototype: mainPrototype
            editorModel: editor.mainModel

            fieldsComponent: Component {
                Column {
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: levelEditor.editorPrototype
                    property ListModel currentModel: levelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins
                    FieldEdit { name: "shuffle" }
                    FieldEdit { name: "subLevels" }
                }
            }

            onCurrentChanged: {
                subLevelEditor.current = -1;
                if(current > -1 && current < editorModel.count) {
                    subLevelEditor.editorModel = editor.mainModel.get(levelEditor.current).subLevels;
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
            editorPrototype: subPrototype
            editorModel: null // set in levelEditor onCurrentChanged

            toolBarEnabled: levelEditor.current != -1

            fieldsComponent: Component {
                Column {
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: subLevelEditor.editorPrototype
                    property ListModel currentModel: subLevelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins
                    FieldEdit { name: "leftNumber" }
                    FieldEdit { name: "rightNumber" }
                }
            }
        }
    }

    Component.onCompleted: mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
}
