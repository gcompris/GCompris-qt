/* GCompris - ActivityEditor.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
        ListElement { name: "leftNumber";       label: qsTr("Left number");     type: "number";        def: "" }
        ListElement { name: "rightNumber";      label: qsTr("Right number");    type: "number";         def: "" }
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

                    Repeater {
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
                                FieldEdit { name: "leftNumber" }
                                FieldEdit { name: "rightNumber" }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
}

/*function parseContent(content: string) {
        var json = JSON.parse(content);
        var values = json.values;
        for(var j = 0 ; j < 1 ; ++ j) {
            for(var i = 0; i < values[j].length; ++ i) {
               dataModel.append({"leftNumber": Number(values[j][i][0]), "rightNumber": Number(values[j][i][1])});
            }
        }
    }

    function initialize(selectedDataset: var) {
        dataModel.clear();
        if(selectedDataset === undefined) {
            datasetName.text = ""
            datasetObjective.text = ""
            difficultyText.text = 1
            dataModel.append({"leftNumber": 0, "rightNumber": 0});
        }
        else {
            dataset_Id = selectedDataset.dataset_id
            datasetName.text = selectedDataset.dataset_name
            datasetObjective.text = selectedDataset.dataset_objective
            difficultyText.text = selectedDataset.dataset_difficulty
            parseContent(selectedDataset.dataset_content)
        }
    }

    function getData() {
        var data = [];
        // Only one sublevel for now
        for(var j = 0; j < 1; ++ j) {
            var sublevel = [];
            for(var i = 0; i < dataModel.count; ++ i) {
                sublevel.push([Number(dataModel.get(i).leftNumber), Number(dataModel.get(i).rightNumber)]);
            }
            data.push(sublevel)
        }
        var content = { random: false, values: data };
        content = JSON.stringify(content);
        return {
            "name": datasetName.text,
            "difficulty": Number(difficultyText.text),
            "objective": datasetObjective.text,
            "content": content
        };
    }*/

/*            delegate: Row {
                width: datasetContent.width
                height: leftSpinBox.height
                spacing: 10
                SpinBox {
                    id: leftSpinBox
                    width: 200
                    editable: true
                    from: -10000000
                    to: 10000000
                    value: leftNumber
                    onValueChanged: dataModel.setProperty(index, "leftNumber", value)
                }
                SpinBox {
                    id: rightSpinBox
                    width: 200
                    editable: true
                    from: -10000000
                    to: 10000000
                    value: rightNumber
                    onValueChanged: dataModel.setProperty(index, "rightNumber", value)
                }
            }
}
        }
    }*/

