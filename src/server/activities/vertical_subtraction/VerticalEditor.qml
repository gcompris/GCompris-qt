/* GCompris - VerticalEditor.qml
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
    readonly property var prototypeStack: [ mainPrototype ] // A stack of prototypes (Only one here. There is no nested Listmodel)

    ListModel {
        id: mainPrototype
        property bool multiple: false
        ListElement { name: "nbSubLevel";   label: qsTr("Sublevels");           type: "int";        def: "5" }
        // Max 4 digits!
        ListElement { name: "nbDigits";     label: qsTr("Number of digits");    type: "comboInt";   def: "[2,4]" }  // def is a value range for int combos
        // Max 4 lines!
        ListElement { name: "nbLines";      label: qsTr("Number of lines");     type: "comboInt";   def: "[2,4]" }
        ListElement { name: "withCarry";    label: qsTr("With carry");          type: "boolean";    def: "true" }
        ListElement { name: "alreadyLaid";  label: qsTr("Already laid");        type: "boolean";    def: "true" }
        ListElement { name: "doItYourself";  label: qsTr("Write your operation");        type: "boolean";    def: "false" }
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

                readonly property bool doItYourself: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).doItYourself : false

                onDoItYourselfChanged: {
                    if(doItYourself) {
                        withCarryField.value = false;
                        alreadyLaidField.value = false;
                    } else {
                        withCarryField.value = lastWithCarry;
                        alreadyLaidField.value = lastAlreadyLaid;
                    }
                }

                FieldEdit { name: "nbSubLevel" }
                FieldEdit { name: "nbDigits" }
                FieldEdit { name: "nbLines" }
                FieldEdit {
                    id: withCarryField
                    name: "withCarry"
                    visible: !fieldsColumn.doItYourself
                }
                FieldEdit {
                    id: alreadyLaidField
                    name: "alreadyLaid"
                    visible: !fieldsColumn.doItYourself
                }
                FieldEdit { name: "doItYourself" }
            }
        }
    }

    Component.onCompleted:  mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
}
