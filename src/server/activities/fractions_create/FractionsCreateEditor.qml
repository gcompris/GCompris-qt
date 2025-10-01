/* GCompris - FractionsCreateEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Ashutosh Singh <ashutoshas2610@gmail.com>
 *
 * Authors:
 *   Ashutosh Singh <ashutoshas2610@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import "../../singletons"
import "../../components"

import ".."

DatasetEditorBase {
    id: editor
    required property string textActivityData
    property ListModel mainModel: ({})
    readonly property var prototypeStack: [ mainPrototype ]

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "numerator"; label: qsTr("Numerator"); type: "boundedDecimal"; def: "1"; decimalRange: "[1,24]"; stepSize: 1; decimals: 0 }
        ListElement { name: 'denominator'; label: qsTr("Denominator"); type: "boundedDecimal"; def: "2"; decimalRange: '[2,12]'; stepSize: 1; decimals: 0 }
        ListElement { name: "instruction";   label: qsTr("Instruction");    type: "string";  def: "" }
    }

    EditorBox {
        id: mainLevelEditor
        editorPrototype: mainPrototype
        editorModel: mainModel // set in levelEditor onCurrentChanged

        fieldsComponent: Component {
            Column {
                // Properties required by FieldEdit. Must be in the parent
                property ListModel currentPrototype: mainLevelEditor.editorPrototype
                property ListModel currentModel: mainLevelEditor.editorModel
                property int modelIndex: parent.index
                x: Style.margins
                y: Style.margins
                spacing: Style.smallMargins
                FieldEdit { name: "chartType" }
                FieldEdit {
                    id: numeratorField
                    name: "numerator"
                    onValueChanged: {
                        if(parseInt(value) > 2 * parseInt(denominatorField.value)) {
                            denominatorField.value = String(Math.ceil(parseInt(value) / 2));
                        }
                    }
                }
                FieldEdit {
                    id: denominatorField
                    name: "denominator"
                    onValueChanged: {
                        if(2 * parseInt(value) < parseInt(numeratorField.value)) {
                            numeratorField.value = String(parseInt(value) * 2);
                        }
                    }
                }
                FieldEdit { name: "instruction" }
            }
        }
    }

    readonly property var chartTypeChoices: [
        { "datasetValue": "rectangle", "displayedValue": qsTr("Rectangle") },
        { "datasetValue": "pie", "displayedValue": qsTr("Pie") }
    ]
    Component.onCompleted: {
        mainPrototype.append({name: "chartType", label: qsTr("Chart Type"), type: "choice", values: chartTypeChoices})

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
