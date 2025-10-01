/* GCompris - FractionsFindEditor.qml
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
        ListElement { name: "fixedNumerator";     label: qsTr("Use fixed numerator");      type: "boolean";      def: "false" }
        ListElement { name: "fixedDenominator";   label: qsTr("Use fixed denominator");    type: "boolean";      def: "false" }
        ListElement { name: "numerator"; label: qsTr("Numerator"); type: "boundedDecimal"; def: "1"; decimalRange: "[1,24]"; stepSize: 1; decimals: 0 }
        ListElement { name: 'denominator'; label: qsTr("Denominator"); type: "boundedDecimal"; def: "2"; decimalRange: '[2,12]'; stepSize: 1; decimals: 0 }
        ListElement { name: "maxFractions";   label: qsTr("Max displayed fractions");    type: "comboInt";   def: "[1,2]"; }
        ListElement { name: "random";   label: qsTr("Random fractions");    type: "boolean";      def: "true" }
    }

    EditorBox {
        id: mainLevelEditor
        editorPrototype: mainPrototype
        editorModel: mainModel // set in levelEditor onCurrentChanged

        fieldsComponent: Component {
            Column {
                id: fieldsColumn
                // Properties required by FieldEdit. Must be in the parent
                property ListModel currentPrototype: mainLevelEditor.editorPrototype
                property ListModel currentModel: mainLevelEditor.editorModel
                property int modelIndex: parent.index
                x: Style.margins
                y: Style.margins
                spacing: Style.smallMargins

                readonly property bool random: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                currentModel.get(fieldsColumn.modelIndex).random : false

                FieldEdit { name: "chartType" }
                FieldEdit { name: "random" }
                FieldEdit {
                    id: numeratorField
                    name: "numerator"
                    visible: fieldsColumn.random === false
                    onValueChanged: {
                        if(parseInt(value) > 2 * parseInt(denominatorField.value)) {
                            denominatorField.value = String(Math.ceil(parseInt(value) / 2));
                        }
                    }
                }
                FieldEdit {
                    id: denominatorField
                    visible: fieldsColumn.random === false
                    name: "denominator"
                    onValueChanged: {
                        if(2 * parseInt(value) < parseInt(numeratorField.value)) {
                            numeratorField.value = String(parseInt(value) * 2);
                        }
                    }
                }
                FieldEdit {
                    id: fixedNumeratorField
                    name: "fixedNumerator"
                    onJsonValueChanged: {
                        if(jsonValue && fixedDenominatorField.jsonValue) {
                            fixedDenominatorField.value = "false";
                        }
                    }
                }
                FieldEdit {
                    id: fixedDenominatorField
                    name: "fixedDenominator"
                    onJsonValueChanged: {
                        if(jsonValue && fixedNumeratorField.jsonValue) {
                            fixedNumeratorField.value = "false";
                        }
                    }
                }
                FieldEdit {
                    name: "maxFractions"
                    visible: fieldsColumn.random
                }
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
