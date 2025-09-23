/* GCompris - DecimalAdditionEditor.qml
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
    required property string textActivityData               // Json array stringified as stored in database (dataset_/dataset_content)
    property ListModel mainModel: ({})                      // The main ListModel, declared as a property for dynamic creation
    readonly property var prototypeStack: [ mainPrototype, subPrototype ]   // A stack of two prototypes
    property alias scrollMainLevel: scrollMainLevel         // To be accessible from mainToolBar
    property alias scrollSubLevel: scrollSubLevel           // To be accessible from subToolBar

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "true" }
        ListElement { name: "subLevels";    label: qsTr("SubLevels");   type: "model";      def: "[]" }
    }

    ListModel {
        id: subPrototype
        property bool multiple: true
        // inputType is inserted in the global Component.onCompleted function.
        // We cannot implement "choice" directly as ListElement due to the fact
        // that the values are variables and only static values are accepted
        //ListElement { name: "inputType"; label: qsTr("Input Type"); type: "choice"; def: '["Fixed", "Range"]' }
        ListElement { name: "firstNumber"; label: qsTr("First Number"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,3]' ; stepSize: 1 ; decimals: 1 }
        ListElement { name: "secondNumber"; label: qsTr("Second Number"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,3]' ; stepSize: 1 ; decimals: 1 }
        ListElement { name: "minValue"; label: qsTr("Min Value"); type: "boundedDecimal"; def: "0" ; decimalRange :'[0,3]' ; stepSize: 1  ; decimals: 1 }
        ListElement { name: "maxValue"; label: qsTr("Max Value"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,3]' ; stepSize: 1 ; decimals: 1 }
    }

    RowLayout {
        anchors.fill: parent

        Rectangle {
            id: mainLevel
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: "snow"
            border.width: 1

            EditToolBar {
                id: mainToolBar
                aView: mainView
                aPrototype: mainPrototype
                aModel: mainModel
                aScrollView: editor.scrollMainLevel

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }

            ScrollView {
                id: scrollMainLevel
                anchors.top: mainToolBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 2
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                contentHeight: mainView.implicitHeight
                clip: true

                ColumnLayout {
                    id: mainView
                    property int current: -1
                    width: parent.width
                    spacing: 2

                    Repeater {
                        id: mainRepeater
                        model: mainModel
                        Item {
                            id: mainLineItem
                            Layout.fillWidth: true
                            height: childrenRect.height

                            Rectangle {
                                anchors.fill: parent
                                color: (mainView.current === index) ? Style.selectedPalette.highlight : (index % 2) ? Style.selectedPalette.base : Style.selectedPalette.alternateBase
                                border.width: mainMouseArea.containsMouse ? 1 : 0
                            }

                            MouseArea {
                                id: mainMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onClicked:  mainView.current = index
                            }

                            ColumnLayout {
                                id: fieldsLayout
                                // Properties required by FieldEdit. Must be in the parent
                                property ListModel currentPrototype: mainPrototype
                                property ListModel currentModel: mainModel
                                property int modelIndex: index
                                width: parent.width
                                spacing: 2
                                FieldEdit { name: "shuffle" }
                                FieldEdit { name: "subLevels" }
                            }
                        }
                    }

                    onCurrentChanged: {
                        subRepeater.model = mainModel.get(mainView.current).subLevels
                        subView.current = -1
                    }
                }
            }
        }

        Rectangle {
            id: subLevel
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "snow"
            border.width: 1

            EditToolBar {
                id: subToolBar
                aView: subView
                aPrototype: subPrototype
                aModel: (typeof subRepeater.model !== "undefined") ? subRepeater.model : null
                aScrollView: editor.scrollSubLevel

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }

            ScrollView {
                id: scrollSubLevel
                anchors.top: subToolBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 2
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                contentHeight: subView.implicitHeight
                clip: true

                ColumnLayout {
                    id: subView
                    property int current: -1
                    width: parent.width
                    spacing: 2

                    Repeater {  // this portion content needs to be changes for now
                        id: subRepeater
                        delegate: Item {
                            id: subLineItem
                            width: scrollSubLevel.width
                            height: childrenRect.height

                            Rectangle {
                                anchors.fill: parent
                                color: (subView.current === index) ? Style.selectedPalette.highlight : (index % 2) ? Style.selectedPalette.base : Style.selectedPalette.alternateBase
                                border.width: subMouseArea.containsMouse ? 1 : 0
                            }

                            MouseArea {
                                id: subMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                propagateComposedEvents: true
                                onClicked: subView.current = index
                            }

                            ColumnLayout {
                                id: subFieldsLayout
                                // Properties required by FieldEdit. Must be in the parent
                                property ListModel currentPrototype: subPrototype
                                property ListModel currentModel: subRepeater.model
                                property int modelIndex: index
                                spacing: 2
                                FieldEdit { name: "inputType" }
                                FieldEdit {
                                    name: "firstNumber"
                                    visible: inputType === "fixed"
                                }
                                FieldEdit {
                                    name: "secondNumber"
                                    visible: inputType === "fixed"
                                }

                                FieldEdit {
                                    name: "minValue"
                                    visible: inputType === "range"
                                }

                                FieldEdit {
                                    name: "maxValue"
                                    visible: inputType === "range"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    readonly property var inputTypeChoices: [
        { "datasetValue": "fixed", "displayedValue": qsTr("Fixed") },
        { "datasetValue": "range", "displayedValue": qsTr("Range") }
    ]

    Component.onCompleted: {
        // We insert dynamically here the choice
        subPrototype.insert(0, {name: "inputType", label: qsTr("Input Type"), type: "choice", values: inputTypeChoices})

        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
