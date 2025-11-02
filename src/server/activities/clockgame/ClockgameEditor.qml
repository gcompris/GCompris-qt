/* GCompris - ClockgameEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
        property bool multiple: true
        ListElement { name: "numberOfSubLevels";   label: qsTr("Exercise count");      type: "int";        def: "10" }
        ListElement { name: "displayMinutesHand";     label: qsTr("Find minutes");    type: "boolean";   def: "true" }
        ListElement { name: "displaySecondsHand";      label: qsTr("Find seconds");     type: "boolean";   def: "true" }
        ListElement { name: "hoursVisible";  label: qsTr("Display hours numbers");        type: "boolean";    def: "true" }
        ListElement { name: "hoursMarksVisible";  label: qsTr("Display hours marks");        type: "boolean";    def: "true" }
        ListElement { name: "zonesVisible";  label: qsTr("Grey/white background between each hour");        type: "boolean";    def: "true" }
        ListElement { name: "minutesVisible";  label: qsTr("Display minutes numbers");        type: "boolean";    def: "true" }
       ListElement { name: "noHint";    label: qsTr("Hide the Hint button in the bar (which gives the current time)");          type: "boolean";    def: "true" }
        ListElement { name: "useFixedHours";  label: qsTr("Fixed hour");        type: "boolean";    def: "false" }
        ListElement { name: "fixedHours";  label: qsTr("Value");        type: "int";    def: "0" }
        ListElement { name: "useFixedMinutes";  label: qsTr("Fixed minutes");        type: "boolean";    def: "false" }
        ListElement { name: "fixedMinutes";  label: qsTr("Value");        type: "int";    def: "0" }
        ListElement { name: "useFixedSeconds";  label: qsTr("Fixed seconds");        type: "boolean";    def: "false" }
        ListElement { name: "fixedSeconds";  label: qsTr("Value");        type: "int";    def: "0" }
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

                readonly property bool useFixedHours: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).useFixedHours : false
                readonly property bool useFixedMinutes: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).useFixedMinutes : false
                readonly property bool useFixedSeconds: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).useFixedSeconds : false

                FieldEdit { name: "numberOfSubLevels" }
                FieldEdit { name: "displayMinutesHand" }
                FieldEdit { name: "displaySecondsHand" }
                FieldEdit { name: "hoursVisible" }
                FieldEdit { name: "hoursMarksVisible" }
                FieldEdit { name: "zonesVisible" }
                FieldEdit { name: "minutesVisible" }
                FieldEdit { name: "noHint" }
                FieldEdit { name: "useFixedHours" }
                FieldEdit { name: "fixedHours"; visible: fieldsColumn.useFixedHours }
                FieldEdit { name: "useFixedMinutes" }
                FieldEdit { name: "fixedMinutes"; visible: fieldsColumn.useFixedMinutes }
                FieldEdit { name: "useFixedSeconds" }
                FieldEdit { name: "fixedSeconds"; visible: fieldsColumn.useFixedSeconds }
            }
        }
    }

    Component.onCompleted:  mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
}
