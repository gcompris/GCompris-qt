/* GCompris - DatasetEditor.qml
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

import "../singletons"
import "../components"

ColumnLayout {

    function initialize(selectedDataset: var) {
        if(selectedDataset === undefined) {
            datasetName.text = ""
            datasetObjective.text = ""
            difficultyText.text = 1
            datasetContent.text = ""
        }
        else {
            dataset_Id = selectedDataset.dataset_id
            datasetName.text = selectedDataset.dataset_name
            datasetObjective.text = selectedDataset.dataset_objective
            difficultyText.text = selectedDataset.dataset_difficulty
            datasetContent.text = selectedDataset.dataset_content
        }
    }

    function getData() {
        return {
            "name": datasetName.text,
            "difficulty": Number(difficultyText.text),
            "objective": datasetObjective.text,
            "content": datasetContent.text
        };
    }

    Text {
        id: groupDialogText
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        horizontalAlignment: Text.AlignHCenter
        text: datasetDialog.label
        font {
            bold: true
            pixelSize: 20
        }
    }

    Text {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        text: qsTr("Dataset name")
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

    ScrollView {
        background: Rectangle {
            color: "white"
        }
        Layout.preferredHeight: 400
        Layout.fillWidth: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        //anchors.fill: parent
        TextArea {
            id: datasetContent
        }
    }
}
