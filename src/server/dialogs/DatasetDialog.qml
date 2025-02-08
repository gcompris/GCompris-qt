/* GCompris - DatasetDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.2

import "../singletons"
import "../components"

Popup {
    id: datasetDialog

    property string label: "To be modified in calling element."
    property bool textInputReadOnly: false
    property int activityIndex
    property bool addMode: true     // modify mode when false
    // Database columns
    property int modelIndex: 0      // index in Master.userModel
    property int dataset_Id: 0
    property string dataset_Name: ""
    property string dataset_Objective: ""
    property int difficulty: 1
    property string dataset_Content: ""

    anchors.centerIn: Overlay.overlay
    width: 550
    height: 500
    modal: true
    closePolicy: Popup.CloseOnEscape

    function openDatasetDialog(activity, selectedDataset) {
        activityIndex = activity
        if(selectedDataset === undefined) {
            addMode = true
            datasetName.text = ""
            datasetObjective.text = ""
            difficultyText.text = 1
            datasetContent.text = ""
        }
        else {
            addMode = false
            dataset_Id = selectedDataset.dataset_id
            datasetName.text = selectedDataset.dataset_name
            datasetObjective.text = selectedDataset.dataset_objective
            difficultyText.text = selectedDataset.dataset_difficulty
            datasetContent.text = selectedDataset.dataset_content
        }
        open()
    }

    function saveDataset() {
        if (datasetName.text === "") {
            errorDialog.message = [ qsTr("Dataset name is empty") ]
            errorDialog.open()
            return
        }

        var difficulty = Number(difficultyText.text)
        if (difficulty < 1 || difficulty > 6) {
            errorDialog.message = [ qsTr("Difficulty should be between 1 and 6") ]
            errorDialog.open()
            return
        }

        if (addMode) {
            // Add to database the user
            dataset_Id = Master.createDataset(datasetName.text, activityIndex, datasetObjective.text, difficulty, datasetContent.text)
            if (dataset_Id !== -1)
                datasetDialog.close()
        } else {
            if (Master.updateDataset(dataset_Id, datasetName.text, datasetObjective.text, difficulty, datasetContent.text))
                datasetDialog.close();
        }
    }

    onClosed: Master.filterDatasets(activityIndex, true)

    onOpened: {
        datasetName.forceActiveFocus();
    }

    background: Rectangle {
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

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

        TextArea {
            id: datasetContent
            Layout.fillWidth: true
            Layout.preferredHeight: 80
        }

        OkCancelButtons {
            onCancelled: datasetDialog.close()
            onValidated: saveDataset()
        }

        Keys.onEnterPressed: saveDataset()
        Keys.onReturnPressed: saveDataset()
        Keys.onEscapePressed: datasetDialog.close()
    }
}
