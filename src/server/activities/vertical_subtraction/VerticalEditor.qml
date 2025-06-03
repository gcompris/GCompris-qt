/* GCompris - VerticalEditor.qml for vertical_subtraction
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import QtQuick.Layouts

import "../../singletons"
import "../../components"

Item {
    id: editor
    required property string textActivityData               // Json array stringified as stored in database (dataset_/dataset_content)
    property ListModel mainModel: ({})                      // The main ListModel, declared as a property for dynamic creation
    readonly property var prototypeStack: [ mainPrototype ] // A stack of prototypes (Only one here. There is no nested Listmodel)
    property alias scrollMainLevel: scrollMainLevel         // To be accessible from mainToolBar

    ListModel {
        id: mainPrototype
        property bool multiple: false
        ListElement { name: "title";        label: qsTr("Title");               type: "string";     def: "" }
        ListElement { name: "nbSubLevel";   label: qsTr("Exercice count");      type: "int";        def: "10" }
        ListElement { name: "nbDigits";     label: qsTr("Number of digits");    type: "comboInt";   def: "[2,5]" }  // def is a value range for int combos
        ListElement { name: "nbLines";      label: qsTr("Number of lines");     type: "comboInt";   def: "[2,5]" }
        ListElement { name: "alreadyLaid";  label: qsTr("Already laid");        type: "boolean";    def: "true" }
        ListElement { name: "withCarry";    label: qsTr("With carry");          type: "boolean";    def: "true" }
    }

    RowLayout {
        anchors.fill: parent

        Rectangle {
            id: mainLevel
            Layout.preferredWidth: 450
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
                                onClicked: mainView.current = index
                            }
                            ColumnLayout {
                                id: fieldsLayout
                                // Properties required by FieldEdit. Must be in the parent
                                property ListModel currentPrototype: mainPrototype
                                property ListModel currentModel: mainModel
                                property int modelIndex: index
                                width: parent.width
                                spacing: 2
                                FieldEdit { name: "title" }
                                FieldEdit { name: "nbSubLevel" }
                                FieldEdit { name: "nbDigits" }
                                FieldEdit { name: "nbLines" }
                                FieldEdit { name: "alreadyLaid" }
                                FieldEdit { name: "withCarry" }
                            }
                        }
                    }
                }
            }
        }

        Component.onCompleted:  mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
