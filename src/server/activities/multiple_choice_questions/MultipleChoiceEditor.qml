/* GCompris - MultipleChoiceEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
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
        ListElement { name: "subLevels";    label: qsTr("Sublevels");   type: "model";      def: "[]" }
    }

    ListModel {
        id: subPrototype
        property bool multiple: true
        ListElement { name: "shuffleAnswers";       label: qsTr("Shuffle answers");     type: "boolean";        def: "true" }
        ListElement { name: "question";             label: qsTr("Question");            type: "string";         def: "" }
        ListElement { name: "answers";              label: qsTr("Answers");             type: "string_array";   def: "[]" }
        ListElement { name: "correctAnswers";       label: qsTr("Correct answers");     type: "string_array";   def: "[]" }
        ListElement { name: "correctAnswerText";    label: qsTr("Correct answer text"); type: "string";         def: "" }
        ListElement { name: "wrongAnswerText";      label: qsTr("Wrong answer text");   type: "string";         def: "" }
        // mode is inserted in the global Component.onCompleted function.
        // We cannot implement "choice" directly as ListElement due to the fact
        // that the values are variables and only static values are accepted
        //ListElement { name: "mode";                 label: qsTr("Mode");                type: "choice";         def: `[ "oneAnswer", "multipleAnswers" ]` }
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
                    FieldEdit { name: "shuffleAnswers" }
                    FieldEdit { name: "mode" }
                    FieldEdit { name: "question"; maxWidth: subLevelEditor.maxWidth }
                    FieldEdit { name: "answers"; maxWidth: subLevelEditor.maxWidth }
                    FieldEdit { name: "correctAnswers"; maxWidth: subLevelEditor.maxWidth}
                    FieldEdit { name: "correctAnswerText"; maxWidth: subLevelEditor.maxWidth }
                    FieldEdit { name: "wrongAnswerText"; maxWidth: subLevelEditor.maxWidth }
                }
            }
        }
    }

    readonly property var inputTypeChoices: [
        { "datasetValue": "oneAnswer", "displayedValue": qsTr("Single Answer") },
        { "datasetValue": "multipleAnswers", "displayedValue": qsTr("Multiple answers") }
    ]

    Component.onCompleted: {
        // We insert dynamically here the choice
        subPrototype.append({name: "mode", label: qsTr("Mode"), type: "choice", values: inputTypeChoices})

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
