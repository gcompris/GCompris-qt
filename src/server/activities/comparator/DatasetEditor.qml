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
import QtQuick.Layouts 1.15

import "../../singletons"
import "../../components"

ColumnLayout {

    function parseContent(content: string) {
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
    }

    Text {
        id: groupDialogText
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        horizontalAlignment: Text.AlignHCenter
        text: datasetEditor.label
        font {
            bold: true
            pixelSize: 20
        }
    }

    Text {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        text: qsTr("Dataset name for comparator")
        font.bold: true
        font {
            pixelSize: 15
        }
    }

    UnderlinedTextInput {
        id: datasetName
        Layout.fillWidth: true
        Layout.preferredHeight: Style.defaultLineHeight
        activeFocusOnTab: true
    }

    Text {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        text: qsTr("Difficulty")
        font.bold: true
        font {
            pixelSize: 15
        }
    }

    UnderlinedTextInput {
        id: difficultyText
        Layout.fillWidth: true
        Layout.preferredHeight: Style.defaultLineHeight
        activeFocusOnTab: true
    }

    Text {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        text: qsTr("Objective")
        font.bold: true
        font {
            pixelSize: 15
        }
    }

    UnderlinedTextInput {
        id: datasetObjective
        Layout.fillWidth: true
        Layout.preferredHeight: Style.defaultLineHeight
        activeFocusOnTab: true
    }

    Text {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        text: qsTr("Content")
        font.bold: true
        font {
            pixelSize: 15
        }
    }

    ListModel {
        id: dataModel
    }

    RowLayout {
        Layout.preferredHeight: 50
        Button {
            text: "remove last row"
            width: 50
            height: 50
            enabled: dataModel.count > 0
            onClicked: {
                print("remove row")
                dataModel.remove(dataModel.count-1);
            }
        }
        Button {
            text: "add new row"
            width: 50
            height: 50
            onClicked: {
                print("add row")
                dataModel.append({"leftNumber": 0, "rightNumber": 0});
            }
        }
    }
    ScrollView {
        Rectangle {
            color: "white"
        }
        Layout.preferredHeight: 400
        Layout.fillWidth: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        Column {
            id: datasetContent
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: parent.height
            Repeater {
            model: dataModel

            delegate: Row {
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
    }
}
